local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceCommon")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics")
local fFlagAXUnifiedEventStrictPayloads = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceFlags").FFlagAXUnifiedEventStrictPayloads

local function useWidgetItemPayload(data)
	return React.useMemo(function()
		local join = Cryo.Dictionary.join
		local widgetAnalyticsInfo = data.widgetAnalyticsInfo or {}
		local v5 = {
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

		local v6 = if fFlagAXUnifiedEventStrictPayloads then AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedAssetType(data.widgetAssetType) else data.widgetAssetType
		v5.widgetAssetType = v6

		local v7 = if fFlagAXUnifiedEventStrictPayloads then AvatarExperienceAnalytics.Utils.getMarketplaceUnifiedBundleType(data.widgetBundleType) else data.widgetBundleType
		v5.widgetBundleType = v7

		v5.widgetLookType = data.widgetLookType
		v5.assetIds = data.assetIds
		v5.bundleIds = data.bundleIds
		return join(widgetAnalyticsInfo, v5)
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
