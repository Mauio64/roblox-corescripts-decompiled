local TelemetryService = game:GetService("TelemetryService")
local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local CreatorAgentChat = require(BuildExperienceParent.DataHydration.CreatorAgentChat)

require(BuildExperience.Chat.chatTypes)
require(script.Parent.FeedbackAction)

local debug = CreatorAgentChat.debug
local t1 = {
	eventName = "agentTurnFeedback",
	description = "Fires when a user reacts to an agent turn (thumbs up, thumbs down, or revert).",
	backends = {
		"Points",
		"EventIngest"
	},
	throttlingPercentage = game:DefineFastInt("AgentTurnFeedbackEventThrottleHundredthsPercent", 0),
	lastUpdated = {
		2026,
		6,
		12
	}
}

local function sendAgentTurnFeedback(p1, p2) -- line: 24
	-- upvalues: debug (copy), TelemetryService (copy), t1 (copy)
	local t2 = {
		action = p1,
		universeid = p2.universeId,
		placeid = p2.placeId,
		sessionid = p2.sessionId,
		sequenceId = p2.sequenceId
	}

	debug.log("info", "agent_turn_feedback sending event", {
		customFields = t2
	})
	TelemetryService:LogEvent(t1, {
		standardizedFields = { "addUserId" },
		customFields = t2
	})
end

return sendAgentTurnFeedback
