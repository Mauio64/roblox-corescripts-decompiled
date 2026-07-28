local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("PlayButtonContextualMessageImpressionHundredthsPercent", 10000)
local v6 = t.strictInterface({
	universeId = t.string,
	playabilityStatus = t.optional(t.string),
	contextualMessage = t.string
})
local t1 = {
	eventName = "playButtonContextualMessageImpression",
	description = "Impressions for play button contextual message",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		5,
		6
	}
}

local function sendPlayButtonContextualMessageImpressionEvent(p1, s1: string?) -- line: 23
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v11, v12 = v6(p1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("PlayButtonContextualMessageImpressionInvalidInterface", v12)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = {
			"addSessionInfo",
			"addSessionId",
			"addOSInfo"
		},
		customFields = p1
	})
end

return sendPlayButtonContextualMessageImpressionEvent
