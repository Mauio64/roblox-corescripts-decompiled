local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local EdpStoreAnalytics = require(parent.EdpStoreAnalytics)
local EdpStoreAnalyticsLogger = EdpStoreAnalytics.EdpStoreAnalyticsLogger
local StoreEnums = EdpStoreAnalytics.Constants.StoreEnums

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors
local getSduiClientPageScope = SduiCoreSystem.getSduiClientPageScope
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local SduiMarketplaceItemImpressionsHandler = require(ServerDrivenUi.Impressions.SduiMarketplaceItemImpressionsHandler)

local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType

local object = setmetatable({}, { __mode = "k" })

local function SduiDevStoreSeeAllImpressionsHandler(p, list, p2, analyticsData, p3: number?, p4: string?)
	if #list == 0 then
		return
	end

	local v = { analyticsData = analyticsData }

	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("itemType", v)
	local v2

	if analyticsFieldInAncestors ~= nil then
		v2 = MarketplaceUnifiedItemType[analyticsFieldInAncestors]
	end

	if v2 then
		SduiMarketplaceItemImpressionsHandler(p, list, p2, analyticsData, p3, p4)
	end

	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("experienceStoreProductType", v)

	if not analyticsFieldInAncestors2 then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToLogExperienceStoreImpressions,
			{
				name = "SduiDevStoreSeeAllImpressionsHandler",
				message = "Missing experienceStoreProductType on collectionAnalyticsData"
			},
			p.appPage
		)
		return
	end

	local v3 = tostring(analyticsFieldInAncestors2)
	local v4

	if FFlagSduiErrorPaths and p.configKey then
		v4 = getSduiClientPageScope(p.configKey)
	end

	local v5

	if v4 then
		v5 = v4.get("devStoreSectionsFired")
	else
		v5 = object[p]
	end

	if not v5 then
		v5 = {}

		if v4 then
			v4.set("devStoreSectionsFired", v5)
		else
			object[p] = v5
		end
	end

	if v5[v3] then
		return
	end

	v5[v3] = true

	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("edpLocationType", v)
	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("universeId", v)
	local universeId

	if analyticsFieldInAncestors4 ~= nil then
		universeId = tonumber((tostring(analyticsFieldInAncestors4)))
	end

	EdpStoreAnalyticsLogger.logImpression({
		actionType = StoreEnums.ActionType.Impression,
		productType = analyticsFieldInAncestors2,
		locationType = analyticsFieldInAncestors3,
		universeId = universeId,
		layoutOrder = 1
	})

	EdpStoreAnalyticsLogger.logExperienceStoreExposure()
end

return SduiDevStoreSeeAllImpressionsHandler
