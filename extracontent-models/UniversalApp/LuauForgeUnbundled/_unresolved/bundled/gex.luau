local GuiService = game:GetService("GuiService")

local module = require("@luauforge/bundled/fot")
local module2 = require("@luauforge/bundled/gey")

local fFlagUseSignalsForModeration = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseSignalsForModeration

local getModerationStore = if fFlagUseSignalsForModeration then require("@luauforge/bundled/fQv").GetModerationStore else nil

return function()
	return function(object)
		if fFlagUseSignalsForModeration then
			getModerationStore(false).setModerationStatus(false)
		else
			object:dispatch(module2(false))
		end

		GuiService:BroadcastNotification("", module.RESTART_LUA_APP)
	end
end
