defmodule FukuroLiveWeb.Live.BoardLive do
  use Surface.LiveView
  alias FukuroLiveWeb.Live.Components.{Canvas, Client, Service, Resource, ArrowConnector}

  def mount(_params, _sssion, socket) do
    {:ok, socket |> assign_items() |> assign_connectors()}
  end

  def assign_items(socket) do
    socket |> assign(items: parse_items())
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

  def parse_items() do
    dummy_schema() |> Enum.map(&parse_time/1)
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

  def dummy_schema() do
    [
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
        "max_request_capacity" => 50,
        "x" => 290,
        "y" => 100,
        "resources" => ["resource_1"],
        "concurrency" => 5
      },
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
      }
    ]
  end
end
