local TelemetryService = game:GetService("TelemetryService")
local v2 = game:DefineFastInt("CoachmarkImpressionThrottleHundredthsPercent", 10000)
local t1 = {
	eventName = "coachmarkImpression",
	description = "Sent when a coachmark is shown",
	backends = { "EventIngest" },
	throttlingPercentage = v2,
	lastUpdated = {
		26,
		6,
		16
	}
}
local t2 = {
	"addOSInfo",
	"addSessionInfo"
}

local function sendCoachmarkImpression(s1: string, b1: boolean) -- line: 18
	-- upvalues: TelemetryService (copy), t1 (copy), t2 (copy)
	TelemetryService:LogEvent(t1, {
		standardizedFields = t2,
		customFields = {
			collectionServiceAnchorTag = s1,
			hasMedia = b1
		}
	})
end

return sendCoachmarkImpression
