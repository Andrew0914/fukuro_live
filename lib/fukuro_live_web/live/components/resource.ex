defmodule FukuroLiveWeb.Live.Components.Resource do
  # uses
  use Surface.LiveComponent

  # properties
  prop x, :integer, required: true
  prop y, :integer, required: true
  prop label, :string, required: true
  prop max_latency, :integer, default: 10
  prop min_latency, :integer, default: 1
  prop concurrency, :integer, default: 10
  prop failure_rate, :number, default: 0.0

  # data
  data label_position, :tuple, default: {0, 0}
  data stats_position, :tuple, default: {0, 0}

  # methods
  def update(assings, socket) do
    {:ok,
     socket
     |> assign_initials(assings)
     |> calculate_and_assign_label_position()
     |> calculate_and_assign_stats_position()}
  end

  def assign_initials(socket, assings) do
    socket |> assign(assings)
  end

  def calculate_and_assign_label_position(%{assigns: %{x: x, y: y}} = socket) do
    socket |> assign(label_position: {x + 15, y + 30})
  end

  def calculate_and_assign_stats_position(%{assigns: %{x: x, y: y}} = socket) do
    socket |> assign(stats_position: {x, y + 65})
  end

  defp fix_stat_y_postion(stats_position, fix \\ 17) do
    elem(stats_position, 1) + fix
  end

  def render(assigns) do
    ~F"""
    <g id={@id} >
      <use
        xlink:href="#component"
        x={@x}
        y={@y}
        stroke="orange"
        stroke-width="1"
        fill="transparent"
        />
      <text x={elem(@label_position, 0)} y={elem(@label_position, 1)}  font-size="14" font-family="Arial">
        {@label}
      </text>
      <text x={elem(@stats_position, 0)} y={elem(@stats_position, 1)}  font-size="12" font-family="Arial">
        Min latency {@min_latency}
      </text>
      <text x={elem(@stats_position, 0)} y={fix_stat_y_postion(@stats_position)}  font-size="12" font-family="Arial">
        Max latency {@max_latency}
      </text>
      <text x={elem(@stats_position, 0)} y={fix_stat_y_postion(@stats_position, 35)}  font-size="12" font-family="Arial">
        Failure Rate {@failure_rate} %
      </text>
    </g>
    """
  end
end
