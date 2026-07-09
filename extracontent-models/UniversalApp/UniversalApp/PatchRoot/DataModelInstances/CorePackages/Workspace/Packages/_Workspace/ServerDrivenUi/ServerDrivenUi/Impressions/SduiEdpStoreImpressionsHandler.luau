local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local EdpStoreAnalytics = require(ServerDrivenUiParent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums
local SduiCoreSystem = require(ServerDrivenUiParent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local SduiMarketplaceItemImpressionsHandler = require(ServerDrivenUi.Impressions.SduiMarketplaceItemImpressionsHandler)

local function SduiEdpStoreImpressionsHandler(p1, t1: {[any]: any}, t2: {[any]: any}, p2, n1: number?, s1: string?) -- line: 27
	-- upvalues: SduiMarketplaceItemImpressionsHandler (copy), findAnalyticsFieldInAncestors (copy), SduiLogger (copy), SduiErrors (copy), EdpStoreAnalyticsLogger (copy), StoreEnums (copy)
	if SduiMarketplaceItemImpressionsHandler(p1, t1, t2, p2, n1, s1) == 0 then
		return
	end

	local t3 = {
		analyticsData = p2
	}
	local v19 = findAnalyticsFieldInAncestors("itemType", t3)
	local v20 = findAnalyticsFieldInAncestors("edpLocationType", t3)
	local v21 = findAnalyticsFieldInAncestors("universeId", t3)
	local v22 = if v21 == nil then nil else tonumber(v21)

	if not v19 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogExperienceStoreImpressions, {
			name = "SduiEdpStoreImpressionsHandler",
			message = "Missing itemType on collectionAnalyticsData"
		}, p1.appPage)

		return
	end

	for _, v24 in t1 do
		if t2[v24] ~= nil then
			local v25 = (n1 or 0) + v24

			EdpStoreAnalyticsLogger.logImpression({
				actionType = StoreEnums.ActionType.Impression,
				productType = v19,
				locationType = v20,
				universeId = v22,
				layoutOrder = v25
			})
		end
	end

	EdpStoreAnalyticsLogger.logExperienceStoreExposure()
end

return SduiEdpStoreImpressionsHandler
