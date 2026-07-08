local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local sendSocialLinksImpressionsEvent = require(Parent.DiscoveryAnalytics).Events.sendSocialLinksImpressionsEvent
local SduiErrors = require(Parent.SduiCoreSystem).SduiErrors
local t1 = {}

local function SduiSocialLinksImpressionsHandler(p1, t2: {[any]: any}, t3: {[any]: any}, p2, _: number?) -- line: 15
	-- upvalues: SduiErrors (copy), t1 (copy), sendSocialLinksImpressionsEvent (copy)
	if not p2 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions, {
			name = "SduiSocialLinksImpressionsHandler",
			message = "Missing collectionAnalyticsData"
		}, p1.appPage)

		return
	end

	if #t2 == 0 or #(t3 or t1) == 0 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions, {
			name = "SduiSocialLinksImpressionsHandler",
			message = `No entries to log: impressionIndexes={ #t2 }, itemAnalyticsDatas={ #(t3 or t1) }`
		}, p1.appPage)

		return
	end

	local t4 = {}
	local t5 = {}
	local t6 = {}

	for _, v15 in t2 do
		local v16 = t3[v15]

		if v16 then
			table.insert(t4, v15)
			table.insert(t5, v16.socialLinkUrl or "")
			table.insert(t6, v16.socialLinkType or "")
		end
	end

	if #t4 == 0 then
		p1.dependencies.logger.reportError(SduiErrors.SduiErrorType.FailedToLogSocialLinksImpressions, {
			name = "SduiSocialLinksImpressionsHandler",
			message = "No valid items found for impression indexes"
		}, p1.appPage)

		return
	end

	sendSocialLinksImpressionsEvent({
		item_positions = table.concat(t4, ","),
		social_link_urls = table.concat(t5, ","),
		social_link_types = table.concat(t6, ","),
		social_link_display_type = p2.socialLinkDisplayType,
		assignment_id = tonumber(p2.assignmentId),
		assignment_type = p2.assignmentType,
		page = p1.appPage
	})
end

return SduiSocialLinksImpressionsHandler
