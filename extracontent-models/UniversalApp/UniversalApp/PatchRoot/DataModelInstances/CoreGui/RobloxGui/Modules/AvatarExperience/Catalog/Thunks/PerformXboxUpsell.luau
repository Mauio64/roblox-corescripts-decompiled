local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Shell = Modules:FindFirstChild("Shell")
local RemoveScreen = nil
local EventHub = nil

if Shell then
	RemoveScreen = require(Modules.Shell.Actions.RemoveScreen)
	EventHub = require(Modules.Shell.EventHub)
end

return function(_) -- line: 66
	-- upvalues: Shell (copy), RemoveScreen (ref), EventHub (ref)
	return function(p2) -- line: 67
		-- upvalues: Shell (copy), RemoveScreen (ref), EventHub (ref)
		if not Shell then
			return
		end

		local ScreenList = p2:getState().ScreenList

		if ScreenList then
			spawn(function() -- line: 80
				-- upvalues: ScreenList (copy), p2 (copy), RemoveScreen (ref), EventHub (ref)
				local v8 = ScreenList[1]

				p2:dispatch(RemoveScreen(v8))
				EventHub:dispatchEvent(EventHub.Notifications.NavigateToRobuxScreen)
			end)
		end
	end
end
