local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useStyle = require(CorePackages.Packages.UIBlox).Core.Style.useStyle

require(CorePackages.Workspace.Packages.AppCommonLib)

local FullView = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Enums.FullView
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local Constants = require(Modules.AvatarExperience.Common.Constants)
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local GetFFlagAXEnableCategoryPills = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableCategoryPills)
local useResultsAreSduiEnabled = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useResultsAreSduiEnabled)
local FFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXCatalogSearchSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSearchSupportDisableFilters
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXCatalogSduiSingleRetryButtonOnError = AvatarExperienceFlags.FFlagAXCatalogSduiSingleRetryButtonOnError

require(script.Parent.CatalogResultListNavigationView)

local function useCatalogResultListNavigationViewModel(t1: {[any]: any}) -- line: 64
	-- upvalues: React (copy), useNavigation (copy), useStyle (copy), AvatarScreen (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXMigrateAllTabToSduiDev (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), FFlagAXCatalogSupportDisableFilters (copy), useDispatch (copy), useStore (copy), FullView (copy), Exit3DFullView (copy), FFlagAXCatalogSduiSingleRetryButtonOnError (copy), useResultsAreSduiEnabled (copy), GetFFlagAXEnableCategoryPills (copy), FFlagAXMoveCatalogFilterToL1Navigation (copy), Constants (copy), FFlagAXCatalogSearchSupportDisableFilters (copy)
	local v27 = React.useRef(nil)
	local v28 = React.useRef(nil)
	local v29 = useNavigation()
	local Theme = useStyle().Theme
	local fromSearch = t1.fromSearch
	local v32 = t1.searchInCatalog and t1.searchInCatalog.items or nil
	local v33 = not not t1.focusedWidget and not not t1.focusedWidget.active
	local v34 = fromSearch
	local v35 = true
	local v36 = fromSearch

	if t1.hidePillBar then
		v34 = false
		v36 = false
	end

	if t1.hideTopBar then
		v35 = false
		v36 = false
		v34 = false
	end

	local searchKeyword = nil
	local routeName = v29.state.routeName

	if routeName == AvatarScreen.CatalogSearch then
		searchKeyword = (v29.getParam("searchParams") or {}).searchKeyword
	end

	local v39 = if not v35 then nil else v27
	local v40 = nil
	local DisableFilters = nil

	if FFlagAXCatalogCategoriesSDUI and not FFlagAXMigrateAllTabToSduiDev then
		local v42 = GetCatalogCategoriesStore.getCatalogCategoriesStore()

		v40 = useSignalState(v42.getCategories)
	end

	local v43 = if not fromSearch then GetCatalogCategoriesStore.getCatalogSelectionStore() else GetCatalogCategoriesStore.getCatalogSearchSelectionStore()
	local u44 = useSignalState(v43.selectedCategoryId)
	local u45 = useSignalState(v43.selectedSubcategoryId)

	if FFlagAXCatalogSupportDisableFilters then
		DisableFilters = useSignalState(v43.selectedCategoryInfo).DisableFilters
	end

	if FFlagAXMigrateAllTabToSduiDev then
		local v46 = useDispatch()
		local v47 = useStore()
		local axAnalytics = t1.axAnalytics
		local v49 = React.useRef(`{ u44 }:{ u45 }`)

		React.useEffect(function() -- line: 135
			-- upvalues: v49 (copy), u44 (ref), u45 (ref), v47 (copy), routeName (copy), FullView (copy), v46 (copy), Exit3DFullView (copy), axAnalytics (copy)
			if v49.current == `{ u44 }:{ u45 }` then
				return
			end

			v49.current = `{ u44 }:{ u45 }`

			if v47:getState().AvatarExperience.Common.FullView[routeName] == FullView.SceneFullView then
				v46(Exit3DFullView(axAnalytics, routeName))
			end
		end, {
			u44,
			u45,
			v47,
			axAnalytics,
			v46
		})
	end

	local v50 = if not FFlagAXMigrateAllTabToSduiDev or not FFlagAXCatalogSduiSingleRetryButtonOnError then nil else useResultsAreSduiEnabled()
	local v51 = if not GetFFlagAXEnableCategoryPills() and not FFlagAXMoveCatalogFilterToL1Navigation then Constants.MainNavHeight else Constants.CatalogMainNavHeight
	local v52 = v36 and (not v34 and not FFlagAXMoveCatalogFilterToL1Navigation)
	local v53 = nil

	if FFlagAXCatalogSearchSupportDisableFilters then
		v53 = not DisableFilters
	end

	local v54 = true

	if FFlagAXCatalogSupportDisableFilters then
		v54 = not DisableFilters
	end

	return {
		backgroundTransparency = Theme.BackgroundDefault.Transparency or 1,
		backgroundColor = Theme.BackgroundDefault.Color,
		restorePreviousChildFocus = t1.restorePreviousChildFocus,
		topPanelRef = t1.topPanelRef,
		defaultChildRef = if not v35 then v28 else v27,
		nextSelectionDown = if not t1.hasEntries then nil else t1.gridRef,
		updateHeightBinding = t1.updateHeightBinding,
		showNavBar = v35,
		showTopics = v34,
		showFilterButtonLayout = v52,
		focusedWidgetActive = v33,
		catalogAnalytics = t1.catalogAnalytics,
		axAnalytics = t1.axAnalytics,
		navHeightMain = v51,
		navBarRef = v27,
		navBarNextSelectionDown = if not v34 then nil else v28,
		backToTopSignal = t1.backToTopSignal,
		fromSearch = fromSearch,
		onCategoryOrSubcategoryChange = t1.onCategoryOrSubcategoryChange,
		onCategoryOrSubcategoryChangeById = t1.onCategoryOrSubcategoryChangeById,
		selectedCategoryId = u44,
		selectedSubcategoryId = u45,
		categories = if not FFlagAXCatalogCategoriesSDUI then nil else v40,
		pillBarRef = v28,
		pillBarNextSelectionUp = v39,
		topicBarItems = v32,
		searchKeyword = searchKeyword,
		showTopicBarFilterButton = v53,
		filterButtonLayoutShowFilterButton = v54,
		filterButtonLayoutNextSelectionUp = v39,
		focusedWidgetTitle = t1.focusedWidget.title,
		focusedWidgetLocalizedTitle = t1.focusedWidget.localizedTitle,
		focusedWidgetLocalizedTooltip = t1.focusedWidget.localizedTooltip,
		showCloseIcon = t1.showCloseIcon,
		searchUuid = t1.searchUuid,
		onCloseFocusedWidget = t1.onCloseFocusedWidget,
		pageIdentifier = if not FFlagAXMigrateAllTabToSduiDev then nil else routeName,
		context = if not FFlagAXMigrateAllTabToSduiDev then nil else "catalog-tab:recommended",
		shouldDisplayCategoryMenuError = if not FFlagAXMigrateAllTabToSduiDev or not FFlagAXCatalogSduiSingleRetryButtonOnError then nil else not v50
	}
end

return useCatalogResultListNavigationViewModel
