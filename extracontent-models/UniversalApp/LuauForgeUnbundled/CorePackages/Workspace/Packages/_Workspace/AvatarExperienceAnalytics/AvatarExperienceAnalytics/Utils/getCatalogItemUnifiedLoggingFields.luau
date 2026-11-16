local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceCommon")
local itemTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceModel").Enums.ItemTypeEnum

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Generated/UnifiedEventTypes")
local getMarketplaceUnifiedItemType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedItemType")
local getMarketplaceUnifiedLookType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedLookType")
local getMarketplaceUnifiedAssetType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedAssetType")
local getMarketplaceUnifiedBundleType = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getMarketplaceUnifiedBundleType")
local getItemSelectionAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getItemSelectionAction")
local getTimedOptionForItemData = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/getTimedOptionForItemData")
local UnifiedEventLoggingUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceAnalytics/Utils/UnifiedEventLoggingUtils")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceAnalytics/AvatarExperienceFlags")
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local fFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions

local function joinIds(list)
	if list then
		return (table.concat(list, ","))
	end

	return nil
end

local function isReadyToLog(data): boolean
	local itemType = data.itemType
	local itemData = data.itemData
	local lookData = data.lookData
	local hydratedContent = data.hydratedContent

	local v5 = nil
	local v6 = nil
	local v7 = nil

	if data.widgetAnalyticsInfo then
		if itemType == itemTypeEnum.Look then
			v5 = if lookData then lookData.totalPrice ~= nil else false
		else
			v5 = if hydratedContent then hydratedContent.price ~= nil else false
		end

		v6 = data.widgetAnalyticsInfo.itemId ~= nil
		v7 = true
	elseif data.isOrganic then
		if itemType == itemTypeEnum.Look then
			v5 = if lookData then lookData.totalPrice ~= nil else false
			v6 = data.itemId ~= nil
			v7 = true
		else
			v5 = if itemData then itemData.lowestPrice ~= nil or itemData.priceInRobux ~= nil else false
			v6 = data.itemId ~= nil

			if itemData then
				if itemData.assetType == nil then
					v7 = not (itemData.bundleType == nil) and itemData.bundleType ~= "AvatarAnimations"
				else
					v7 = true
				end
			else
				v7 = false
			end
		end
	end

	return v5 == true and v6 == true and v7 == true
end

local function buildFields(data)
	local itemData = data.itemData
	local lookData = data.lookData
	local hydratedContent = data.hydratedContent
	local assetAndBundleIds = data.assetAndBundleIds
	local isOrganic = data.isOrganic
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local v5

	if widgetAnalyticsInfo then
		v5 = widgetAnalyticsInfo
	else
		v5 = {
			itemId = 0,
			assetType = 0,
			bundleType = 0,
			gridPositionRow = 0,
			gridPositionColumn = 0,
			itemPosition = 0
		}
		local v6 = if fFlagAXUnifiedEventStrictPayloads and data.itemId ~= nil then tostring(data.itemId) else data.itemId
		v5.itemId = v6
		local v7

		if itemData then
			if fFlagAXUnifiedEventStrictPayloads then
				v7 = getMarketplaceUnifiedAssetType(itemData.assetType)
			else
				v7 = itemData.assetType
			end
		end

		v5.assetType = v7
		local v8

		if itemData then
			if fFlagAXUnifiedEventStrictPayloads then
				v8 = getMarketplaceUnifiedBundleType(itemData.bundleType)
			else
				v8 = itemData.bundleType
			end
		end

		v5.bundleType = v8

		v5.gridPositionRow = data.gridPositionRow
		v5.gridPositionColumn = data.gridPositionColumn

		v5.itemPosition = data.itemPosition
	end

	local v6 = {
		itemType = getMarketplaceUnifiedItemType(data.itemType),
		action = getItemSelectionAction(data.isSelected == true),
		category = data.impressionsCategory,
		subcategory = data.impressionsSubcategory,
		taxonomyId = data.impressionsTaxonomyId,
		section = 0,
		gridPositionRow = 0,
		gridPositionColumn = 0,
		assetIds = 0,
		bundleIds = 0,
		organicAssetIds = 0,
		organicBundleIds = 0,
		organicLookType = 0,
		widgetLookType = 0,
		organicItemPrice = 0,
		widgetItemPrice = 0,
		organicTimedOption = 0,
		widgetTimedOption = 0,
		widgetAssetType = 0,
		widgetBundleType = 0
	}

	local v7 = if fFlagAXEditorRecommendedItemsUnifiedImpressions then data.section else nil
	v6.section = v7
	local v8 = if fFlagAXUnifiedEventStrictPayloads and v5.gridPositionRow == nil then data.gridPositionRow else nil
	v6.gridPositionRow = v8

	local v9 = if fFlagAXUnifiedEventStrictPayloads and v5.gridPositionColumn == nil then data.gridPositionColumn else nil
	v6.gridPositionColumn = v9
	local v10

	if widgetAnalyticsInfo and assetAndBundleIds then
		if fFlagAXUnifiedEventStrictPayloads then
			local assetIds = assetAndBundleIds.assetIds

			if assetIds then
				v10 = table.concat(assetIds, ",")
			end
		else
			v10 = assetAndBundleIds.assetIds
		end
	end

	v6.assetIds = v10
	local v11

	if widgetAnalyticsInfo and assetAndBundleIds then
		if fFlagAXUnifiedEventStrictPayloads then
			local bundleIds = assetAndBundleIds.bundleIds

			if bundleIds then
				v11 = table.concat(bundleIds, ",")
			end
		else
			v11 = assetAndBundleIds.bundleIds
		end
	end

	v6.bundleIds = v11
	local v12

	if isOrganic and assetAndBundleIds then
		if fFlagAXUnifiedEventStrictPayloads then
			local assetIds = assetAndBundleIds.assetIds

			if assetIds then
				v12 = table.concat(assetIds, ",")
			end
		else
			v12 = assetAndBundleIds.assetIds
		end
	end

	v6.organicAssetIds = v12
	local v13

	if isOrganic and assetAndBundleIds then
		if fFlagAXUnifiedEventStrictPayloads then
			local bundleIds = assetAndBundleIds.bundleIds

			if bundleIds then
				v13 = table.concat(bundleIds, ",")
			end
		else
			v13 = assetAndBundleIds.bundleIds
		end
	end

	v6.organicBundleIds = v13
	local v14

	if isOrganic and lookData and lookData.lookType then
		if fFlagAXUnifiedEventStrictPayloads then
			v14 = getMarketplaceUnifiedLookType(lookData.lookType)
		else
			v14 = UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType)
		end
	end

	v6.organicLookType = v14
	local v15

	if lookData and lookData.lookType and not isOrganic then
		if fFlagAXUnifiedEventStrictPayloads then
			v15 = getMarketplaceUnifiedLookType(lookData.lookType)
		else
			v15 = UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType)
		end
	end

	v6.widgetLookType = v15
	local v16

	if isOrganic then
		if lookData then
			v16 = lookData.totalPrice
		elseif itemData then
			v16 = itemData.lowestPrice or itemData.priceInRobux
		end
	end

	v6.organicItemPrice = v16
	local v17

	if widgetAnalyticsInfo then
		if lookData then
			v17 = lookData.totalPrice
		elseif hydratedContent then
			v17 = hydratedContent.price
		end
	end

	v6.widgetItemPrice = v17

	local v18 = if isOrganic and itemData then getTimedOptionForItemData(itemData) else nil
	v6.organicTimedOption = v18
	local v19 = if not (isOrganic or not itemData) then getTimedOptionForItemData(itemData) else nil
	v6.widgetTimedOption = v19
	local v20

	if not (isOrganic or not itemData) then
		if fFlagAXUnifiedEventStrictPayloads then
			v20 = getMarketplaceUnifiedAssetType(itemData.assetType)
		else
			v20 = itemData.assetType
		end
	end

	v6.widgetAssetType = v20
	local v21

	if not (isOrganic or not itemData) then
		if fFlagAXUnifiedEventStrictPayloads then
			v21 = getMarketplaceUnifiedBundleType(itemData.bundleType)
		else
			v21 = itemData.bundleType
		end
	end

	v6.widgetBundleType = v21

	return Cryo.Dictionary.join(v5, v6)
end

local function getCatalogItemUnifiedLoggingFields(p2)
	if isReadyToLog(p2) then
		return buildFields(p2)
	end

	return nil
end

return getCatalogItemUnifiedLoggingFields
