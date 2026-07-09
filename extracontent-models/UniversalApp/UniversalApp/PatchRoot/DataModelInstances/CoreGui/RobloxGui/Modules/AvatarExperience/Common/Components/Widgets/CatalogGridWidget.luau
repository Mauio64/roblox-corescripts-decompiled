local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local WidgetListItem = require(CorePackages.Workspace.Packages.AvatarExperienceUIKit).WidgetComponents.WidgetListItem
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local WidgetIxpLayerMap = AvatarExperienceCatalog.Utils.WidgetIxpLayerMap

require(Modules.AvatarExperience.Common.Types)

local WidgetConstants = AvatarExperienceCatalog.WidgetConstants
local ItemGroupWidget = require(Modules.AvatarExperience.Common.Components.Widgets.ItemGroupWidget)
local EntryButtonWidget = require(Modules.AvatarExperience.Common.Components.Widgets.EntryButtonWidget)
local ItemCarouselWidget = require(Modules.AvatarExperience.Common.Components.Widgets.ItemCarouselWidget)
local HeroUnitWidget = require(Modules.AvatarExperience.Common.Components.Widgets.HeroUnitWidget)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local ImpressionEnums = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).Enums.ImpressionEnums
local GetFFlagEnableDecreaseWidgetPaddingSizing = require(Modules.AvatarExperience.Flags.GetFFlagEnableDecreaseWidgetPaddingSizing)
local GetFIntWidgetPaddingSizing = require(Modules.AvatarExperience.Flags.GetFIntWidgetPaddingSizing)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local v22 = game:DefineFastFlag("AXRemoveEntryButtonWidget", false)
local FFlagAXHeroWidget = AvatarExperienceFlags.FFlagAXHeroWidget
local t1 = {
	[WidgetConstants.Templates.ItemGroup] = {
		horizontalMargin = 15,
		component = ItemGroupWidget
	},
	[WidgetConstants.Templates.Carousel] = {
		horizontalMargin = 15,
		component = ItemCarouselWidget
	},
	[WidgetConstants.Templates.Button] = if not v22 then {
		horizontalMargin = 15,
		component = EntryButtonWidget
	} else nil
}

if FFlagAXHeroWidget then
	t1[WidgetConstants.Templates.HeroUnit] = {
		horizontalMargin = 15,
		component = HeroUnitWidget
	}
end

local v25 = React.forwardRef(function(t2: {[any]: any}, p1) -- line: 102
	-- upvalues: useRoactService (copy), Analytics (copy), useDesignTokens (copy), t1 (copy), React (copy), ImpressionEnums (copy), GetFFlagEnableDecreaseWidgetPaddingSizing (copy), FFlagRenameDeprecatedUIBloxTokens (copy), GetFIntWidgetPaddingSizing (copy), WidgetListItem (copy), WidgetIxpLayerMap (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy)
	local widgetRow = t2.widgetRow
	local widgetInfo = t2.widgetInfo
	local widgetConfiguration = t2.widgetConfiguration
	local v31 = useRoactService(Analytics)
	local v32 = useDesignTokens()

	if not widgetInfo or (not widgetInfo.template or not widgetInfo.template.type or t1[widgetInfo.template.type] == nil) then
		return nil
	end

	assert(widgetInfo.template, "")

	local v33 = t1[widgetInfo.template.type]
	local component = v33.component
	local horizontalMargin = v33.horizontalMargin
	local v36 = React.useCallback(function() -- line: 125
		-- upvalues: t2 (copy), ImpressionEnums (copy), v31 (copy)
		if t2.requestWidgetAcquireFocus then
			local SEE_ALL = ImpressionEnums.ActionType.SEE_ALL

			v31.widgetInteractionV2(t2.widgetAnalyticsInfo, SEE_ALL)
			t2.requestWidgetAcquireFocus()
		end
	end, { t2.requestWidgetAcquireFocus })
	local v37 = nil

	if GetFFlagEnableDecreaseWidgetPaddingSizing() then
		local t3 = {
			[32] = if not FFlagRenameDeprecatedUIBloxTokens then v32.Global.Space_400 else v32.Size.Size_800,
			[24] = if not FFlagRenameDeprecatedUIBloxTokens then v32.Global.Space_300 else v32.Size.Size_600,
			[20] = if not FFlagRenameDeprecatedUIBloxTokens then v32.Global.Space_250 else v32.Size.Size_500,
			[16] = if not FFlagRenameDeprecatedUIBloxTokens then v32.Global.Space_200 else v32.Size.Size_400
		}

		v37 = if t3[GetFIntWidgetPaddingSizing()] ~= nil then t3[GetFIntWidgetPaddingSizing()] else if not FFlagRenameDeprecatedUIBloxTokens then v32.Global.Space_400 else v32.Size.Size_800
	end

	return React.createElement(WidgetListItem, {
		ref = p1,
		NextSelectionUp = t2.NextSelectionUp,
		NextSelectionDown = t2.NextSelectionDown,
		padding = {
			bottom = if not GetFFlagEnableDecreaseWidgetPaddingSizing() then UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v32.Global.Space_400 else v32.Size.Size_800) else UDim.new(0, v37)
		},
		horizontalMargin = horizontalMargin
	}, {
		Widget = React.createElement(component, {
			widgetInfo = t2.widgetInfo,
			itemsPerRow = t2.itemsPerRow,
			rowHeight = t2.rowHeight,
			rowCount = t2.rowCount,
			widgetRow = widgetRow,
			widgetAnalyticsInfo = t2.widgetAnalyticsInfo,
			widgetFocused = t2.widgetFocused,
			requestWidgetAcquireFocus = v36,
			requestWidgetReleaseFocus = t2.requestWidgetReleaseFocus,
			itemDetailsPeekViewRefs = t2.itemDetailsPeekViewRefs,
			gridRef = t2.gridRef,
			gamepadNavigationFocusPos = t2.gamepadNavigationFocusPos,
			setGamepadNavigationFocusPos = t2.setGamepadNavigationFocusPos,
			itemSize = t2.itemSize,
			ixpLayerToExpose = WidgetIxpLayerMap[t2.widgetInfo.type],
			widgetConfiguration = widgetConfiguration,
			rowWidth = t2.rowWidth,
			onThumbnailLoaded = t2.onThumbnailLoaded,
			selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t2.selectedCategory,
			selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t2.selectedSubcategory,
			selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t2.selectedCategoryInfo
		})
	})
end)

return (React.memo(v25))
