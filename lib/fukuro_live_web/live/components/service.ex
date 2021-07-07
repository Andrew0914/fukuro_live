defmodule FukuroLiveWeb.Live.Components.Service do
  # uses
  use Surface.LiveComponent

  @doc "The x axis position of the service"
  prop x, :integer, required: true
  @doc "The y axis position of the service"
  prop y, :integer, required: true
  @doc "The label to identify service component"
  prop label, :string, required: true
  @doc "Max request capacity for the service"
  prop max_request_capacity, :integer, default: 10
  @doc "Concurrency, how many request can handle at a time"
  prop concurrency, :integer, default: 10
  @doc "List of related resources"
  prop resources, :list, default: []

  # data
  data label_position, :tuple, default: {0, 0}
  data stats_position, :tuple, default: {0, 0}
  data request_in_progress, :integer, default: 0
  data failure_rate, :number, default: 0.0

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

  def calculate_and_assign_label_position(
        %{assigns: %{label_position: {lx, ly}, x: x, y: y}} = socket
      ) do
    socket |> assign(label_position: {lx + x + 15, ly + y + 30})
  end

  def calculate_and_assign_stats_position(
        %{assigns: %{stats_position: {sx, sy}, x: x, y: y}} = socket
      ) do
    socket |> assign(stats_position: {sx + x, sy + y + 65})
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
        stroke="blue"
        stroke-width="1"
        fill="transparent"
        />
      <text x={elem(@label_position, 0)} y={elem(@label_position, 1)}  font-size="14" font-family="Arial">
        {@label}
      </text>
      <text x={elem(@stats_position, 0)} y={elem(@stats_position, 1)}  font-size="12" font-family="Arial" fill="red">
        Req. in progress {@request_in_progress}
      </text>
      <text x={elem(@stats_position, 0)} y={fix_stat_y_postion(@stats_position)}  font-size="12" font-family="Arial">
        Max request capacity {@max_request_capacity}
      </text>
      <text x={elem(@stats_position, 0)} y={fix_stat_y_postion(@stats_position, 35)}  font-size="12" font-family="Arial" fill="red">
        Failure Rate {@failure_rate} %
      </text>
    </g>
    """
  end
end
