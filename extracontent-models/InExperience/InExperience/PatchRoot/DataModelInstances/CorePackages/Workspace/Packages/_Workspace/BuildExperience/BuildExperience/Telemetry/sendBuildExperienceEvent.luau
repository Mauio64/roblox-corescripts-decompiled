local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local BuildExperience = script:FindFirstAncestor("BuildExperience")

local FFlagBuildExperienceChatOpenId = require(BuildExperience.Flags.FFlagBuildExperienceChatOpenId)
local getBuildExperienceEventFields = require(script.Parent.getBuildExperienceEventFields)

local v = {
	eventName = "buildExperienceEvent",
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("BuildExperienceEventThrottleHundredthsPercent", 0),
	lastUpdated = FFlagBuildExperienceChatOpenId and { 2026, 11, 11 } or { 2026, 11, 2 },
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

	if FFlagBuildExperienceChatOpenId then
		customFields = getBuildExperienceEventFields(eventType, data, p)
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addUserId", "addSessionId" },
		customFields = customFields
	})
end

return sendBuildExperienceEvent
