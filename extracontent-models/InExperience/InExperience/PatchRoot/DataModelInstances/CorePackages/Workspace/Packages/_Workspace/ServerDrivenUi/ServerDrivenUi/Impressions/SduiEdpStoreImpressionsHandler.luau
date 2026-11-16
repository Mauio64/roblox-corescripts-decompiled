local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local EdpStoreAnalytics = require(parent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local SduiMarketplaceItemImpressionsHandler = require(ServerDrivenUi.Impressions.SduiMarketplaceItemImpressionsHandler)

local function SduiEdpStoreImpressionsHandler(p, items, p2, analyticsData, value: number?, p3: string?)
	if SduiMarketplaceItemImpressionsHandler(p, items, p2, analyticsData, value, p3) == 0 then
		return
	end

	local v = { analyticsData = analyticsData }
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("itemType", v)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("edpLocationType", v)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("universeId", v)
	local universeId

	if analyticsFieldInAncestors3 ~= nil then
		universeId = tonumber(analyticsFieldInAncestors3)
	end

	if not analyticsFieldInAncestors then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToLogExperienceStoreImpressions,
			{
				name = "SduiEdpStoreImpressionsHandler",
				message = "Missing itemType on collectionAnalyticsData"
			},
			p.appPage
		)
		return
	end

	for _, item in items do
		if p2[item] == nil then
			continue
		end

		local layoutOrder = (value or 0) + item

		EdpStoreAnalyticsLogger.logImpression({
			actionType = StoreEnums.ActionType.Impression,
			productType = analyticsFieldInAncestors,
			locationType = analyticsFieldInAncestors2,
			universeId = universeId,
			layoutOrder = layoutOrder
		})
	end

	EdpStoreAnalyticsLogger.logExperienceStoreExposure()
end

return SduiEdpStoreImpressionsHandler
