local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
require("@luauforge/bundled/dPs")
local module = require("@luauforge/deferred/hbR")

local fFlagAXCatalogCategoriesStoreImprovePerf = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogCategoriesStoreImprovePerf

local function ItemGroupWidget(props)
	local createElement = React.createElement
	local v6 = {
		LayoutOrder = props.LayoutOrder,
		widgetInfo = props.widgetInfo,
		itemsPerRow = props.itemsPerRow,
		rowCount = props.rowCount,
		rowHeight = props.rowHeight,
		widgetRow = props.widgetRow,
		itemSize = props.itemSize,
		widgetAnalyticsInfo = props.widgetAnalyticsInfo,
		widgetFocused = props.widgetFocused,
		gridRef = props.gridRef,
		itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
		requestWidgetAcquireFocus = props.requestWidgetAcquireFocus,
		getItemMetrics = props.getItemMetrics,
		hideItemName = props.hideItemName,
		widgetConfiguration = props.widgetConfiguration,
		ixpLayerToExpose = props.ixpLayerToExpose,
		displayAsItemGroupWidget = true,
		rowWidth = props.rowWidth,
		onThumbnailLoaded = props.onThumbnailLoaded,
		selectedCategory = 0,
		selectedSubcategory = 0,
		selectedCategoryInfo = 0
	}

	local v7 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategory else nil
	v6.selectedCategory = v7
	local v8 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedSubcategory else nil
	v6.selectedSubcategory = v8
	local v9 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategoryInfo else nil
	v6.selectedCategoryInfo = v9
	return createElement(module, v6)
end

return ItemGroupWidget
