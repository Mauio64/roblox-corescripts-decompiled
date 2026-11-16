local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local parent = AvatarExperienceAnalytics.Parent

local Cryo = require(parent.Cryo)
require(parent.AvatarExperienceCommon)
local AvatarExperienceModel = require(parent.AvatarExperienceModel)
local ItemTypeEnum = AvatarExperienceModel.Enums.ItemTypeEnum

require(AvatarExperienceAnalytics.Generated.UnifiedEventTypes)
local getMarketplaceUnifiedItemType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedItemType)
local getMarketplaceUnifiedLookType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedLookType)
local getMarketplaceUnifiedAssetType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType)
local getMarketplaceUnifiedBundleType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType)
local getItemSelectionAction = require(AvatarExperienceAnalytics.Utils.getItemSelectionAction)
local getTimedOptionForItemData = require(AvatarExperienceAnalytics.Utils.getTimedOptionForItemData)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)

local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local FFlagAXEditorRecommendedItemsUnifiedImpressions = AvatarExperienceFlags.FFlagAXEditorRecommendedItemsUnifiedImpressions

local function joinIds(list) -- 4 equivalent calls inferred from this helper
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

	local v = nil
	local v2 = nil
	local v3 = nil

	if data.widgetAnalyticsInfo then
		if itemType == ItemTypeEnum.Look then
			if lookData then
				v = lookData.totalPrice ~= nil
			else
				v = false
			end
		elseif hydratedContent then
			v = hydratedContent.price ~= nil
		else
			v = false
		end

		v2 = data.widgetAnalyticsInfo.itemId ~= nil
		v3 = true
	elseif data.isOrganic then
		if itemType == ItemTypeEnum.Look then
			if lookData then
				v = lookData.totalPrice ~= nil
			else
				v = false
			end

			v2 = data.itemId ~= nil
			v3 = true
		else
			if itemData then
				v = itemData.lowestPrice ~= nil or itemData.priceInRobux ~= nil
			else
				v = false
			end

			v2 = data.itemId ~= nil

			if itemData then
				if itemData.assetType == nil then
					if itemData.bundleType == nil then
						v3 = false
					else
						v3 = itemData.bundleType ~= "AvatarAnimations"
					end
				else
					v3 = true
				end
			else
				v3 = false
			end
		end
	end

	return v == true and v2 == true and v3 == true
end

local function buildFields(data)
	local itemData = data.itemData
	local lookData = data.lookData
	local hydratedContent = data.hydratedContent
	local assetAndBundleIds = data.assetAndBundleIds
	local isOrganic = data.isOrganic
	local widgetAnalyticsInfo = data.widgetAnalyticsInfo
	local v

	if widgetAnalyticsInfo then
		v = widgetAnalyticsInfo
	else
		v = {
			itemId = 0,
			assetType = 0,
			bundleType = 0,
			gridPositionRow = 0,
			gridPositionColumn = 0,
			itemPosition = 0
		}
		local itemId

		if FFlagAXUnifiedEventStrictPayloads and data.itemId ~= nil then
			itemId = tostring(data.itemId)
		else
			itemId = data.itemId
		end

		v.itemId = itemId
		local assetType

		if itemData then
			if FFlagAXUnifiedEventStrictPayloads then
				assetType = getMarketplaceUnifiedAssetType(itemData.assetType)
			else
				assetType = itemData.assetType
			end
		end

		v.assetType = assetType
		local bundleType

		if itemData then
			if FFlagAXUnifiedEventStrictPayloads then
				bundleType = getMarketplaceUnifiedBundleType(itemData.bundleType)
			else
				bundleType = itemData.bundleType
			end
		end

		v.bundleType = bundleType

		v.gridPositionRow = data.gridPositionRow
		v.gridPositionColumn = data.gridPositionColumn

		v.itemPosition = data.itemPosition
	end

	local v2 = {
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
	local section

	if FFlagAXEditorRecommendedItemsUnifiedImpressions then
		section = data.section
	end

	v2.section = section
	local gridPositionRow

	if FFlagAXUnifiedEventStrictPayloads and v.gridPositionRow == nil then
		gridPositionRow = data.gridPositionRow
	end

	v2.gridPositionRow = gridPositionRow
	local gridPositionColumn

	if FFlagAXUnifiedEventStrictPayloads and v.gridPositionColumn == nil then
		gridPositionColumn = data.gridPositionColumn
	end

	v2.gridPositionColumn = gridPositionColumn
	local assetIds

	if widgetAnalyticsInfo and assetAndBundleIds then
		if FFlagAXUnifiedEventStrictPayloads then
			assetIds = joinIds(assetAndBundleIds.assetIds) -- inferred equivalent call
		else
			assetIds = assetAndBundleIds.assetIds
		end
	end

	v2.assetIds = assetIds
	local bundleIds

	if widgetAnalyticsInfo and assetAndBundleIds then
		if FFlagAXUnifiedEventStrictPayloads then
			bundleIds = joinIds(assetAndBundleIds.bundleIds) -- inferred equivalent call
		else
			bundleIds = assetAndBundleIds.bundleIds
		end
	end

	v2.bundleIds = bundleIds
	local organicAssetIds

	if isOrganic and assetAndBundleIds then
		if FFlagAXUnifiedEventStrictPayloads then
			organicAssetIds = joinIds(assetAndBundleIds.assetIds) -- inferred equivalent call
		else
			organicAssetIds = assetAndBundleIds.assetIds
		end
	end

	v2.organicAssetIds = organicAssetIds
	local organicBundleIds

	if isOrganic and assetAndBundleIds then
		if FFlagAXUnifiedEventStrictPayloads then
			organicBundleIds = joinIds(assetAndBundleIds.bundleIds) -- inferred equivalent call
		else
			organicBundleIds = assetAndBundleIds.bundleIds
		end
	end

	v2.organicBundleIds = organicBundleIds
	local organicLookType

	if isOrganic and lookData and lookData.lookType then
		if FFlagAXUnifiedEventStrictPayloads then
			organicLookType = getMarketplaceUnifiedLookType(lookData.lookType)
		else
			organicLookType = UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType)
		end
	end

	v2.organicLookType = organicLookType
	local widgetLookType

	if lookData and lookData.lookType and not isOrganic then
		if FFlagAXUnifiedEventStrictPayloads then
			widgetLookType = getMarketplaceUnifiedLookType(lookData.lookType)
		else
			widgetLookType = UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType)
		end
	end

	v2.widgetLookType = widgetLookType
	local organicItemPrice

	if isOrganic then
		if lookData then
			organicItemPrice = lookData.totalPrice
		elseif itemData then
			organicItemPrice = itemData.lowestPrice or itemData.priceInRobux
		end
	end

	v2.organicItemPrice = organicItemPrice
	local widgetItemPrice

	if widgetAnalyticsInfo then
		if lookData then
			widgetItemPrice = lookData.totalPrice
		elseif hydratedContent then
			widgetItemPrice = hydratedContent.price
		end
	end

	v2.widgetItemPrice = widgetItemPrice
	local organicTimedOption

	if isOrganic and itemData then
		organicTimedOption = getTimedOptionForItemData(itemData)
	end

	v2.organicTimedOption = organicTimedOption
	local widgetTimedOption

	if not (isOrganic or not itemData) then
		widgetTimedOption = getTimedOptionForItemData(itemData)
	end

	v2.widgetTimedOption = widgetTimedOption
	local widgetAssetType

	if not (isOrganic or not itemData) then
		if FFlagAXUnifiedEventStrictPayloads then
			widgetAssetType = getMarketplaceUnifiedAssetType(itemData.assetType)
		else
			widgetAssetType = itemData.assetType
		end
	end

	v2.widgetAssetType = widgetAssetType
	local widgetBundleType

	if not (isOrganic or not itemData) then
		if FFlagAXUnifiedEventStrictPayloads then
			widgetBundleType = getMarketplaceUnifiedBundleType(itemData.bundleType)
		else
			widgetBundleType = itemData.bundleType
		end
	end

	v2.widgetBundleType = widgetBundleType

	return (Cryo.Dictionary.join(v, v2))
end

local function getCatalogItemUnifiedLoggingFields(p)
	if isReadyToLog(p) then
		return buildFields(p)
	end

	return nil
end

return getCatalogItemUnifiedLoggingFields
