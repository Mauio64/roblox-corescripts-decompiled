local TelemetryService = game:GetService("TelemetryService")
local CorePackages = game:GetService("CorePackages")
local t = require(CorePackages.Packages.t)
local DiscoveryEventErrorLogger = require(CorePackages.Workspace.Packages.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("ExpandableTextImpressionsEventHundredthsPercent", 10000)
local t1 = {
	eventName = "expandableTextImpression",
	description = "Impressions for thresholds reached on expandable text content",
	lastUpdated = {
		26,
		3,
		25
	},
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = v5
}
local v7 = t.strictInterface({
	impressionThreshold = t.number,
	isButtonExpanded = t.optional(t.boolean),
	interactionUuid = t.string,
	contentType = t.string,
	pageContext = t.string,
	itemId = t.number,
	componentType = t.string
})

return function(p1) -- line: 31
	-- upvalues: v7 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v9, v10 = v7(p1)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("ExpandableTextImpressionInvalidInterface", v10)
	end

	TelemetryService:LogEvent(t1, {
		customFields = p1,
		standardizedFields = {
			"addSessionInfo",
			"addOSInfo"
		}
	})
end
