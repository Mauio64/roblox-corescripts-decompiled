local EdpStoreAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/EdpStoreAnalytics")
local edpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local storeEnums = EdpStoreAnalytics.Constants.StoreEnums

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local SduiMarketplaceItemImpressionsHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiMarketplaceItemImpressionsHandler")

local function SduiEdpStoreImpressionsHandler(p2, items, p3, p4, value, p5)
	if SduiMarketplaceItemImpressionsHandler(p2, items, p3, p4, value, p5) == 0 then
		return
	end

	local v5 = { analyticsData = p4 }
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("itemType", v5)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("edpLocationType", v5)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("universeId", v5)
	local v6 = if analyticsFieldInAncestors3 ~= nil then tonumber(analyticsFieldInAncestors3) else nil

	if not analyticsFieldInAncestors then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToLogExperienceStoreImpressions,
			{
				name = "SduiEdpStoreImpressionsHandler",
				message = "Missing itemType on collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	for k, item in items do
		if p3[item] == nil then
			continue
		end

		local v7 = (value or 0) + item

		edpStoreAnalyticsLogger.logImpression({
			actionType = storeEnums.ActionType.Impression,
			productType = analyticsFieldInAncestors,
			locationType = analyticsFieldInAncestors2,
			universeId = v6,
			layoutOrder = v7
		})
	end

	edpStoreAnalyticsLogger.logExperienceStoreExposure()
end

return SduiEdpStoreImpressionsHandler
