local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)

require(CorePackages.Workspace.Packages.AppCommonLib)

local Focusable = RoactGamepad.Focusable
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle
local FilterButtonLayout = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterButtonLayout)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogTopicBar = require(Modules.AvatarExperience.Catalog.Components.CatalogTopicBar)
local CatalogNavigation = require(Modules.AvatarExperience.Catalog.Components.NavBar.CatalogNavigation)
local FocusedWidgetTopContent = require(Modules.AvatarExperience.Common.Components.Widgets.FocusedWidgetTopContent)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local GetFFlagAXEnableCategoryPills = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableCategoryPills)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXCatalogSearchSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSearchSupportDisableFilters
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState

local function ResultsListTopPanel(t1: {[any]: any}) -- line: 56
	-- upvalues: React (copy), useNavigation (copy), useStyle (copy), AvatarScreen (copy), FFlagAXCatalogCategoriesSDUI (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), FFlagAXCatalogSupportDisableFilters (copy), FFlagAXCatalogOffersBannerEnabled (copy), Roact (copy), Focusable (copy), CatalogNavigation (copy), GetFFlagAXEnableCategoryPills (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), Constants (copy), CatalogTopicBar (copy), FFlagAXCatalogSearchSupportDisableFilters (copy), FilterButtonLayout (copy), FocusedWidgetTopContent (copy)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = useNavigation()
	local fromSearch = t1.fromSearch
	local catalogAnalytics = t1.catalogAnalytics
	local axAnalytics = t1.axAnalytics
	local searchInCatalog = t1.searchInCatalog
	local v34 = searchInCatalog and searchInCatalog.items or nil
	local Theme = useStyle().Theme
	local fromSearch2 = t1.fromSearch
	local v37 = React.useMemo(function() -- line: 71
		-- upvalues: v29 (copy), AvatarScreen (copy)
		if v29.state.routeName == AvatarScreen.CatalogSearch then
			return (v29.getParam("searchParams") or {}).searchKeyword
		end

		return nil
	end, { v29 })
	local v38 = true
	local v39 = fromSearch
	local hideTopBar = t1.hideTopBar
	local active = t1.focusedWidget.active

	if t1.hidePillBar then
		fromSearch2 = false
		v39 = false
	end

	if hideTopBar then
		v38 = false
		v39 = false
		fromSearch2 = false
	end

	local v42 = if not v38 then nil else v27
	local v43 = nil
	local DisableFilters = nil

	if FFlagAXCatalogCategoriesSDUI then
		local v45 = GetCatalogCategoriesStore.getCatalogCategoriesStore()

		v43 = useSignalState(v45.getCategories)
	end

	local v46 = if not t1.fromSearch then GetCatalogCategoriesStore.getCatalogSelectionStore() else GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local v47 = useSignalState(v46.selectedCategoryId)
	local v48 = useSignalState(v46.selectedSubcategoryId)

	if FFlagAXCatalogSupportDisableFilters then
		DisableFilters = useSignalState(v46.selectedCategoryInfo).DisableFilters
	end

	local t2

	if not FFlagAXCatalogOffersBannerEnabled then
		t2 = {
			BackgroundTransparency = Theme.BackgroundDefault.Transparency or 1,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			restorePreviousChildFocus = t1.restorePreviousChildFocus,
			ref = t1.topPanelRef,
			defaultChild = if not v38 then v28 else v27,
			NextSelectionDown = if not t1.hasEntries then nil else t1.gridRef,
			[Roact.Change.AbsoluteSize] = function(p1) -- line: 143
				-- upvalues: t1 (copy)
				t1.updateHeightBinding(p1.AbsoluteSize.Y)
			end
		}
	else
		t2 = {
			BorderSizePixel = 0,
			BackgroundTransparency = Theme.BackgroundDefault.Transparency or 1,
			BackgroundColor3 = Theme.BackgroundDefault.Color,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			restorePreviousChildFocus = t1.restorePreviousChildFocus,
			ref = t1.topPanelRef,
			defaultChild = if not v38 then v28 else v27,
			NextSelectionDown = if not t1.hasEntries then nil else t1.gridRef
		}

		local updateHeightBinding = t1.updateHeightBinding

		if updateHeightBinding then
			t2[Roact.Change.AbsoluteSize] = function(p2) -- line: 162
				-- upvalues: updateHeightBinding (copy)
				updateHeightBinding(p2.AbsoluteSize.Y)
			end
		end
	end

	return Roact.createElement(Focusable.Frame, t2, {
		ListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		NavBar = if not v38 then nil else Roact.createElement(CatalogNavigation, {
			layoutOrderMain = 1,
			layoutOrderSub = 2,
			analytics = catalogAnalytics,
			axAnalytics = axAnalytics,
			navHeightMain = if not GetFFlagAXEnableCategoryPills() and not FFlagAXMoveCatalogFilterToL1Navigation then Constants.MainNavHeight else Constants.CatalogMainNavHeight,
			navHeightSub = Constants.SubNavHeight,
			navBarRef = v27,
			NextSelectionDown = if not fromSearch2 then nil else v28,
			backToTopSignal = t1.backToTopSignal,
			showingTopics = fromSearch2,
			fromSearch = fromSearch,
			onCategoryOrSubcategoryChange = t1.onCategoryOrSubcategoryChange,
			onCategoryOrSubcategoryChangeById = t1.onCategoryOrSubcategoryChangeById,
			selectedCategoryId = v47,
			selectedSubcategoryId = v48,
			categories = if not FFlagAXCatalogCategoriesSDUI then nil else v43
		}),
		PillBar = if not fromSearch2 then if not v39 or FFlagAXMoveCatalogFilterToL1Navigation then nil else Roact.createElement(FilterButtonLayout, {
			isContentEmpty = true,
			layoutOrder = 3,
			height = Constants.PillBarHeight,
			showFilterButton = not FFlagAXCatalogSupportDisableFilters or not DisableFilters,
			layoutRef = v28,
			NextSelectionUp = v42
		}) else Roact.createElement(CatalogTopicBar, {
			layoutOrder = 3,
			NextSelectionUp = v42,
			frameRef = v28,
			items = v34,
			searchKeyword = v37,
			showFilterButton = if not FFlagAXCatalogSearchSupportDisableFilters then nil else not DisableFilters
		}),
		FocusedWidgetBar = if not active then nil else React.createElement(FocusedWidgetTopContent, {
			layoutOrder = 4,
			active = active,
			focusedWidgetTitle = t1.focusedWidget.title,
			focusedWidgetLocalizedTitle = t1.focusedWidget.localizedTitle,
			focusedWidgetLocalizedTooltip = t1.focusedWidget.localizedTooltip,
			showCloseIcon = t1.showCloseIcon,
			searchUuid = t1.searchUuid,
			onClose = t1.onCloseFocusedWidget
		})
	})
end

return ResultsListTopPanel
