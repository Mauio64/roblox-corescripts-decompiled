local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger
local SafetyResourceBannerAction = require("@game/CorePackages/Workspace/Packages/_Index/DiscoveryAnalytics/DiscoveryAnalytics/Constants/SafetyResourceBannerAction")

local v5 = {
	eventName = "safetyResourceBanner",
	backends = { "EventIngest" },
	throttlingPercentage = game:DefineFastInt("SafetyResourceBannerEventThrottlingHundredthsPercent", 10000),
	lastUpdated = { 26, 10, 9 },
	description = "Impression or click on a search safety resource banner (e.g. SSH hotline, TVE diversion)"
}

local strictInterface = t.strictInterface({
	action = t.literal(SafetyResourceBannerAction.Impression, SafetyResourceBannerAction.LinkTapped, SafetyResourceBannerAction.Continue),
	moderationCategory = t.string,
	url = t.string,
	surface = t.string,
	textFilterRequestId = t.string
})

return function(p2)
	local v6, v7 = strictInterface(p2)

	if v6 then
		TelemetryService:LogEvent(v5, {
			standardizedFields = { "addSessionInfo", "addSessionId", "addOSInfo" },
			customFields = p2
		})
	else
		discoveryEventErrorLogger.reportError("SafetyResourceBannerEventInvalidInterface", v7)
	end
end
