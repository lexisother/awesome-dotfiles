--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi

-- import widgets
local task_list = require("widgets.task-list")
local github_activity_widget  = require("awesome-wm-widgets.github-activity-widget.github-activity-widget")
local logout_popup = require("awesome-wm-widgets.logout-popup-widget.logout-popup")
local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")

-- define module table
local top_panel = {}


-- ===================================================================
-- Bar Creation
-- ===================================================================


top_panel.create = function(s)
   local panel = awful.wibar({
      screen = s,
      position = "top",
      ontop = true,
      height = beautiful.top_panel_height,
      width = s.geometry.width,
   })

   panel:setup {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      task_list.create(s),
      require("widgets.calendar").create(s),
      {
         layout = wibox.layout.fixed.horizontal,
         wibox.layout.margin(wibox.widget.systray(), dpi(5), dpi(5), dpi(5), dpi(5)),
         require("widgets.bluetooth"),
         require("widgets.network")(),
         require("widgets.battery"),
         github_activity_widget{
            username = 'lexisother'
         },
         logout_popup.widget{
            bg_color = "#2d2d2d", accent_color = "#393939", text_color = '#ffffff', icon_size = 40, icon_margin = 16,
            onlock = function () awful.spawn.with_shell('i3lock-fancy') end,
            phrases = {'Go away.'}
         },
         cpu_widget{
            width = 70,
            step_width = 2,
            step_spacing = 0,
            color = "#434c5e"
         },
         wibox.layout.margin(require("widgets.layout-box"), dpi(5), dpi(5), dpi(5), dpi(5))
      }
   }


   -- ===================================================================
   -- Functionality
   -- ===================================================================


   -- hide panel when client is fullscreen
   local function change_panel_visibility(client)
      if client.screen == s then
         panel.ontop = not client.fullscreen
      end
   end

   -- connect panel visibility function to relevant signals
   client.connect_signal("property::fullscreen", change_panel_visibility)
   client.connect_signal("focus", change_panel_visibility)

end

return top_panel
