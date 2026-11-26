require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsUtils").createSessionScopedSignal

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local trackChatLanding = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/trackChatLanding")

local function createLastEntryPointStore()
	local sessionScopedSignal, v5 = createSessionScopedSignal("NotSet")

	return {
		getLastEntryPoint = sessionScopedSignal,
		enteredChatFromEntryPoint = function(value)
			if FFlagAppChatPerfTracking then
				trackChatLanding(value)
			end

			v5(value or "NotSet")
		end,
		reset = function()
			v5("NotSet")
		end
	}
end

return createLastEntryPointStore
