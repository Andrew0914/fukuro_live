defmodule FukuroLiveWeb.Live.BoardLive do
  use Surface.LiveView
  alias FukuroLiveWeb.Live.Components.{Canvas, Client, Service, Resource, ArrowConnector}
  alias FukuroLive.SimulationUtils

  def mount(_params, _session, socket) do
    # timer_update()
    {:ok,
     socket
     |> assign_schema()
     |> assign_live_items()
     |> assign_live_connector()
     |> add_simulate_processes()}
  end

  def handle_info({:tick}, %{assigns: %{live_items: live_items}} = socket) do
    live_items
    |> Enum.each(fn item ->
      send_update(item.component, item.props)
    end)

    {:noreply, socket}
  end

  def assign_schema(socket) do
    socket |> assign(schema: SimulationUtils.dummy_schema())
  end

  def assign_live_items(%{assigns: %{schema: schema}} = socket) do
    socket |> assign(live_items: parsed_items(schema))
  end

  def assign_live_connector(%{assigns: %{live_items: live_items}} = socket) do
    socket
    |> assign(live_connectors: generate_connectors(live_items))
  end

  defp get_module_component(type) do
    %{"client" => Client, "service" => Service, "resource" => Resource} |> Map.get(type)
  end

  defp parse_time(item) do
    component = get_module_component(item["type"])

    %{
      props:
        item
        |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end),
      component: component
    }
  end

  def parsed_items(schema) do
    schema |> Enum.map(&parse_time/1)
  end

  def generate_connectors(items) do
    items
    |> Enum.reduce([], fn item, acc ->
      acc ++ generate_connector_properties(item, items)
    end)
  end

  def generate_connector_properties(item, items) do
    item.props[:resources]
    |> Enum.map(fn resource_id ->
      destiny = items |> Enum.find(fn inner_item -> inner_item.props[:id] == resource_id end)

      [
        x: item.props[:x],
        y: item.props[:y],
        origin: item.props[:id],
        destiny: destiny.props[:id],
        x2: destiny.props[:x],
        y2: destiny.props[:y]
      ]
    end)
  end

  def timer_update() do
    :timer.send_interval(1000, self, {:tick})
  end

  def add_simulate_processes(%{assigns: %{live_items: live_items, schema: schema}} = socket) do
    items_with_simulation =
      SimulationUtils.build_simulation_order(schema)
      |> SimulationUtils.create_simulation(live_items)

    socket |> assign(live_items: items_with_simulation) |> assign(is_simulated: true)
  end
end
