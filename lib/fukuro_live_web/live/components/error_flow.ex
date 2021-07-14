defmodule FukuroLiveWeb.Live.Components.ErrorFlow do
   # uses
  use Surface.Component

  prop x1, :integer, required: true
  prop y1, :integer, required: true
  prop x2, :integer, required: true
  prop y2, :integer, required: true
  prop time, :number, default: 1.6

  def render(assigns) do
    ~F"""
    <svg  x={@x1} y={@y1} viewBox="0 0 365.71733 365"  width="15px" height="15px">
      <g fill="#f44336">
        <path d="m356.339844 296.347656-286.613282-286.613281c-12.5-12.5-32.765624-12.5-45.246093 0l-15.105469 15.082031c-12.5 12.503906-12.5 32.769532 0 45.25l286.613281 286.613282c12.503907 12.5 32.769531 12.5 45.25 0l15.082031-15.082032c12.523438-12.480468 12.523438-32.75.019532-45.25zm0 0"/>
        <path d="m295.988281 9.734375-286.613281 286.613281c-12.5 12.5-12.5 32.769532 0 45.25l15.082031 15.082032c12.503907 12.5 32.769531 12.5 45.25 0l286.632813-286.59375c12.503906-12.5 12.503906-32.765626 0-45.246094l-15.082032-15.082032c-12.5-12.523437-32.765624-12.523437-45.269531-.023437zm0 0"/>
      </g>
      <animate attributeType="XML" attributeName="y" from={@y1 - 5} to={@y2 - 10} dur={@time} repeatCount="indefinite"/>
      <animate attributeType="XML" attributeName="x" from={@x1 - 5} to={@x2 - 10} dur={@time} repeatCount="indefinite"/>
    </svg>
    """
  end
end