local sendSocialLinksImpressionsEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.sendSocialLinksImpressionsEvent

local sduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem").SduiErrors

local v5 = {}

local function SduiSocialLinksImpressionsHandler(p2, list, p3, data, p4)
	if not data then
		p2.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions,
			{
				name = "SduiSocialLinksImpressionsHandler",
				message = "Missing collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	if #list == 0 or #(p3 or v5) == 0 then
		p2.dependencies.logger.reportError(sduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions, {
			name = "SduiSocialLinksImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#(p3 or v5)}`
		}, p2.appPage)
		return
	end

	local v6 = {}
	local socialLinkUrls = {}
	local socialLinkTypes = {}

	for k, item in list do
		local v7 = p3[item]

		if not v7 then
			continue
		end

		table.insert(v6, item)
		table.insert(socialLinkUrls, v7.socialLinkUrl or "")
		table.insert(socialLinkTypes, v7.socialLinkType or "")
	end

	if #v6 == 0 then
		p2.dependencies.logger.reportError(
			sduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions,
			{
				name = "SduiSocialLinksImpressionsHandler",
				message = "No valid items found for impression indexes"
			},
			p2.appPage
		)
	else
		sendSocialLinksImpressionsEvent({
			item_positions = table.concat(v6, ","),
			social_link_urls = table.concat(socialLinkUrls, ","),
			social_link_types = table.concat(socialLinkTypes, ","),
			social_link_display_type = data.socialLinkDisplayType,
			assignment_id = tonumber(data.assignmentId),
			assignment_type = data.assignmentType,
			page = p2.appPage
		})
	end
end

return SduiSocialLinksImpressionsHandler
