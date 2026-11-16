local TelemetryService = game:GetService("TelemetryService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent
local CreatorAgentChat = require(parent.DataHydration.CreatorAgentChat)

require(BuildExperience.Chat.chatTypes)
require(script.Parent.FeedbackAction)

local Debug = CreatorAgentChat.debug

local v = {
	eventName = "agentTurnFeedback",
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("AgentTurnFeedbackEventThrottleHundredthsPercent", 0),
	lastUpdated = { 2026, 7, 30 },
	description = "Fires when a user interacts with an agent turn (thumbs up, thumbs down, copy, or revert)."
}

local function sendAgentTurnFeedback(action, data)
	local customFields = {
		action = action,
		universeid = data.universeId,
		placeid = data.placeId,
		sessionid = data.sessionId,
		sequenceId = data.sequenceId,
		turnId = data.turnId
	}

	Debug.log("info", "agent_turn_feedback sending event", { customFields = customFields })

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addUserId" },
		customFields = customFields
	})
end

return sendAgentTurnFeedback
