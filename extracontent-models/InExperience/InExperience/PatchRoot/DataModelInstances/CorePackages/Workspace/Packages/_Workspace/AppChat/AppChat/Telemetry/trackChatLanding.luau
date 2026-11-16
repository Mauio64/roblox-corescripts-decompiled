local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

require(parent.SocialCommon)

local FFlagAppChatTTIStaleGuard = require(AppChat.Flags.FFlagAppChatTTIStaleGuard)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local v = false

local function trackChatLanding(entryPoint)
	pcall(function()
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
	end)
end

return trackChatLanding
