local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require(CorePackages.Workspace.Packages.AppCommonLib)

local Focusable = RoactGamepad.Focusable

require(CorePackages.Workspace.Packages.AvatarExperienceCommon)

local CatalogTopicBar = require(Modules.AvatarExperience.Catalog.Components.CatalogTopicBar)
local CatalogNavigation = require(Modules.AvatarExperience.Catalog.Components.NavBar.CatalogNavigation)
local FilterButtonLayout = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButtonLayout)
local FocusedWidgetTopContent = require(Modules.AvatarExperience.Common.Components.Widgets.FocusedWidgetTopContent)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local CatalogSduiCategoryMenuEntryPoint = AvatarExperienceCatalog.Components.CatalogSduiCategoryMenuEntryPoint
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen

require(CorePackages.Workspace.Packages.SduiSharedUtilities)

local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled

local function CatalogResultListNavigationView(t1: {[any]: any}) -- line: 90
	-- upvalues: React (copy), FFlagAXCatalogOffersBannerEnabled (copy), Focusable (copy), FFlagAXMigrateAllTabToSduiDev (copy), CatalogSduiCategoryMenuEntryPoint (copy), AvatarScreen (copy), CatalogNavigation (copy), Constants (copy), CatalogTopicBar (copy), FilterButtonLayout (copy), FocusedWidgetTopContent (copy)
	local t2 = {
		[React.Tag] = "data-testid=CatalogResultListNavigationView",
		BackgroundTransparency = t1.backgroundTransparency,
		BackgroundColor3 = t1.backgroundColor,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		restorePreviousChildFocus = t1.restorePreviousChildFocus,
		ref = t1.topPanelRef,
		defaultChild = t1.defaultChildRef,
		NextSelectionDown = t1.nextSelectionDown,
		[React.Change.AbsoluteSize] = function(p1) -- line: 103
			-- upvalues: t1 (copy)
			t1.updateHeightBinding(p1.AbsoluteSize.Y)
		end
	}

	if FFlagAXCatalogOffersBannerEnabled then
		t2 = {
			[React.Tag] = "data-testid=CatalogResultListNavigationView",
			BackgroundTransparency = t1.backgroundTransparency,
			BackgroundColor3 = t1.backgroundColor,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			restorePreviousChildFocus = t1.restorePreviousChildFocus,
			ref = t1.topPanelRef,
			defaultChild = t1.defaultChildRef,
			NextSelectionDown = t1.nextSelectionDown
		}

		local updateHeightBinding = t1.updateHeightBinding

		if updateHeightBinding then
			t2[React.Change.AbsoluteSize] = function(p2) -- line: 125
				-- upvalues: updateHeightBinding (copy)
				updateHeightBinding(p2.AbsoluteSize.Y)
			end
		end
	end

	return React.createElement(Focusable.Frame, t2, {
		ListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		NavBar = if not t1.showNavBar then nil else if not FFlagAXMigrateAllTabToSduiDev then React.createElement(CatalogNavigation, {
			layoutOrderMain = 1,
			layoutOrderSub = 2,
			analytics = t1.catalogAnalytics,
			axAnalytics = t1.axAnalytics,
			navHeightMain = t1.navHeightMain,
			navHeightSub = Constants.SubNavHeight,
			navBarRef = t1.navBarRef,
			NextSelectionDown = t1.navBarNextSelectionDown,
			backToTopSignal = t1.backToTopSignal,
			showingTopics = t1.showTopics,
			fromSearch = t1.fromSearch,
			onCategoryOrSubcategoryChange = t1.onCategoryOrSubcategoryChange,
			onCategoryOrSubcategoryChangeById = t1.onCategoryOrSubcategoryChangeById,
			selectedCategoryId = t1.selectedCategoryId,
			selectedSubcategoryId = t1.selectedSubcategoryId,
			categories = t1.categories
		}) else React.createElement(CatalogSduiCategoryMenuEntryPoint, {
			context = t1.context or "",
			appPage = t1.pageIdentifier or AvatarScreen.Catalog,
			shouldDisplayError = t1.shouldDisplayCategoryMenuError
		}),
		PillBar = if not t1.showTopics then if not t1.showFilterButtonLayout then nil else React.createElement(FilterButtonLayout, {
			isContentEmpty = true,
			layoutOrder = 3,
			height = Constants.PillBarHeight,
			showFilterButton = t1.filterButtonLayoutShowFilterButton,
			layoutRef = t1.pillBarRef,
			NextSelectionUp = t1.filterButtonLayoutNextSelectionUp
		}) else React.createElement(CatalogTopicBar, {
			layoutOrder = 3,
			NextSelectionUp = t1.pillBarNextSelectionUp,
			frameRef = t1.pillBarRef,
			items = t1.topicBarItems,
			searchKeyword = t1.searchKeyword,
			showFilterButton = t1.showTopicBarFilterButton or false
		}),
		FocusedWidgetBar = if not t1.focusedWidgetActive then nil else React.createElement(FocusedWidgetTopContent, {
			layoutOrder = 4,
			active = t1.focusedWidgetActive,
			focusedWidgetTitle = t1.focusedWidgetTitle,
			focusedWidgetLocalizedTitle = t1.focusedWidgetLocalizedTitle,
			focusedWidgetLocalizedTooltip = t1.focusedWidgetLocalizedTooltip,
			showCloseIcon = t1.showCloseIcon,
			searchUuid = t1.searchUuid,
			onClose = t1.onCloseFocusedWidget
		})
	})
end

return CatalogResultListNavigationView
