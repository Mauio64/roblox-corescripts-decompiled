local AvatarExperienceAnalytics = script:FindFirstAncestor("AvatarExperienceAnalytics")
local AvatarExperienceAnalyticsParent = AvatarExperienceAnalytics.Parent
local Cryo = require(AvatarExperienceAnalyticsParent.Cryo)
local ItemTypeEnum = require(AvatarExperienceAnalyticsParent.AvatarExperienceCommon).Enums.ItemTypeEnum
local getMarketplaceUnifiedItemType = require(AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedItemType)
local getItemSelectionAction = require(AvatarExperienceAnalytics.Utils.getItemSelectionAction)
local getTimedOptionForItemData = require(AvatarExperienceAnalytics.Utils.getTimedOptionForItemData)
local UnifiedEventLoggingUtils = require(AvatarExperienceAnalytics.Utils.UnifiedEventLoggingUtils)
local FFlagAddTypesToWidgetItems = require(AvatarExperienceAnalyticsParent.AvatarExperienceFlags).FFlagAddTypesToWidgetItems

local function isReadyToLog(t1: {[any]: any}) -- line: 87
	-- upvalues: ItemTypeEnum (copy)
	local itemType = t1.itemType
	local itemData = t1.itemData
	local lookData = t1.lookData
	local hydratedContent = t1.hydratedContent
	local v18 = nil
	local v19 = nil
	local v20 = nil

	if t1.widgetAnalyticsInfo then
		if itemType == ItemTypeEnum.Look then
			v18 = not not lookData and lookData.totalPrice ~= nil
			v19 = t1.widgetAnalyticsInfo.itemId ~= nil
			v20 = true
		else
			v18 = not not hydratedContent and hydratedContent.price ~= nil
			v19 = t1.widgetAnalyticsInfo.itemId ~= nil
			v20 = true
		end
	elseif t1.isOrganic then
		if itemType == ItemTypeEnum.Look then
			v18 = not not lookData and lookData.totalPrice ~= nil
			v19 = t1.itemId ~= nil
			v20 = true
		else
			v18 = not not itemData and (itemData.lowestPrice ~= nil or itemData.priceInRobux ~= nil)
			v19 = t1.itemId ~= nil
			v20 = not not itemData and (itemData.assetType ~= nil or itemData.bundleType ~= nil and itemData.bundleType ~= "AvatarAnimations")
		end
	end

	return v18 == true and (v19 == true and v20 == true)
end
local function buildFields(t2: {[any]: any}) -- line: 123
	-- upvalues: getMarketplaceUnifiedItemType (copy), getItemSelectionAction (copy), UnifiedEventLoggingUtils (copy), getTimedOptionForItemData (copy), FFlagAddTypesToWidgetItems (copy), Cryo (copy)
	local itemData = t2.itemData
	local lookData = t2.lookData
	local hydratedContent = t2.hydratedContent
	local assetAndBundleIds = t2.assetAndBundleIds
	local isOrganic = t2.isOrganic
	local widgetAnalyticsInfo = t2.widgetAnalyticsInfo
	local v28 = widgetAnalyticsInfo or {
		itemId = t2.itemId,
		assetType = if not itemData then nil else itemData.assetType,
		bundleType = if not itemData then nil else itemData.bundleType,
		gridPositionRow = t2.gridPositionRow,
		gridPositionColumn = t2.gridPositionColumn
	}
	local t3 = {
		itemType = getMarketplaceUnifiedItemType(t2.itemType),
		action = getItemSelectionAction(t2.isSelected == true),
		category = t2.impressionsCategory,
		subcategory = t2.impressionsSubcategory,
		taxonomyId = t2.impressionsTaxonomyId,
		assetIds = if not widgetAnalyticsInfo or not assetAndBundleIds then nil else assetAndBundleIds.assetIds,
		bundleIds = if not widgetAnalyticsInfo or not assetAndBundleIds then nil else assetAndBundleIds.bundleIds,
		organicAssetIds = if not isOrganic or not assetAndBundleIds then nil else assetAndBundleIds.assetIds,
		organicBundleIds = if not isOrganic or not assetAndBundleIds then nil else assetAndBundleIds.bundleIds,
		organicLookType = if not isOrganic or (not lookData or not lookData.lookType) then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType),
		widgetLookType = if not lookData or (not lookData.lookType or isOrganic) then nil else UnifiedEventLoggingUtils.formatLookTypeAttribute(lookData.lookType),
		organicItemPrice = if not isOrganic then nil else if not lookData then if not itemData then nil else itemData.lowestPrice or itemData.priceInRobux else lookData.totalPrice,
		widgetItemPrice = if not widgetAnalyticsInfo then nil else if not lookData then if not hydratedContent then nil else hydratedContent.price else lookData.totalPrice,
		organicTimedOption = if not isOrganic or not itemData then nil else getTimedOptionForItemData(itemData),
		widgetTimedOption = if isOrganic or not itemData then nil else getTimedOptionForItemData(itemData),
		widgetAssetType = if not FFlagAddTypesToWidgetItems or (isOrganic or not itemData) then nil else itemData.assetType,
		widgetBundleType = if not FFlagAddTypesToWidgetItems or (isOrganic or not itemData) then nil else itemData.bundleType
	}

	return Cryo.Dictionary.join(v28, t3)
end
local function getCatalogItemUnifiedLoggingFields(t4: {[any]: any}) -- line: 188
	-- upvalues: isReadyToLog (copy), buildFields (copy)
	if not isReadyToLog(t4) then
		return nil
	end

	return buildFields(t4)
end

return getCatalogItemUnifiedLoggingFields
