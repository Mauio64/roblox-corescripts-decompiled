local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("SocialLinksImpressionsEventHundredthsPercent", 10000)

local strictInterface = t.strictInterface({
	item_positions = t.string,
	social_link_urls = t.string,
	social_link_types = t.string,
	social_link_display_type = t.string,
	assignment_id = t.number,
	assignment_type = t.string,
	page = t.string
})

local v5 = {
	eventName = "EdpSocialLinksImpressions",
	description = "Impressions for social links on EDP",
	lastUpdated = { 25, 12, 10 },
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt
}

return function(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("SocialLinksImpressionsEventInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		customFields = p2,
		standardizedFields = { "addSessionInfo" }
	})
end
