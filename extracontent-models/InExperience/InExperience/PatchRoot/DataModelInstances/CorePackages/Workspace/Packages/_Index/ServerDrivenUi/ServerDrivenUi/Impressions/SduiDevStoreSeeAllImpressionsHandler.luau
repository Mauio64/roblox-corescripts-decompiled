local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local EdpStoreAnalytics = require(ServerDrivenUiParent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums
local UnifiedEventLogEnums = require(ServerDrivenUiParent.AvatarExperienceAnalytics).UnifiedEventLogEnums
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local SduiMarketplaceItemImpressionsHandler = require(ServerDrivenUi.Impressions.SduiMarketplaceItemImpressionsHandler)
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType
local self = setmetatable({}, {
	__mode = "k"
})

local function SduiDevStoreSeeAllImpressionsHandler(p1, t1: {[any]: any}, t2: {[any]: any}, p2, n1: number?, s1: string?) -- line: 46
	-- upvalues: findAnalyticsFieldInAncestors (copy), MarketplaceUnifiedItemType (copy), SduiMarketplaceItemImpressionsHandler (copy), SduiLogger (copy), SduiErrors (copy), self (copy), EdpStoreAnalyticsLogger (copy), StoreEnums (copy)
	if #t1 == 0 then
		return
	end

	local t3 = {
		analyticsData = p2
	}
	local v22 = findAnalyticsFieldInAncestors("itemType", t3)

	if if v22 == nil then nil else MarketplaceUnifiedItemType[v22] then
		SduiMarketplaceItemImpressionsHandler(p1, t1, t2, p2, n1, s1)
	end

	local v23 = findAnalyticsFieldInAncestors("experienceStoreProductType", t3)

	if not v23 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogExperienceStoreImpressions, {
			name = "SduiDevStoreSeeAllImpressionsHandler",
			message = "Missing experienceStoreProductType on collectionAnalyticsData"
		}, p1.appPage)

		return
	end

	local str = tostring(v23)
	local v25 = self[p1]

	if not v25 then
		v25 = {}
		self[p1] = v25
	end

	if v25[str] then
		return
	end

	v25[str] = true

	local v26 = findAnalyticsFieldInAncestors("edpLocationType", t3)
	local v27 = findAnalyticsFieldInAncestors("universeId", t3)
	local v28 = if v27 == nil then nil else tonumber((tostring(v27)))

	EdpStoreAnalyticsLogger.logImpression({
		layoutOrder = 1,
		actionType = StoreEnums.ActionType.Impression,
		productType = v23,
		locationType = v26,
		universeId = v28
	})
	EdpStoreAnalyticsLogger.logExperienceStoreExposure()
end

return SduiDevStoreSeeAllImpressionsHandler
