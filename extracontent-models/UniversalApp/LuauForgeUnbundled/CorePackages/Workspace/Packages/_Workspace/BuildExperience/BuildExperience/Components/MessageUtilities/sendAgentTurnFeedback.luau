local TelemetryService = game:GetService("TelemetryService")

local CreatorAgentChat = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAgentChat")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Chat/chatTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MessageUtilities/FeedbackAction")

local Debug = CreatorAgentChat.debug

local v5 = {
	eventName = "agentTurnFeedback",
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("AgentTurnFeedbackEventThrottleHundredthsPercent", 0),
	lastUpdated = { 2026, 7, 30 },
	description = "Fires when a user interacts with an agent turn (thumbs up, thumbs down, copy, or revert)."
}

local function sendAgentTurnFeedback(p2, data)
	local v6 = {
		action = p2,
		universeid = data.universeId,
		placeid = data.placeId,
		sessionid = data.sessionId,
		sequenceId = data.sequenceId,
		turnId = data.turnId
	}

	Debug.log("info", "agent_turn_feedback sending event", { customFields = v6 })

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addUserId" },
		customFields = v6
	})
end

return sendAgentTurnFeedback
