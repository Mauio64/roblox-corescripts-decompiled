local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local Foundation = require(CorePackages.Packages.Foundation)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

require("@luauforge/bundled/dPs")
local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/fCe")
local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums
local getFooterVisibilityFromItemFooters = AvatarExperienceCatalog.Utils.getFooterVisibilityFromItemFooters

local module5 = require("@luauforge/deferred/hby")
local view = Foundation.View

local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf

local v5 = {
	__index = function(p2, p3)
		local ref = React.createRef()
		rawset(p2, p3, ref)
		return ref
	end
}

local function HeroItemRow(props)
	local v6 = React.useMemo(function()
		return (setmetatable({}, v5))
	end, {})

	local widgetInfo = props.widgetInfo
	local content = widgetInfo.content or {}
	local v7 = math.min(#content, props.itemsPerRow)

	if v7 <= 0 then
		return nil
	end

	local v8 = math.max(1, props.itemWidth)

	local creatorNameTileFooterEnabled = module4.getCreatorNameTileFooterEnabled(props.widgetConfiguration)

	local v10 = if widgetInfo.template then widgetInfo.template.itemFooters else nil
	local v11 = getFooterVisibilityFromItemFooters(v10)

	local children = {}

	for i = 1, v7 do
		local v12 = content[i] or {}
		local v13

		if
			v12.type == module3.ItemType.Look
			and props.hydratedWidgetData
			and props.hydratedWidgetData[module3.ItemType.Look]
			and props.hydratedWidgetData[module3.ItemType.Look][v12.id]
		then
			v13 = props.hydratedWidgetData[module3.ItemType.Look][v12.id].lookType
		end

		local joined = Cryo.Dictionary.join(props.widgetAnalyticsInfo, {
			itemPosition = i,
			itemId = v12.id,
			itemType = v12.type,
			lookType = v13,
			themeId = widgetInfo.tagId,
			gridPositionRow = props.widgetRow,
			gridPositionColumn = i,
			uiTreatmentType = unifiedEventLogEnums.WidgetUiTreatment.HERO_UNIT
		})

		local formatted = `Tile_{i}`
		local createElement = React.createElement
		local v15 = {
			size = UDim2.new(0, v8, 0, 0),
			cardStyle = 0,
			imageScaleType = 0,
			contentType = 0,
			tileContentType = 0,
			contentId = 0,
			index = 0,
			refCache = 0,
			resultsListRef = 0,
			itemDetailsPeekViewRefs = 0,
			itemsPerRow = 0,
			analyticsItemCountPerPage = 0,
			creatorNameTileFooterEnabled = 0,
			isCreatorNameVisible = 0,
			isTitleVisible = 0,
			isPriceVisible = 0,
			impressionsTag = 0,
			widgetAnalyticsInfo = 0,
			onThumbnailLoaded = 0,
			selectedCategory = 0,
			selectedSubcategory = 0,
			selectedCategoryInfo = 0
		}
		local v16 = if widgetInfo.template then widgetInfo.template.cardStyle else nil
		v15.cardStyle = v16
		v15.imageScaleType = Enum.ScaleType.Stretch
		v15.contentType = v12.type or "Asset"
		v15.tileContentType = widgetInfo.type
		v15.contentId = v12.id or ""
		v15.index = i
		v15.refCache = v6
		v15.resultsListRef = props.resultsListRef
		v15.itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs
		v15.itemsPerRow = v7
		v15.analyticsItemCountPerPage = v7
		v15.creatorNameTileFooterEnabled = creatorNameTileFooterEnabled
		v15.isCreatorNameVisible = v11.isCreatorNameVisible
		v15.isTitleVisible = v11.isTitleVisible
		v15.isPriceVisible = v11.isPriceVisible
		v15.impressionsTag = props.impressionsTag
		v15.widgetAnalyticsInfo = joined
		v15.onThumbnailLoaded = props.onThumbnailLoaded
		local v17 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategory else nil
		v15.selectedCategory = v17
		local v18 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedSubcategory else nil
		v15.selectedSubcategory = v18
		local v19 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategoryInfo else nil
		v15.selectedCategoryInfo = v19
		children[formatted] = createElement(module5, v15)
	end

	return React.createElement(
		view,
		{
			LayoutOrder = props.LayoutOrder,
			tag = "row align-y-top gap-medium size-full-0 auto-y"
		},
		children
	)
end

return HeroItemRow
