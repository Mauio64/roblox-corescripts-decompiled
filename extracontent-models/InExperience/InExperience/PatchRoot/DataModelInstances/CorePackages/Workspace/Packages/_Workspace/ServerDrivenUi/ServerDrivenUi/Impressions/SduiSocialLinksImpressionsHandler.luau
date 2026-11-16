local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendSocialLinksImpressionsEvent = DiscoveryAnalytics.Events.sendSocialLinksImpressionsEvent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors

local v = {}

local function SduiSocialLinksImpressionsHandler(p, list, p2, data, _: number?)
	if not data then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions,
			{
				name = "SduiSocialLinksImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p.appPage
		)
		return
	end

	if #list == 0 or #(p2 or v) == 0 then
		p.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions, {
			name = "SduiSocialLinksImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#(p2 or v)}`
		}, p.appPage)
		return
	end

	local v2 = {}
	local socialLinkUrls = {}
	local socialLinkTypes = {}

	for _, item in list do
		local v3 = p2[item]

		if not v3 then
			continue
		end

		table.insert(v2, item)
		table.insert(socialLinkUrls, v3.socialLinkUrl or "")
		table.insert(socialLinkTypes, v3.socialLinkType or "")
	end

	if #v2 == 0 then
		p.dependencies.logger.reportError(
			SduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions,
			{
				name = "SduiSocialLinksImpressionsHandler",
				message = "No valid items found for impression indexes"
			},
			p.appPage
		)
	else
		sendSocialLinksImpressionsEvent({
			item_positions = table.concat(v2, ","),
			social_link_urls = table.concat(socialLinkUrls, ","),
			social_link_types = table.concat(socialLinkTypes, ","),
			social_link_display_type = data.socialLinkDisplayType,
			assignment_id = tonumber(data.assignmentId),
			assignment_type = data.assignmentType,
			page = p.appPage
		})
	end
end

return SduiSocialLinksImpressionsHandler
