local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
require(Modules.AvatarExperience.Common.Types)

local ItemCarouselWidget = require(Modules.AvatarExperience.Common.Components.Widgets.ItemCarouselWidget)
local FFlagAXCatalogCategoriesStoreImprovePerf = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogCategoriesStoreImprovePerf

local function ItemGroupWidget(t1: {[any]: any}) -- line: 40
	-- upvalues: React (copy), ItemCarouselWidget (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy)
	return React.createElement(ItemCarouselWidget, {
		displayAsItemGroupWidget = true,
		LayoutOrder = t1.LayoutOrder,
		widgetInfo = t1.widgetInfo,
		itemsPerRow = t1.itemsPerRow,
		rowCount = t1.rowCount,
		rowHeight = t1.rowHeight,
		widgetRow = t1.widgetRow,
		itemSize = t1.itemSize,
		widgetAnalyticsInfo = t1.widgetAnalyticsInfo,
		widgetFocused = t1.widgetFocused,
		gridRef = t1.gridRef,
		itemDetailsPeekViewRefs = t1.itemDetailsPeekViewRefs,
		requestWidgetAcquireFocus = t1.requestWidgetAcquireFocus,
		getItemMetrics = t1.getItemMetrics,
		hideItemName = t1.hideItemName,
		widgetConfiguration = t1.widgetConfiguration,
		ixpLayerToExpose = t1.ixpLayerToExpose,
		rowWidth = t1.rowWidth,
		onThumbnailLoaded = t1.onThumbnailLoaded,
		selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t1.selectedCategory,
		selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t1.selectedSubcategory,
		selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t1.selectedCategoryInfo
	})
end

return ItemGroupWidget
