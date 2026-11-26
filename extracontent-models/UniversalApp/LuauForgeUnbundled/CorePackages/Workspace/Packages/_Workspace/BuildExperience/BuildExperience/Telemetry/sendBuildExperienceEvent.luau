local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")

local FFlagBuildExperienceChatOpenId = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceChatOpenId")
local getBuildExperienceEventFields = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Telemetry/getBuildExperienceEventFields")

local v5 = {
	eventName = "buildExperienceEvent",
	backends = { "Points", "EventIngest" },
	throttlingPercentage = game:DefineFastInt("BuildExperienceEventThrottleHundredthsPercent", 0),
	lastUpdated = FFlagBuildExperienceChatOpenId and { 2026, 11, 11 } or { 2026, 11, 2 },
	description = "Client events for Build tab interactions, chat opens, prompt chips, Library browsing and contextual prompt submissions, prompt send lifecycle (start, stall, stop, failure), playtesting, private invites, private playtest preview taps, monetization, ad-upsell impressions and clicks, and Analytics page goal card and locked-action impressions and clicks."
}

local function sendBuildExperienceEvent(p2, data, p3)
	local v6 = {
		eventType = p2,
		universeId = data.universeId,
		placeId = data.placeId,
		conversationId = data.conversationId,
		messageId = data.messageId,
		turnId = data.turnId,
		parameters = 0
	}
	local v7 = if p3 then HttpService:JSONEncode(p3) else nil
	v6.parameters = v7

	if FFlagBuildExperienceChatOpenId then
		v6 = getBuildExperienceEventFields(p2, data, p3)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addUserId", "addSessionId" },
		customFields = v6
	})
end

return sendBuildExperienceEvent
