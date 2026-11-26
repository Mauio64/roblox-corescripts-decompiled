local EdpStoreAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/EdpStoreAnalytics")
local edpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local storeEnums = EdpStoreAnalytics.Constants.StoreEnums

local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics").UnifiedEventLogEnums

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FFlagSduiErrorPaths

local SduiMarketplaceItemImpressionsHandler = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Impressions/SduiMarketplaceItemImpressionsHandler")

local marketplaceUnifiedItemType = unifiedEventLogEnums.MarketplaceUnifiedItemType

local object = setmetatable({}, { __mode = "k" })

local function SduiDevStoreSeeAllImpressionsHandler(p2, list, p3, p4, p5, p6)
	if #list == 0 then
		return
	end

	local v5 = { analyticsData = p4 }

	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("itemType", v5)
	local v6

	if analyticsFieldInAncestors ~= nil then
		v6 = marketplaceUnifiedItemType[analyticsFieldInAncestors]
	end

	if v6 then
		SduiMarketplaceItemImpressionsHandler(p2, list, p3, p4, p5, p6)
	end

	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("experienceStoreProductType", v5)

	if not analyticsFieldInAncestors2 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToLogExperienceStoreImpressions,
			{
				name = "SduiDevStoreSeeAllImpressionsHandler",
				message = "Missing experienceStoreProductType on collectionAnalyticsData"
			},
			p2.appPage
		)
		return
	end

	local v7 = tostring(analyticsFieldInAncestors2)
	local v8 = if fFlagSduiErrorPaths and p2.configKey then getSduiClientPageScope(p2.configKey) else nil

	local v9 = if v8 then v8.get("devStoreSectionsFired") else object[p2]

	if not v9 then
		v9 = {}

		if v8 then
			v8.set("devStoreSectionsFired", v9)
		else
			object[p2] = v9
		end
	end

	if v9[v7] then
		return
	end

	v9[v7] = true

	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("edpLocationType", v5)
	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("universeId", v5)
	local v10 = if analyticsFieldInAncestors4 ~= nil then tonumber((tostring(analyticsFieldInAncestors4))) else nil

	edpStoreAnalyticsLogger.logImpression({
		actionType = storeEnums.ActionType.Impression,
		productType = analyticsFieldInAncestors2,
		locationType = analyticsFieldInAncestors3,
		universeId = v10,
		layoutOrder = 1
	})

	edpStoreAnalyticsLogger.logExperienceStoreExposure()
end

return SduiDevStoreSeeAllImpressionsHandler
