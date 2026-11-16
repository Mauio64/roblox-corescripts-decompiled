local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local focusable = RoactGamepad.Focusable
require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module = require("@luauforge/deferred/gUm")
local module2 = require("@luauforge/deferred/gUr")
local module3 = require("@luauforge/deferred/gSw")
local module4 = require("@luauforge/deferred/gUw")
local module5 = require("@luauforge/bundled/dMx")

local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module8 = require("@luauforge/bundled/dPP")
local catalogSduiCategoryMenuEntryPoint = AvatarExperienceCatalog.Components.CatalogSduiCategoryMenuEntryPoint
local catalogSelectionReaderContext = module8.Context.CatalogSelectionReaderContext
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
require("@luauforge/bundled/dUe")
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled

local function CatalogResultListNavigationView(props)
	local v5 = {
		[React.Tag] = "data-testid=CatalogResultListNavigationView",
		BackgroundTransparency = props.backgroundTransparency,
		BackgroundColor3 = props.backgroundColor,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		restorePreviousChildFocus = props.restorePreviousChildFocus,
		ref = props.topPanelRef,
		defaultChild = props.defaultChildRef,
		NextSelectionDown = props.nextSelectionDown,
		[React.Change.AbsoluteSize] = function(p2)
			props.updateHeightBinding(p2.AbsoluteSize.Y)
		end
	}

	if fFlagAXCatalogOffersBannerEnabled then
		v5 = {}
		v5[React.Tag] = "data-testid=CatalogResultListNavigationView"
		v5.BackgroundTransparency = props.backgroundTransparency
		v5.BackgroundColor3 = props.backgroundColor
		v5.BorderSizePixel = 0
		v5.Size = UDim2.new(1, 0, 0, 0)
		v5.AutomaticSize = Enum.AutomaticSize.Y

		v5.restorePreviousChildFocus = props.restorePreviousChildFocus
		v5.ref = props.topPanelRef
		v5.defaultChild = props.defaultChildRef
		v5.NextSelectionDown = props.nextSelectionDown

		local updateHeightBinding = props.updateHeightBinding

		if updateHeightBinding then
			v5[React.Change.AbsoluteSize] = function(p2)
				updateHeightBinding(p2.AbsoluteSize.Y)
			end
		end
	end

	local createElement = React.createElement
	local frame = focusable.Frame
	local v6 = {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		NavBar = 0,
		PillBar = 0,
		FocusedWidgetBar = 0
	}
	local v7

	if props.showNavBar then
		if fFlagAXMigrateAllTabToSduiDev then
			v7 = React.createElement(
				catalogSelectionReaderContext.Context.Provider,
				{ value = props.catalogSelectionReader },
				{
					Menu = React.createElement(catalogSduiCategoryMenuEntryPoint, {
						context = props.context or "",
						appPage = props.pageIdentifier or avatarScreen.Catalog,
						shouldDisplayError = props.shouldDisplayCategoryMenuError
					})
				}
			)
		else
			v7 = React.createElement(module2, {
				analytics = props.catalogAnalytics,
				axAnalytics = props.axAnalytics,
				layoutOrderMain = 1,
				layoutOrderSub = 2,
				navHeightMain = props.navHeightMain,
				navHeightSub = module5.SubNavHeight,
				navBarRef = props.navBarRef,
				NextSelectionDown = props.navBarNextSelectionDown,
				backToTopSignal = props.backToTopSignal,
				showingTopics = props.showTopics,
				fromSearch = props.fromSearch,
				onCategoryOrSubcategoryChange = props.onCategoryOrSubcategoryChange,
				onCategoryOrSubcategoryChangeById = props.onCategoryOrSubcategoryChangeById,
				selectedCategoryId = props.selectedCategoryId,
				selectedSubcategoryId = props.selectedSubcategoryId,
				categories = props.categories
			})
		end
	end

	v6.NavBar = v7
	local v8

	if props.showTopics then
		v8 = React.createElement(module, {
			layoutOrder = 3,
			NextSelectionUp = props.pillBarNextSelectionUp,
			frameRef = props.pillBarRef,
			items = props.topicBarItems,
			searchKeyword = props.searchKeyword,
			showFilterButton = props.showTopicBarFilterButton or false
		})
	elseif props.showFilterButtonLayout then
		v8 = React.createElement(module3, {
			height = module5.PillBarHeight,
			isContentEmpty = true,
			layoutOrder = 3,
			showFilterButton = props.filterButtonLayoutShowFilterButton,
			layoutRef = props.pillBarRef,
			NextSelectionUp = props.filterButtonLayoutNextSelectionUp
		})
	end

	v6.PillBar = v8

	local v9 = if props.focusedWidgetActive then React.createElement(module4, {
		active = props.focusedWidgetActive,
		focusedWidgetTitle = props.focusedWidgetTitle,
		focusedWidgetLocalizedTitle = props.focusedWidgetLocalizedTitle,
		focusedWidgetLocalizedTooltip = props.focusedWidgetLocalizedTooltip,
		showCloseIcon = props.showCloseIcon,
		searchUuid = props.searchUuid,
		layoutOrder = 4,
		onClose = props.onCloseFocusedWidget
	}) else nil
	v6.FocusedWidgetBar = v9
	return createElement(frame, v5, v6)
end

return CatalogResultListNavigationView
