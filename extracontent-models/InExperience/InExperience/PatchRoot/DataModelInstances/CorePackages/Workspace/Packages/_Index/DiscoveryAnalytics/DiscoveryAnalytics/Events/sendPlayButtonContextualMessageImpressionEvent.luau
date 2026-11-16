local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("PlayButtonContextualMessageImpressionHundredthsPercent", 10000)

local strictInterface = t.strictInterface({
	universeId = t.string,
	playabilityStatus = t.optional(t.string),
	contextualMessage = t.string
})

local v = {
	eventName = "playButtonContextualMessageImpression",
	description = "Impressions for play button contextual message",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 5, 6 }
}

local function sendPlayButtonContextualMessageImpressionEvent(customFields, eventContext: string?)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("PlayButtonContextualMessageImpressionInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = customFields
	})
end

return sendPlayButtonContextualMessageImpressionEvent
