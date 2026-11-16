local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("PlayButtonContextualMessageImpressionHundredthsPercent", 10000)

local strictInterface = t.strictInterface({
	universeId = t.string,
	playabilityStatus = t.optional(t.string),
	contextualMessage = t.string
})

local v5 = {
	eventName = "playButtonContextualMessageImpression",
	description = "Impressions for play button contextual message",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 5, 6 }
}

local function sendPlayButtonContextualMessageImpressionEvent(p2, p3)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("PlayButtonContextualMessageImpressionInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
		customFields = p2
	})
end

return sendPlayButtonContextualMessageImpressionEvent
