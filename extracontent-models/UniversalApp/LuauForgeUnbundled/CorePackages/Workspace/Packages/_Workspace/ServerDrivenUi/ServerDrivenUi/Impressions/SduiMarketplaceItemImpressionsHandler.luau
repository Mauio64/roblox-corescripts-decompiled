local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceAnalytics")
local axUnifiedEventFilter = AvatarExperienceAnalytics.AXUnifiedEventFilter
local unifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendPassthroughUnifiedEventLog = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog
local unifiedEventLoggingUtils = AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils
local fFlagAXUnifiedEventCounters = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventCounters
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads
local unifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/AvatarExperienceNavigation").Enums.UnifiedLoggingSurface

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local findCollectionItemInstances = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Analytics/findCollectionItemInstances")

local v5 = {}

local marketplaceUnifiedAction = unifiedEventLogEnums.MarketplaceUnifiedAction
local marketplaceUnifiedItemType = unifiedEventLogEnums.MarketplaceUnifiedItemType

local function gridPosition(p2, p3)
	if p3 and not (p3 <= 0) then
		return math.ceil(p2 / p3), (p2 - 1) % p3 + 1
	end

	return 1, p2
end

local function SduiMarketplaceItemImpressionsHandler(p2, list, p3, p4, value, p5)
	if #list == 0 or #(p3 or v5) == 0 then
		sduiLogger.reportError(sduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions, {
			name = "SduiMarketplaceItemImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#(p3 or v5)}`
		}, p2.appPage)
		return 0
	end

	local v6 = { analyticsData = p4 }
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("surface", v6)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("itemType", v6)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("universeId", v6)
	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("itemsPerRow", v6)
	local v7 = if analyticsFieldInAncestors3 ~= nil then tonumber(analyticsFieldInAncestors3) else nil
	local v8 = if analyticsFieldInAncestors4 ~= nil then tonumber(analyticsFieldInAncestors4) else nil
	local v9

	if analyticsFieldInAncestors ~= nil then
		v9 = unifiedLoggingSurface[analyticsFieldInAncestors]
	end

	local v10

	if analyticsFieldInAncestors2 ~= nil then
		v10 = marketplaceUnifiedItemType[analyticsFieldInAncestors2]
	end

	if not v9 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions,
			{
				name = "SduiMarketplaceItemImpressionsHandler",
				message = `Missing or unknown surface on analytics data: {tostring(analyticsFieldInAncestors)}`
			},
			p2.appPage
		)
		return 0
	end

	if not v10 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions,
			{
				name = "SduiMarketplaceItemImpressionsHandler",
				message = `Missing or unknown itemType on analytics data: {tostring(analyticsFieldInAncestors2)}`
			},
			p2.appPage
		)
		return 0
	end

	local v11 = findCollectionItemInstances(p5)
	local count = 0

	for k, item in list do
		local v12 = p3[item]

		if v12 == nil then
			continue
		end

		local v13 = (value or 0) + item
		local v14

		if v8 and not (v8 <= 0) then
			v14 = math.ceil(v13 / v8)
			v13 = (v13 - 1) % v8 + 1
		else
			v14 = 1
		end

		if fFlagAXUnifiedEventStrictPayloads then
			local v15 = v11[item]
			local v16 = if v15 then unifiedEventLoggingUtils.getScreenSize(v15) else nil

			local v17 = if v15 then unifiedEventLoggingUtils.getElementSizeAndPosition(v15) else nil

			local v18 = {
				action = marketplaceUnifiedAction.ITEM_IMPRESSION,
				surface = v9,
				itemType = v10,
				itemId = v12.id,
				universeId = v7,
				gridPositionRow = v14,
				gridPositionColumn = v13,
				screenSizeWidth = 0,
				screenSizeHeight = 0,
				elementSizeWidth = 0,
				elementSizeHeight = 0,
				elementCoordinatesX = 0,
				elementCoordinatesY = 0,
				elementRelativePositionX = 0,
				elementRelativePositionY = 0
			}

			local v19 = if v16 then v16.screenSizeWidth else nil
			v18.screenSizeWidth = v19
			local v20 = if v16 then v16.screenSizeHeight else nil
			v18.screenSizeHeight = v20
			local v21 = if v17 then v17.elementSizeWidth else nil
			v18.elementSizeWidth = v21
			local v22 = if v17 then v17.elementSizeHeight else nil
			v18.elementSizeHeight = v22

			local v23 = if v17 then v17.elementCoordinatesX else nil
			v18.elementCoordinatesX = v23

			local v24 = if v17 then v17.elementCoordinatesY else nil
			v18.elementCoordinatesY = v24

			local v25 = if v17 then v17.elementRelativePositionX else nil
			v18.elementRelativePositionX = v25

			local v26 = if v17 then v17.elementRelativePositionY else nil
			v18.elementRelativePositionY = v26

			local filtered = nil

			if fFlagAXUnifiedEventCounters then
				filtered = axUnifiedEventFilter.filter(v18)
			else
				axUnifiedEventFilter.filter(v18)
			end

			sendPassthroughUnifiedEventLog(
				v18,
				nil,
				fFlagAXUnifiedEventCounters and { filterPassed = filtered } or nil
			)
		else
			local v15 = {
				action = marketplaceUnifiedAction.ITEM_IMPRESSION,
				surface = v9,
				itemType = v10,
				itemId = v12.id,
				universeId = v7,
				gridPositionRow = v14,
				gridPositionColumn = v13
			}

			local v16 = v11[item]

			if v16 then
				for k2, v17 in unifiedEventLoggingUtils.getScreenSize(v16) do
					v15[k2] = v17
				end

				for k2, v17 in unifiedEventLoggingUtils.getElementSizeAndPosition(v16) do
					v15[k2] = v17
				end
			end

			local filtered = nil

			if fFlagAXUnifiedEventCounters then
				filtered = axUnifiedEventFilter.filter(v15)
			else
				axUnifiedEventFilter.filter(v15)
			end

			sendUnifiedEventLog(
				v15,
				nil,
				fFlagAXUnifiedEventCounters and { filterPassed = filtered } or nil
			)
		end

		count += 1
	end

	if count == 0 then
		sduiLogger.reportError(
			sduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions,
			{
				name = "SduiMarketplaceItemImpressionsHandler",
				message = "No valid items found for impression indexes"
			},
			p2.appPage
		)
	end

	return count
end

return SduiMarketplaceItemImpressionsHandler
