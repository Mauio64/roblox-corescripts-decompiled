local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
require(parent.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)
local AvatarExperienceFlags = require(parent.AvatarExperienceFlags)
local FFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local function useWidgetItemPayload(data)
	return React.useMemo(function()
		local join = Cryo.Dictionary.join
		local widgetAnalyticsInfo = data.widgetAnalyticsInfo or {}
		local v = {
			action = data.action,
			itemId = data.itemId,
			itemType = data.itemType,
			itemPosition = data.itemPosition,
			gridPositionRow = data.gridPositionRow,
			gridPositionColumn = data.gridPositionColumn,
			uiTreatmentType = data.uiTreatmentType,
			themeId = data.themeId,
			category = data.category,
			subcategory = data.subcategory,
			taxonomyId = data.taxonomyId,
			widgetItemPrice = data.widgetItemPrice,
			widgetTimedOption = data.widgetTimedOption,
			widgetAssetType = 0,
			widgetBundleType = 0,
			widgetLookType = 0,
			assetIds = 0,
			bundleIds = 0
		}
		local widgetAssetType

		if FFlagAXUnifiedEventStrictPayloads then
			widgetAssetType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType(data.widgetAssetType)
		else
			widgetAssetType = data.widgetAssetType
		end

		v.widgetAssetType = widgetAssetType
		local widgetBundleType

		if FFlagAXUnifiedEventStrictPayloads then
			widgetBundleType = AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType(data.widgetBundleType)
		else
			widgetBundleType = data.widgetBundleType
		end

		v.widgetBundleType = widgetBundleType

		v.widgetLookType = data.widgetLookType
		v.assetIds = data.assetIds
		v.bundleIds = data.bundleIds
		return join(widgetAnalyticsInfo, v)
	end, {
		data.action,
		data.widgetAnalyticsInfo,
		data.itemId,
		data.itemType,
		data.itemPosition,
		data.gridPositionRow,
		data.gridPositionColumn,
		data.uiTreatmentType,
		data.themeId,
		data.category,
		data.subcategory,
		data.taxonomyId,
		data.widgetItemPrice,
		data.widgetTimedOption,
		data.widgetAssetType,
		data.widgetBundleType,
		data.widgetLookType,
		data.assetIds,
		data.bundleIds
	})
end

return useWidgetItemPayload
