local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local v = {
	eventName = "buildExperienceEvent",
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("BuildExperienceEventThrottleHundredthsPercent", 0),
	lastUpdated = { 2026, 11, 2 },
	description = "Client events for Build tab interactions, chat opens, prompt chips, Library browsing and contextual prompt submissions, prompt send lifecycle (start, stall, stop, failure), playtesting, private invites, private playtest preview taps, monetization, ad-upsell impressions and clicks, and Analytics page goal card and locked-action impressions and clicks."
}

local function sendBuildExperienceEvent(eventType: string, data, p)
	local customFields = {
		eventType = eventType,
		universeId = data.universeId,
		placeId = data.placeId,
		conversationId = data.conversationId,
		messageId = data.messageId,
		turnId = data.turnId,
		parameters = 0
	}
	local parameters

	if p then
		parameters = HttpService:JSONEncode(p)
	end

	customFields.parameters = parameters

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addUserId", "addSessionId" },
		customFields = customFields
	})
end

return sendBuildExperienceEvent
