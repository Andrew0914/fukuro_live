defmodule FukuroLiveWeb.Live.BoardLive do
  use Surface.LiveView
  alias FukuroLiveWeb.Live.Components.{Canvas, Client, Service, Resource, ArrowConnector}
  alias Phoenix.PubSub
  @topic "notifications"

  def mount(_params, _sssion, socket) do
    PubSub.subscribe FukuroLive.PubSub, @topic
    state = %{items: [], connectors: []}
    {:ok, assign(socket, state)}
  end

  def handle_info(%{ payload: %{"data" => data } }, socket) do
    {:noreply,  socket |> assign_items(data) |> assign_connectors }
  end

  def assign_items(socket, items) do
    socket |> assign(items: parse_items(items))
  end

  defp get_module_component(type) do
    %{"client" => Client, "service" => Service, "resource" => Resource} |> Map.get(type)
  end

  defp parse_time(item) do
    component = get_module_component(item["type"])

    %{
      props:
        item
        |> Map.delete("type")
        |> Enum.map(fn {key, value} -> {String.to_existing_atom(key), value} end),
      component: component
    }
  end

  def parse_items(items) do
    items |> Enum.map(&parse_time/1)
  end

  def assign_connectors(socket) do
    socket
    |> assign(connectors: generate_connectors(socket.assigns.items))
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

end
