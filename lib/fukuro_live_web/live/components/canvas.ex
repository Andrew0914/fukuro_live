defmodule FukuroLiveWeb.Live.Components.Canvas do
  # uses
  use Surface.Component

  #props
  prop viewBox, :string, required: true
  slot default

  #methods
  def render(assigns) do
    ~F"""
    <section class="canvas">
      <svg viewBox={ @viewBox }>
        <defs>
          <rect id="component" width="90" height="50" />
        </defs>
        <#slot />
      </svg>
    </section>
    """
  end
end