defmodule FukuroLiveWeb.Live.Components.Canvas do
  # uses
  use Surface.Component

  # props
  @doc "The viewBox of the svg canvas"
  prop viewBox, :string, required: true
  @doc "Slot for the content or schema figures"
  slot default

  # methods
  def render(assigns) do
    ~F"""
    <section class="canvas">
      <svg viewBox={ @viewBox }>
        <defs>
          <rect id="component" width="100" height="50" />
        </defs>
        <#slot />
      </svg>
    </section>
    """
  end
end
