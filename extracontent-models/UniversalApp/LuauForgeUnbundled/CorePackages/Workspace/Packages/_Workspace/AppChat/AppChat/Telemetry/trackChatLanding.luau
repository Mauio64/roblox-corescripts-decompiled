require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")

local FFlagAppChatTTIStaleGuard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTTIStaleGuard")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local v5 = false

local function trackChatLanding(p2)
	pcall(function()
		if p2 == nil then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatLandingTTI, {})

			if FFlagAppChatTTIStaleGuard then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {})
			end
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatLandingTTI, {
				entryPoint = p2,
				coldStart = not v5
			})

			v5 = true
		end
	end)
end

return trackChatLanding
