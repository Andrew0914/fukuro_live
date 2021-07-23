defmodule FukuroLiveWeb.Live.Components.ArrowConnectorFlow do
  # uses
  use Surface.Component

  prop x1, :integer, required: true
  prop y1, :integer, required: true
  prop x2, :integer, required: true
  prop y2, :integer, required: true

  def render(assigns) do
    ~F"""
    <g>
    {#for time <- 1..5}
      <circle cx={@x1} cy={@y1} r="5" stroke="black" stroke-width="1" fill="white">
        <animate attributeType="XML" attributeName="cx" from={@x1} to={@x2} dur={"1.#{time}"} repeatCount="indefinite"/>
        <animate attributeType="XML" attributeName="cy" from={@y1} to={@y2} dur={"1.#{time}"} repeatCount="indefinite"/>
      </circle>
    {/for}
    </g>
    """
  end
end
