local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

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

local v = {
	eventName = "EdpSocialLinksImpressions",
	description = "Impressions for social links on EDP",
	lastUpdated = { 25, 12, 10 },
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt
}

return function(customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("SocialLinksImpressionsEventInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		customFields = customFields,
		standardizedFields = { "addSessionInfo" }
	})
end
