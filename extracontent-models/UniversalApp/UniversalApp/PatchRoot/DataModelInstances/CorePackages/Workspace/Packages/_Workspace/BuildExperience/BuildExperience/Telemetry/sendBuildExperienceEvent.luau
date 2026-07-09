local HttpService = game:GetService("HttpService")
local TelemetryService = game:GetService("TelemetryService")
local t1 = {
	eventName = "buildExperienceEvent",
	description = "Client events for Build tab interactions (impression, clicks, playtest).",
	backends = {
		"Points",
		"EventIngest"
	},
	throttlingPercentage = game:DefineFastInt("BuildExperienceEventThrottleHundredthsPercent", 0),
	lastUpdated = {
		2026,
		6,
		24
	}
}

local function sendBuildExperienceEvent(s1: string, t2: {[any]: any}, t3: {[any]: any}?) -- line: 20
	-- upvalues: HttpService (copy), TelemetryService (copy), t1 (copy)
	local t4 = {
		eventType = s1,
		universeId = t2.universeId,
		placeId = t2.placeId,
		conversationId = t2.conversationId,
		messageId = t2.messageId,
		parameters = if not t3 then nil else HttpService:JSONEncode(t3)
	}

	TelemetryService:LogEvent(t1, {
		standardizedFields = {
			"addUserId",
			"addSessionId"
		},
		customFields = t4
	})
end

return sendBuildExperienceEvent
