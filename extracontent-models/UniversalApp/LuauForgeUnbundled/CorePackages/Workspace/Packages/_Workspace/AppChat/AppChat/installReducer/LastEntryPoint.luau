local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/EnteredChatFromEntryPoint")

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local trackChatLanding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/trackChatLanding")

return Rodux.createReducer("NotSet", {
	[EnteredChatFromEntryPoint.name] = function(p2, p3)
		if FFlagAppChatPerfTracking then
			trackChatLanding(p3.entryPoint)
		end

		return p3.entryPoint
	end
})
