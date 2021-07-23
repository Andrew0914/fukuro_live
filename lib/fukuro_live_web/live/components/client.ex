defmodule FukuroLiveWeb.Live.Components.Client do
  # uses
  use Surface.LiveComponent

  @doc "The x axis position of the client"
  prop x, :integer, required: true
  @doc "The y axis position of the client"
  prop y, :integer, required: true
  @doc "The label to identify client component"
  prop label, :string, required: true
  @doc "Request rate for the client"
  prop request_rate, :integer, default: 1

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

  def render(assigns) do
    ~F"""
    <g id={@id} >
      <use
        xlink:href="#component"
        x={@x}
        y={@y}
        stroke="green"
        stroke-width="1"
        fill="transparent"
        />
      <text x={elem(@label_position, 0)} y={elem(@label_position, 1)}  font-size="14" font-family="Arial">
        {@label}
      </text>
      <text x={elem(@stats_position, 0)} y={elem(@stats_position, 1)}  font-size="12" font-family="Arial">
        Request rate: {@request_rate} req/sec
      </text>
    </g>
    """
  end
end
