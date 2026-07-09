local GuiService = game:GetService("GuiService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local SetModerationStatus = require(Modules.LuaApp.Actions.Moderation.SetModerationStatus)

return function() -- line: 6
	-- upvalues: SetModerationStatus (copy), GuiService (copy), NotificationType (copy)
	return function(p1) -- line: 8
		-- upvalues: SetModerationStatus (copy), GuiService (copy), NotificationType (copy)
		p1:dispatch(SetModerationStatus(false))
		GuiService:BroadcastNotification("", NotificationType.RESTART_LUA_APP)
	end
end
