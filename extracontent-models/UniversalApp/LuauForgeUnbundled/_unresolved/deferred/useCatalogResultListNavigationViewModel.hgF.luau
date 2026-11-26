local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local fullView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Enums.FullView
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useStore = RoactUtils.Hooks.RoactRodux.useStore
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module3 = require("@luauforge/bundled/dPN")
local module4 = require("@luauforge/bundled/dSW")
local module5 = require("@luauforge/bundled/dTe")
local module6 = require("@luauforge/deferred/heG")
local module7 = require("@luauforge/bundled/dPS")

local module8 = require("@luauforge/bundled/hag")

local module9 = require("@luauforge/deferred/hgG")

require("@luauforge/bundled/dTf")

local fFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local fFlagAXCatalogSearchSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSearchSupportDisableFilters
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXCatalogSduiSingleRetryButtonOnError = AvatarExperienceFlags.FFlagAXCatalogSduiSingleRetryButtonOnError
local fFlagAXSduiProcessCatalogDeepLink = AvatarExperienceFlags.FFlagAXSduiProcessCatalogDeepLink

require("@luauforge/deferred/hgt")

local function useCatalogResultListNavigationViewModel(data)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v5 = useNavigation()
	local theme = useStyle().Theme

	local fromSearch = data.fromSearch
	local items = if data.searchInCatalog then data.searchInCatalog.items or nil else nil
	local v6 = data.focusedWidget and data.focusedWidget.active and true or false

	local flag = true
	local v7, v8

	if data.hidePillBar then
		v7 = false
		v8 = false
	else
		v8 = fromSearch
		v7 = v8
	end

	if data.hideTopBar then
		flag = false
		v7 = false
		v8 = false
	end

	local routeName = v5.state.routeName
	local searchKeyword

	if routeName == avatarScreen.CatalogSearch then
		searchKeyword = (v5.getParam("searchParams") or {}).searchKeyword
	end

	local v9 = if flag then ref else nil
	local disableFilters = nil
	local v10

	if fFlagAXCatalogCategoriesSDUI and not fFlagAXMigrateAllTabToSduiDev then
		v10 = useSignalState(module4.getCatalogCategoriesStore().getCategories)
	end

	local v11

	if fromSearch then
		v11 = module4.getCatalogSearchSelectionStore()
	else
		v11 = module4.getCatalogSelectionStore()
	end

	local v12 = useSignalState(v11.selectedCategoryId)
	local v13 = useSignalState(v11.selectedSubcategoryId)

	if fFlagAXCatalogSupportDisableFilters then
		disableFilters = useSignalState(v11.selectedCategoryInfo).DisableFilters
	end

	local v14

	if fFlagAXMigrateAllTabToSduiDev then
		local v15 = useDispatch()
		local v16 = useStore()
		local axAnalytics = data.axAnalytics
		local ref3 = React.useRef(`{v12}:{v13}`)
		React.useEffect(function()
			if ref3.current == `{v12}:{v13}` then
				return
			end

			ref3.current = `{v12}:{v13}`

			if v16:getState().AvatarExperience.Common.FullView[routeName] == fullView.SceneFullView then
				v15(module6(axAnalytics, routeName))
			end
		end, { v12, v13, v16, axAnalytics, v15 })

		v14 = React.useMemo(function()
			return {
				activeCategoryId = v11.selectedCategoryId,
				activeSubcategoryId = v11.selectedSubcategoryId
			}
		end, { v11 })

		React.useEffect(function()
			local v17 = module5.publishActiveStore(v11)
			return function()
				module5.releaseActiveStore(v17)
			end
		end, { v11 })

		local ref4 = React.useRef(`{v12}:{v13}`)
		local onCategoryOrSubcategoryChangeById = data.onCategoryOrSubcategoryChangeById
		React.useEffect(function()
			local formatted = `{v12}:{v13}`

			if ref4.current == formatted then
				return
			end

			ref4.current = formatted

			if onCategoryOrSubcategoryChangeById and v12 then
				onCategoryOrSubcategoryChangeById(v12, v13)
			end
		end, { v12, v13, onCategoryOrSubcategoryChangeById })
	end

	if fFlagAXSduiProcessCatalogDeepLink then
		module9()
	end

	local v15

	if fFlagAXMigrateAllTabToSduiDev and fFlagAXCatalogSduiSingleRetryButtonOnError then
		v15 = module8()
	end

	local v16

	if module7() or fFlagAXMoveCatalogFilterToL1Navigation then
		v16 = module3.CatalogMainNavHeight
	else
		v16 = module3.MainNavHeight
	end

	local v18 = if fFlagAXCatalogSearchSupportDisableFilters then not disableFilters else nil
	local v21 = {}
	v21.backgroundTransparency = theme.BackgroundDefault.Transparency or 1
	v21.backgroundColor = theme.BackgroundDefault.Color
	v21.restorePreviousChildFocus = data.restorePreviousChildFocus
	v21.topPanelRef = data.topPanelRef
	v21.defaultChildRef = if flag then ref else ref2
	local v22 = if data.hasEntries then data.gridRef else nil
	v21.nextSelectionDown = v22
	v21.updateHeightBinding = data.updateHeightBinding

	v21.showNavBar = flag
	v21.showTopics = v8
	v21.showFilterButtonLayout = v7 and not (v8 or fFlagAXMoveCatalogFilterToL1Navigation)
	v21.focusedWidgetActive = v6

	v21.catalogAnalytics = data.catalogAnalytics
	v21.axAnalytics = data.axAnalytics
	v21.navHeightMain = v16
	v21.navBarRef = ref
	v21.navBarNextSelectionDown = if v8 then ref2 else nil
	v21.backToTopSignal = data.backToTopSignal
	v21.fromSearch = fromSearch
	v21.onCategoryOrSubcategoryChange = data.onCategoryOrSubcategoryChange
	v21.onCategoryOrSubcategoryChangeById = data.onCategoryOrSubcategoryChangeById
	v21.selectedCategoryId = v12
	v21.selectedSubcategoryId = v13

	if not fFlagAXCatalogCategoriesSDUI then
		v10 = nil
	end

	v21.categories = v10

	v21.pillBarRef = ref2
	v21.pillBarNextSelectionUp = v9
	v21.topicBarItems = items
	v21.searchKeyword = searchKeyword
	v21.showTopicBarFilterButton = v18

	v21.filterButtonLayoutShowFilterButton = not fFlagAXCatalogSupportDisableFilters or not disableFilters
	v21.filterButtonLayoutNextSelectionUp = v9

	v21.focusedWidgetTitle = data.focusedWidget.title
	v21.focusedWidgetLocalizedTitle = data.focusedWidget.localizedTitle
	v21.focusedWidgetLocalizedTooltip = data.focusedWidget.localizedTooltip
	v21.showCloseIcon = data.showCloseIcon
	v21.searchUuid = data.searchUuid
	v21.onCloseFocusedWidget = data.onCloseFocusedWidget
	v21.pageIdentifier = if fFlagAXMigrateAllTabToSduiDev then routeName else nil
	v21.context = fFlagAXMigrateAllTabToSduiDev and "catalog-tab:recommended" or nil
	v21.catalogSelectionReader = v14
	local v25 = if fFlagAXMigrateAllTabToSduiDev and fFlagAXCatalogSduiSingleRetryButtonOnError then not v15 else nil
	v21.shouldDisplayCategoryMenuError = v25
	return v21
end

return useCatalogResultListNavigationViewModel
