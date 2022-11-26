local awful = require('awful')
local gears = require('gears')
local wibox = require("wibox")
local playerctl_widget = wibox.widget.textbox()

local cmd = [[bash /home/alyxia/scripts/mpris.sh]]
gears.timer.start_new(1, function()
   awful.spawn.with_line_callback(cmd, {
      stdout = function(line)
         playerctl_widget:set_text(line)
      end
   })
   return true
end)

return playerctl_widget
