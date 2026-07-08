local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local Rodux = require(AppChatParent.Rodux)

require(AppChatParent.SocialCommon)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local u6 = false

return Rodux.makeActionCreator(script.Name, function(p1) -- line: 16
	-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), u6 (ref)
	if FFlagAppChatPerfTracking then
		if p1 == nil then
			AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatLandingTTI, {})
		else
			AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatLandingTTI, {
				entryPoint = p1,
				coldStart = not u6
			})
			u6 = true
		end
	end

	return {
		entryPoint = p1
	}
end)
