defmodule FukuroLive.SimulationUtils do
  def dummy_schema() do
    [
      %{
        "id" => "resource_1",
        "label" => "Resource 1",
        "type" => "resource",
        "min_latency" => 1000,
        "max_latency" => 2000,
        "failure_rate" => 20,
        "concurrency" => 5,
        "x" => 530,
        "y" => 100,
        "resources" => []
      },
      %{
        "id" => "client_1",
        "label" => "Client 1",
        "type" => "client",
        "request_rate" => 10,
        "x" => 50,
        "y" => 100,
        "resources" => ["service_1"]
      },
      %{
        "id" => "service_1",
        "label" => "Service 1",
        "type" => "service",
        "x" => 290,
        "y" => 100,
        "resources" => ["resource_1"],
        "concurrency" => 5
      }
    ]
  end

  def build_simulation_order(schema, index \\ 0, ids \\ []) do
    item = schema |> Enum.at(index)

    if index < schema |> length() do
      if ids |> Enum.member?(item["id"]) do
        id_index = ids |> Enum.find_index(fn id -> id == item["id"] end)
        new_ids = List.insert_at(ids, id_index, item["resources"]) |> List.flatten()
        build_simulation_order(schema, index + 1, new_ids)
      else
        build_simulation_order(schema, index + 1, ids ++ item["resources"] ++ [item["id"]])
      end
    else
      ids |> Enum.uniq()
    end
  end

  def update_live_item_with_simulation(live_item, simulation_props, simulated_items) do
    pid = simulate(live_item, simulation_props, simulated_items)
    props_with_pid = live_item.props |> Keyword.put_new(:pid, pid)

    live_item
    |> Map.replace(:props, props_with_pid)
  end

  def create_simulation(simulation_order, live_items) do
    simulation_order
    |> Enum.reduce([], fn item_id, acc ->
      live_item =
        live_items |> Enum.find(fn item -> item.props |> Keyword.get(:id) == item_id end)

      simulation_props = live_item.props |> Keyword.drop([:x, :y, :label, :type])

      acc ++ [update_live_item_with_simulation(live_item, simulation_props, acc)]
    end)
  end

  def simulate(item, props, simulated_items) do
    resources =
      item.props[:resources]
      |> Enum.map(fn resource_id ->
        simulated_items
        |> Enum.find(fn simulated_item -> simulated_item.props[:id] == resource_id end)
      end)

    simulation_props = props |> Keyword.put_new(:resources, resources)

    simulate(item.props[:type], simulation_props)
  end

  def simulate("resource", props) do
    {:ok, pid} = Disssim.Model.Resource.start(props)
    pid
  end

  def simulate("client", props) do
    {:ok, pid} = Disssim.Model.Client.start(props)
    pid
  end

  def simulate("service", props) do
    {:ok, pid} = Disssim.Model.Service.start(props)
    pid
  end
end
