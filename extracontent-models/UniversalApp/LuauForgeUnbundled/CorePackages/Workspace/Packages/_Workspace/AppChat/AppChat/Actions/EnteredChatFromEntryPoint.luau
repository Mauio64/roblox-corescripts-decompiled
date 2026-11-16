local Rodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Rodux")

local SocialCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialCommon")

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local FFlagAppChatTTIStaleGuard = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatTTIStaleGuard")
local fFlagSharedChatEntryPointAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").FFlagSharedChatEntryPointAction
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

if fFlagSharedChatEntryPointAction then
	return SocialCommon.Actions.EnteredChatFromEntryPoint
end

local v5 = false

return Rodux.makeActionCreator("EnteredChatFromEntryPoint", function(p2)
	if FFlagAppChatPerfTracking then
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
	end

	return { entryPoint = p2 }
end)
