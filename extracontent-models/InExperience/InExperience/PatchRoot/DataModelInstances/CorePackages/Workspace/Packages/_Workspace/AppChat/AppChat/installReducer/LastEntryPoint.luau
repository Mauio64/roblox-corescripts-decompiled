local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent

local Rodux = require(parent.Rodux)
require(parent.SocialCommon)
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local trackChatLanding = require(AppChat.Telemetry.trackChatLanding)

return Rodux.createReducer("NotSet", {
	[EnteredChatFromEntryPoint.name] = function(_, p)
		if FFlagAppChatPerfTracking then
			trackChatLanding(p.entryPoint)
		end

		return p.entryPoint
	end
})
