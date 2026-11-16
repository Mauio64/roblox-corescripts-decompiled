local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AXUnifiedEventFilter = AvatarExperienceAnalytics.AXUnifiedEventFilter
local UnifiedEventLogEnums = AvatarExperienceAnalytics.UnifiedEventLogEnums
local sendUnifiedEventLog = AvatarExperienceAnalytics.sendUnifiedEventLog
local sendPassthroughUnifiedEventLog = AvatarExperienceAnalytics.sendPassthroughUnifiedEventLog
local UnifiedEventLoggingUtils = AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils
local FFlagAXUnifiedEventCounters = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventCounters
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceAnalytics.Flags.FFlagAXUnifiedEventStrictPayloads
local AvatarExperienceNavigation = require(parent.AvatarExperienceNavigation)
local UnifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiLogger = SduiCoreSystem.SduiLogger
local findAnalyticsFieldInAncestors = SduiCoreSystem.findAnalyticsFieldInAncestors

local findCollectionItemInstances = require(ServerDrivenUi.Analytics.findCollectionItemInstances)

local v = {}

local MarketplaceUnifiedAction = UnifiedEventLogEnums.MarketplaceUnifiedAction
local MarketplaceUnifiedItemType = UnifiedEventLogEnums.MarketplaceUnifiedItemType

local function gridPosition(p: number, p2: number?)
	if p2 and not (p2 <= 0) then
		return math.ceil(p / p2), (p - 1) % p2 + 1
	end

	return 1, p
end

local function SduiMarketplaceItemImpressionsHandler(p, list, p2, analyticsData, value: number?, p3: string?)
	if #list == 0 or #(p2 or v) == 0 then
		SduiLogger.reportError(SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions, {
			name = "SduiMarketplaceItemImpressionsHandler",
			message = `No entries to log: impressionIndexes={#list}, itemAnalyticsDatas={#(p2 or v)}`
		}, p.appPage)
		return 0
	end

	local v2 = { analyticsData = analyticsData }
	local analyticsFieldInAncestors = findAnalyticsFieldInAncestors("surface", v2)
	local analyticsFieldInAncestors2 = findAnalyticsFieldInAncestors("itemType", v2)
	local analyticsFieldInAncestors3 = findAnalyticsFieldInAncestors("universeId", v2)
	local analyticsFieldInAncestors4 = findAnalyticsFieldInAncestors("itemsPerRow", v2)
	local universeId

	if analyticsFieldInAncestors3 ~= nil then
		universeId = tonumber(analyticsFieldInAncestors3)
	end

	local v3

	if analyticsFieldInAncestors4 ~= nil then
		v3 = tonumber(analyticsFieldInAncestors4)
	end

	local surface

	if analyticsFieldInAncestors ~= nil then
		surface = UnifiedLoggingSurface[analyticsFieldInAncestors]
	end

	local itemType

	if analyticsFieldInAncestors2 ~= nil then
		itemType = MarketplaceUnifiedItemType[analyticsFieldInAncestors2]
	end

	if not surface then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions,
			{
				name = "SduiMarketplaceItemImpressionsHandler",
				message = `Missing or unknown surface on analytics data: {tostring(analyticsFieldInAncestors)}`
			},
			p.appPage
		)
		return 0
	end

	if not itemType then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions,
			{
				name = "SduiMarketplaceItemImpressionsHandler",
				message = `Missing or unknown itemType on analytics data: {tostring(analyticsFieldInAncestors2)}`
			},
			p.appPage
		)
		return 0
	end

	local collectionItemInstances = findCollectionItemInstances(p3)
	local count = 0

	for _, item in list do
		local v4 = p2[item]

		if v4 == nil then
			continue
		end

		local gridPositionColumn = (value or 0) + item
		local gridPositionRow

		if v3 and not (v3 <= 0) then
			gridPositionRow = math.ceil(gridPositionColumn / v3)
			gridPositionColumn = (gridPositionColumn - 1) % v3 + 1
		else
			gridPositionRow = 1
		end

		if FFlagAXUnifiedEventStrictPayloads then
			local collectionItemInstance = collectionItemInstances[item]
			local v5

			if collectionItemInstance then
				v5 = UnifiedEventLoggingUtils.getScreenSize(collectionItemInstance)
			end

			local v6

			if collectionItemInstance then
				v6 = UnifiedEventLoggingUtils.getElementSizeAndPosition(collectionItemInstance)
			end

			local v7 = {
				action = MarketplaceUnifiedAction.ITEM_IMPRESSION,
				surface = surface,
				itemType = itemType,
				itemId = v4.id,
				universeId = universeId,
				gridPositionRow = gridPositionRow,
				gridPositionColumn = gridPositionColumn,
				screenSizeWidth = 0,
				screenSizeHeight = 0,
				elementSizeWidth = 0,
				elementSizeHeight = 0,
				elementCoordinatesX = 0,
				elementCoordinatesY = 0,
				elementRelativePositionX = 0,
				elementRelativePositionY = 0
			}
			local screenSizeWidth

			if v5 then
				screenSizeWidth = v5.screenSizeWidth
			end

			v7.screenSizeWidth = screenSizeWidth
			local screenSizeHeight

			if v5 then
				screenSizeHeight = v5.screenSizeHeight
			end

			v7.screenSizeHeight = screenSizeHeight
			local elementSizeWidth

			if v6 then
				elementSizeWidth = v6.elementSizeWidth
			end

			v7.elementSizeWidth = elementSizeWidth
			local elementSizeHeight

			if v6 then
				elementSizeHeight = v6.elementSizeHeight
			end

			v7.elementSizeHeight = elementSizeHeight
			local elementCoordinatesX

			if v6 then
				elementCoordinatesX = v6.elementCoordinatesX
			end

			v7.elementCoordinatesX = elementCoordinatesX
			local elementCoordinatesY

			if v6 then
				elementCoordinatesY = v6.elementCoordinatesY
			end

			v7.elementCoordinatesY = elementCoordinatesY
			local elementRelativePositionX

			if v6 then
				elementRelativePositionX = v6.elementRelativePositionX
			end

			v7.elementRelativePositionX = elementRelativePositionX
			local elementRelativePositionY

			if v6 then
				elementRelativePositionY = v6.elementRelativePositionY
			end

			v7.elementRelativePositionY = elementRelativePositionY

			local filtered = nil

			if FFlagAXUnifiedEventCounters then
				filtered = AXUnifiedEventFilter.filter(v7)
			else
				AXUnifiedEventFilter.filter(v7)
			end

			sendPassthroughUnifiedEventLog(v7, nil, FFlagAXUnifiedEventCounters and {
				filterPassed = filtered
			} or nil)
		else
			local v5 = {
				action = MarketplaceUnifiedAction.ITEM_IMPRESSION,
				surface = surface,
				itemType = itemType,
				itemId = v4.id,
				universeId = universeId,
				gridPositionRow = gridPositionRow,
				gridPositionColumn = gridPositionColumn
			}

			local collectionItemInstance = collectionItemInstances[item]

			if collectionItemInstance then
				for k, v6 in UnifiedEventLoggingUtils.getScreenSize(collectionItemInstance), nil, nil do
					v5[k] = v6
				end

				for k, v6 in UnifiedEventLoggingUtils.getElementSizeAndPosition(collectionItemInstance), nil, nil do
					v5[k] = v6
				end
			end

			local filtered = nil

			if FFlagAXUnifiedEventCounters then
				filtered = AXUnifiedEventFilter.filter(v5)
			else
				AXUnifiedEventFilter.filter(v5)
			end

			sendUnifiedEventLog(v5, nil, FFlagAXUnifiedEventCounters and { filterPassed = filtered } or nil)
		end

		count += 1
	end

	if count == 0 then
		SduiLogger.reportError(
			SduiErrors.SduiErrorType.FailedToLogMarketplaceItemImpressions,
			{
				name = "SduiMarketplaceItemImpressionsHandler",
				message = "No valid items found for impression indexes"
			},
			p.appPage
		)
	end

	return count
end

return SduiMarketplaceItemImpressionsHandler
