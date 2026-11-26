local CoreGui = game:GetService("CoreGui")

local shell = CoreGui.RobloxGui.Modules:FindFirstChild("Shell")
local v5, v6

if shell then
	v5 = require("@game/CoreGui/RobloxGui/Modules/Shell/Actions/RemoveScreen")
	v6 = require("@game/CoreGui/RobloxGui/Modules/Shell/EventHub")
else
	v5 = nil
	v6 = nil
end

return function(p2)
	return function(object)
		if not shell then
			return
		end

		local screenList = object:getState().ScreenList

		if screenList then
			spawn(function()
				object:dispatch(v5(screenList[1]))
				v6:dispatchEvent(v6.Notifications.NavigateToRobuxScreen)
			end)
		end
	end
end
