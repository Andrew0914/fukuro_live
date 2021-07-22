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
      if item["resources"] |> length() > 0 do
        if ids |> Enum.member?(item["id"]) do
          id_index = ids |> Enum.find_index(fn id -> id == item["id"] end)
          new_ids = List.insert_at(ids, id_index, item["resources"]) |> List.flatten()
          build_simulation_order(schema, index + 1, new_ids)
        else
          build_simulation_order(schema, index + 1, ids ++ item["resources"] ++ [item["id"]])
        end
      else
        build_simulation_order(schema, index + 1, ids ++ [item["id"]])
      end
    else
      ids |> Enum.uniq()
    end
  end

  def create_simulation(simulation_order, live_items) do
    simulation_order
    |> Enum.reduce([], fn item_id, acc ->
      live_item =
        live_items |> Enum.find(fn item -> item.props |> Keyword.get(:id) == item_id end)

      simulation_props = live_item.props |> Keyword.drop([:x, :y, :label, :id, :resources, :type])

      if live_item.props[:resources] |> length() <= 0 do
        update_item =
          live_item
          |> Map.replace(
            :props,
            live_item.props
            |> Keyword.put_new(:pid, simulate(live_item.props[:type], simulation_props))
          )

        acc ++ [update_item]
      else
        simulated_resources =
          live_item.props[:resources]
          |> Enum.map(fn resource_id ->
            acc |> Enum.find(fn item -> item.props[:id] == resource_id end)
          end)

        update_item =
          live_item
          |> Map.replace(
            :props,
            live_item.props
            |> Keyword.put_new(
              :pid,
              simulate(
                live_item.props[:type],
                simulation_props |> Keyword.put_new(:resources, simulated_resources)
              )
            )
          )

        acc ++ [update_item]
      end
    end)
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
