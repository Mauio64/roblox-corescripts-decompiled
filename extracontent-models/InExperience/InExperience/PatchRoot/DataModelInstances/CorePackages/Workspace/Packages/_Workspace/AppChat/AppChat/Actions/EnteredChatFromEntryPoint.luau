local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local Rodux = require(parent.Rodux)

local SocialCommon = require(parent.SocialCommon)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatTTIStaleGuard = require(AppChat.Flags.FFlagAppChatTTIStaleGuard)
local SharedFlags = require(parent.SharedFlags)
local FFlagSharedChatEntryPointAction = SharedFlags.FFlagSharedChatEntryPointAction
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

if FFlagSharedChatEntryPointAction then
	return SocialCommon.Actions.EnteredChatFromEntryPoint
end

local v = false

return Rodux.makeActionCreator(script.Name, function(entryPoint)
	if FFlagAppChatPerfTracking then
		if entryPoint == nil then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatLandingTTI, {})

			if FFlagAppChatTTIStaleGuard then
				AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {})
			end
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatLandingTTI, {
				entryPoint = entryPoint,
				coldStart = not v
			})

			v = true
		end
	end

	return { entryPoint = entryPoint }
end)
