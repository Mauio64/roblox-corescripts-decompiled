local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)

require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local widgetListItem = require("@luauforge/deferred/gkN").WidgetComponents.WidgetListItem
local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local widgetIxpLayerMap = AvatarExperienceCatalog.Utils.WidgetIxpLayerMap

require("@luauforge/bundled/dMc")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
local module2 = require("@luauforge/deferred/gPN")
local module3 = require("@luauforge/deferred/gPS")
local module4 = require("@luauforge/deferred/gPO")
local module5 = require("@luauforge/deferred/gPU")
local module6 = require("@luauforge/bundled/fvF")
local module7 = require("@luauforge/bundled/eeH")
local impressionEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").Enums.ImpressionEnums

local module8 = require("@luauforge/deferred/gQf")
local module9 = require("@luauforge/deferred/gQg")

local fFlagAXCatalogCategoriesStoreImprovePerf = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCatalogCategoriesStoreImprovePerf
local defineFastFlag = game:DefineFastFlag("AXRemoveEntryButtonWidget", false)

local v5 = {
	[widgetConstants.Templates.ItemGroup] = {
		component = module2,
		horizontalMargin = 15
	},
	[widgetConstants.Templates.Carousel] = {
		component = module4,
		horizontalMargin = 15
	},
	[widgetConstants.Templates.Button] = not defineFastFlag and {
		component = module3,
		horizontalMargin = 15
	} or nil,
	[widgetConstants.Templates.HeroUnit] = {
		component = module5,
		horizontalMargin = 15
	}
}

local forwardRef = React.forwardRef(function(props, p2)
	local widgetRow = props.widgetRow
	local widgetInfo = props.widgetInfo
	local widgetConfiguration = props.widgetConfiguration
	local v6 = module7(module6)
	local v7 = useDesignTokens()

	if
		not widgetInfo
		or not widgetInfo.template
		or not widgetInfo.template.type
		or v5[widgetInfo.template.type] == nil
	then
		return nil
	end

	assert(widgetInfo.template, "")
	local v8 = v5[widgetInfo.template.type]
	local component = v8.component

	local horizontalMargin = v8.horizontalMargin

	local v9 = React.useCallback(function()
		if props.requestWidgetAcquireFocus then
			local SEE_ALL = impressionEnums.ActionType.SEE_ALL
			v6.widgetInteractionV2(props.widgetAnalyticsInfo, SEE_ALL)
			props.requestWidgetAcquireFocus()
		end
	end, { props.requestWidgetAcquireFocus })
	local v10

	if module8() then
		local v11 = {
			[32] = v7.Size.Size_800,
			[24] = v7.Size.Size_600,
			[20] = v7.Size.Size_500,
			[16] = v7.Size.Size_400
		}

		v10 = if v11[module9()] == nil then v7.Size.Size_800 else v11[module9()]
	end

	local createElement = React.createElement
	local v12 = {
		ref = p2,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		padding = 0,
		horizontalMargin = 0
	}

	local v14 = if module8() then UDim.new(0, v10) else UDim.new(0, v7.Size.Size_800)
	v12.padding = { bottom = v14 }

	v12.horizontalMargin = horizontalMargin

	local createElement2 = React.createElement
	local v16 = {
		widgetInfo = props.widgetInfo,
		itemsPerRow = props.itemsPerRow,
		rowHeight = props.rowHeight,
		rowCount = props.rowCount,
		widgetRow = widgetRow,
		widgetAnalyticsInfo = props.widgetAnalyticsInfo,
		widgetFocused = props.widgetFocused,
		requestWidgetAcquireFocus = v9,
		requestWidgetReleaseFocus = props.requestWidgetReleaseFocus,
		itemDetailsPeekViewRefs = props.itemDetailsPeekViewRefs,
		gridRef = props.gridRef,
		gamepadNavigationFocusPos = props.gamepadNavigationFocusPos,
		setGamepadNavigationFocusPos = props.setGamepadNavigationFocusPos,
		itemSize = props.itemSize,
		ixpLayerToExpose = widgetIxpLayerMap[props.widgetInfo.type],
		widgetConfiguration = widgetConfiguration,
		rowWidth = props.rowWidth,
		onThumbnailLoaded = props.onThumbnailLoaded,
		selectedCategory = 0,
		selectedSubcategory = 0,
		selectedCategoryInfo = 0
	}

	local v17 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategory else nil
	v16.selectedCategory = v17
	local v18 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedSubcategory else nil
	v16.selectedSubcategory = v18
	local v19 = if fFlagAXCatalogCategoriesStoreImprovePerf then props.selectedCategoryInfo else nil
	v16.selectedCategoryInfo = v19
	return createElement(widgetListItem, v12, {
		Widget = createElement2(component, v16)
	})
end)

return (React.memo(forwardRef))
