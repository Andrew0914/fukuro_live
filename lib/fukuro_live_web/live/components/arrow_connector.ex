defmodule FukuroLiveWeb.Live.Components.ArrowConnector do
  # uses
  use Surface.Component

  # props
  prop x, :integer, required: true
  prop y, :integer, required: true
  prop x2, :integer, required: true
  prop y2, :integer, required: true

  # data
  data start_x, :integer, default: 0
  data start_y, :integer, default: 0
  data end_x, :integer, default: 0
  data end_y, :integer, default: 0
  data arrowhead_polygon, :string, default: ""

  # methods
  def update(assigns, socket) do
    {:ok, socket |> assign_line_coordinates(assigns) |> assign_arrowhead_polygon()}
  end

  def assign_line_coordinates(socket, assigns) do
    socket
    |> assign(start_x: assigns.x + 100)
    |> assign(start_y: assigns.y + 25)
    |> assign(end_x: assigns.x2)
    |> assign(end_y: assigns.y2 + 25)
  end

  def assign_arrowhead_polygon(%{assigns: %{end_x: end_x, end_y: end_y}} = socket) do
    socket |> assign(arrowhead_polygon: arrowhead_points(end_x, end_y))
  end

  def arrowhead_points(x, y) do
    "#{x},#{y} #{x - 4},#{y + 4} #{x - 4},#{y - 4} "
  end

  def render(assigns) do
    ~F"""
    <g>
      <line x1={@start_x} y1={@start_y} x2={@end_x} y2={@end_y} stroke="black" stroke-width="1" />
      <polygon points={@arrowhead_polygon} fill="black" stroke="black" strokke-width="1" />
    </g>
      
    """
  end
end
