local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)

require(Modules.AvatarExperience.Common.Types)

local Constants = require(Modules.AvatarExperience.Common.Constants)
local Utils = require(Modules.AvatarExperience.Common.Utils)
local UnifiedEventLogEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).UnifiedEventLogEnums
local getFooterVisibilityFromItemFooters = AvatarExperienceCatalog.Utils.getFooterVisibilityFromItemFooters
local WidgetTileWithImpressionsTagging = require(Modules.AvatarExperience.Common.Components.Widgets.WidgetTileWithImpressionsTagging)
local View = Foundation.View
local FFlagAXLookAndFeelBackgrounds = AvatarExperienceFlags.FFlagAXLookAndFeelBackgrounds
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local t1 = {
	__index = function(p1, p2) -- line: 30
		-- upvalues: React (copy)
		local v20 = React.createRef()

		rawset(p1, p2, v20)

		return v20
	end
}

local function HeroItemRow(t2: {[any]: any}) -- line: 58
	-- upvalues: React (copy), t1 (copy), Utils (copy), getFooterVisibilityFromItemFooters (copy), Constants (copy), Cryo (copy), UnifiedEventLogEnums (copy), WidgetTileWithImpressionsTagging (copy), FFlagAXLookAndFeelBackgrounds (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy), View (copy)
	local v22 = React.useMemo(function() -- line: 62
		-- upvalues: t1 (copy)
		return (setmetatable({}, t1))
	end, {})
	local widgetInfo = t2.widgetInfo
	local v24 = widgetInfo.content or {}
	local v25 = math.min(#v24, t2.itemsPerRow)

	if v25 <= 0 then
		return nil
	end

	local v26 = math.max(1, t2.itemWidth)
	local v27 = Utils.getCreatorNameTileFooterEnabled(t2.widgetConfiguration)
	local v28 = getFooterVisibilityFromItemFooters(if not widgetInfo.template then nil else widgetInfo.template.itemFooters)
	local t3 = {}

	for i = 1, v25 do
		local v31 = v24[i] or {}
		local v32 = if v31.type ~= Constants.ItemType.Look or (not t2.hydratedWidgetData or (not t2.hydratedWidgetData[Constants.ItemType.Look] or not t2.hydratedWidgetData[Constants.ItemType.Look][v31.id])) then nil else t2.hydratedWidgetData[Constants.ItemType.Look][v31.id].lookType
		local v33 = Cryo.Dictionary.join(t2.widgetAnalyticsInfo, {
			itemPosition = i,
			itemId = v31.id,
			itemType = v31.type,
			lookType = v32,
			themeId = widgetInfo.tagId,
			gridPositionRow = t2.widgetRow,
			gridPositionColumn = i,
			uiTreatmentType = UnifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT
		})

		t3[`Tile_{ i }`] = React.createElement(WidgetTileWithImpressionsTagging, {
			size = UDim2.new(0, v26, 0, 0),
			cardStyle = if not FFlagAXLookAndFeelBackgrounds or not widgetInfo.template then nil else widgetInfo.template.cardStyle,
			imageScaleType = if not FFlagAXLookAndFeelBackgrounds then nil else Enum.ScaleType.Stretch,
			contentType = v31.type or "Asset",
			tileContentType = widgetInfo.type,
			contentId = v31.id or "",
			index = i,
			refCache = v22,
			resultsListRef = t2.resultsListRef,
			itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs,
			itemsPerRow = v25,
			analyticsItemCountPerPage = v25,
			creatorNameTileFooterEnabled = v27,
			isCreatorNameVisible = v28.isCreatorNameVisible,
			isTitleVisible = v28.isTitleVisible,
			isPriceVisible = v28.isPriceVisible,
			impressionsTag = t2.impressionsTag,
			widgetAnalyticsInfo = v33,
			onThumbnailLoaded = t2.onThumbnailLoaded,
			selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t2.selectedCategory,
			selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t2.selectedSubcategory,
			selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t2.selectedCategoryInfo
		})
	end

	return React.createElement(View, {
		tag = "row align-y-top gap-medium size-full-0 auto-y",
		LayoutOrder = t2.LayoutOrder
	}, t3)
end

return HeroItemRow
