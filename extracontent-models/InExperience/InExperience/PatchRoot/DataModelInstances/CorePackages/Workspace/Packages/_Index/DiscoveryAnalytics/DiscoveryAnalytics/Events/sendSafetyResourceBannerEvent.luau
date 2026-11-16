local TelemetryService = game:GetService("TelemetryService")
local DiscoveryAnalytics = script:FindFirstAncestor("DiscoveryAnalytics")
local parent = DiscoveryAnalytics.Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local SafetyResourceBannerAction = require(DiscoveryAnalytics.Constants.SafetyResourceBannerAction)

local v = {
	eventName = "safetyResourceBanner",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SafetyResourceBannerEventThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 9 },
	description = "Impression or click on a search safety resource banner (e.g. SSH hotline, TVE diversion)"
}

local strictInterface = t.strictInterface({
	action = t.literal(
		SafetyResourceBannerAction.Impression,
		SafetyResourceBannerAction.LinkTapped,
		SafetyResourceBannerAction.Continue
	),
	moderationCategory = t.string,
	url = t.string,
	surface = t.string,
	textFilterRequestId = t.string
})

return function(customFields)
	local v2, v3 = strictInterface(customFields)

	if v2 then
		TelemetryService:LogEvent(v, {
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = customFields
		})
	else
		DiscoveryEventErrorLogger.reportError("SafetyResourceBannerEventInvalidInterface", v3)
	end
end
