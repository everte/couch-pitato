# template
# =========
#
# <div id="container" phx-hook="Colors">

# app.js
# =========
#
# let Hooks = {}
# Hooks.Colors = {
#   mounted(){
#     this.handleEvent("colors", ({colors}) => {
#       Coloris({el: '.testcolour', alpha: false, focusInput: false, swatches: colors})
#     })
#   }
# }
#
# let liveSocket = new LiveSocket("/live", Socket, {
#   hooks: Hooks,
#  params: {_csrf_token: csrfToken}
# })
#
def mount(_, _, socket) do
  {:ok, push_event(socket, "colors", %{colors: my_colors})}
end