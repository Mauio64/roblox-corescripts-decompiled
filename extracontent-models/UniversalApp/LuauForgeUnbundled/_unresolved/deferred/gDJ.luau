local TelemetryService = game:GetService("TelemetryService")
local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)
local discoveryEventErrorLogger = require("@luauforge/bundled/egz").DiscoveryEventErrorLogger

local v5 = {
	eventName = "expandableTextImpression",
	description = "Impressions for thresholds reached on expandable text content",
	lastUpdated = { 26, 3, 25 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("ExpandableTextImpressionsEventHundredthsPercent", 10000)
}

local strictInterface = t.strictInterface({
	impressionThreshold = t.number,
	isButtonExpanded = t.optional(t.boolean),
	interactionUuid = t.string,
	contentType = t.string,
	pageContext = t.string,
	itemId = t.number,
	componentType = t.string
})

return function(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("ExpandableTextImpressionInvalidInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		customFields = p2,
		standardizedFields = { "addSessionInfo", "addOSInfo" }
	})
end
