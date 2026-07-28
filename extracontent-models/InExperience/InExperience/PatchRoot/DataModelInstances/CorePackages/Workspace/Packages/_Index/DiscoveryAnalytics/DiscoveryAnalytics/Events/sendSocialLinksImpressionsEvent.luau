local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("SocialLinksImpressionsEventHundredthsPercent", 10000)
local v6 = t.strictInterface({
	item_positions = t.string,
	social_link_urls = t.string,
	social_link_types = t.string,
	social_link_display_type = t.string,
	assignment_id = t.number,
	assignment_type = t.string,
	page = t.string
})
local t1 = {
	eventName = "EdpSocialLinksImpressions",
	description = "Impressions for social links on EDP",
	lastUpdated = {
		25,
		12,
		10
	},
	backends = { "EventIngest" },
	throttlingPercentage = v5
}

return function(t2: {[any]: any}) -- line: 40
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v9, v10 = v6(t2)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("SocialLinksImpressionsEventInterface", v10)
	end

	TelemetryService:LogEvent(t1, {
		customFields = t2,
		standardizedFields = { "addSessionInfo" }
	})
end
