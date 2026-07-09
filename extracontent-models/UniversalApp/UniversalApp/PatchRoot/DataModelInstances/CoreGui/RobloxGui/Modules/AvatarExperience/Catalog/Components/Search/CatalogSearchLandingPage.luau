local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local AvatarExperienceSearch = require(CorePackages.Workspace.Packages.AvatarExperienceSearch)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local AvatarExperienceAnalytics = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local Common = Modules.AvatarExperience.Common
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local FetchAutocompleteSuggestion = require(Modules.LuaApp.Thunks.FetchAutocompleteSuggestion)
local FetchSearchRecentlyViewed = require(Modules.AvatarExperience.Catalog.Thunks.FetchSearchRecentlyViewed)
local ToggleTryOnThunk = require(Modules.AvatarExperience.Common.Thunks.ToggleTryOnThunk)
local SetFullView = require(Common.Thunks.SetFullView)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useSendCounter = require(Modules.AvatarExperience.Common.Hooks.useSendCounter)
local useSearchTelemetry = require(script.Parent.useSearchTelemetry)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local RobloxAppEnums = require(CorePackages.Workspace.Packages.RobloxAppEnums)
local FullView = AvatarExperienceCommon.Enums.FullView

require(Modules.AvatarExperience.Catalog.SearchTypes)

local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local wasLastInputGamepad = require(CorePackages.Workspace.Packages.RoactUtils).wasLastInputGamepad
local getAvatarEventCounterNameWithPlatform = AvatarExperienceAnalytics.getAvatarEventCounterNameWithPlatform
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local SetSearchParameters = require(Modules.LuaApp.Actions.SetSearchParameters)
local SetSearchType = require(Modules.LuaApp.Actions.SetSearchType)
local Focusable = RoactGamepad.Focusable
local AvatarExperienceView = require(Common.Components.AvatarExperienceView)
local SearchLandingPage = AvatarExperienceSearch.Features.SearchLandingPage
local useSearchLandingPageProps = AvatarExperienceSearch.Features.useSearchLandingPageProps
local GamepadFocusHandlerForPage = require(Common.Components.GamepadFocusHandlerForPage)
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local withMappedNavigationParams = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withMappedNavigationParams)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local FFlagAXMoveRobuxBalanceButtonLower = require(Modules.AvatarExperience.Flags.FFlagAXMoveRobuxBalanceButtonLower)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus

return (withMappedNavigationParams((withStackVisibilityWrapper(function(p1) -- line: 61
	-- upvalues: FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useDispatch (copy), AXRecentlyViewedSearchItemsIXPTest (copy), useRoactService (copy), Analytics (copy), RoactNetworking (copy), RoactAnalytics (copy), useSendCounter (copy), useSearchTelemetry (copy), useSelector (copy), getUseSelectorDeepEquals (copy), selectIsPortrait (copy), FetchSearchRecentlyViewed (copy), FetchAutocompleteSuggestion (copy), RobloxAppEnums (copy), SetSearchType (copy), SetSearchParameters (copy), SetFullView (copy), AvatarScreen (copy), FullView (copy), NavigationUtils (copy), CatalogUtils (copy), ToggleTryOnThunk (copy), getAvatarEventCounterNameWithPlatform (copy), Focusable (copy), AvatarExperienceView (copy), DeviceOrientationMode (copy), FFlagAXMoveRobuxBalanceButtonLower (copy), GamepadFocusHandlerForPage (copy), wasLastInputGamepad (copy), SearchLandingPage (copy), useSearchLandingPageProps (copy), SearchUuid (copy)
	local v45 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local v46 = React.useRef(nil)
	local v47 = React.useRef(nil)
	local v48 = useDispatch()
	local v49 = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else useRoactService(Analytics)
	local v50 = useRoactService(RoactNetworking)
	local v51 = useRoactService(RoactAnalytics)
	local v52 = useSendCounter()
	local v53 = useSearchTelemetry()
	local v54 = useSelector(function(p2) -- line: 78
		return p2.AvatarExperience.AvatarAutocompleteSuggestions
	end, getUseSelectorDeepEquals())
	local v55 = useSelector(function(p3) -- line: 81
		return p3.TopBar.statusBarHeight
	end, getUseSelectorDeepEquals())
	local v56 = useSelector(function(p4) -- line: 84
		return p4.DeviceOrientation
	end, getUseSelectorDeepEquals())
	local v57 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v58 = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else React.useCallback(function(s1: string, t1: {[any]: any}) -- line: 94
		-- upvalues: v48 (copy), FetchSearchRecentlyViewed (copy), v50 (copy)
		v48(FetchSearchRecentlyViewed(v50, s1, t1))
	end, {
		v50,
		v48
	})
	local v59 = React.useCallback(function(s2: string) -- line: 99
		-- upvalues: v48 (copy), FetchAutocompleteSuggestion (copy), v50 (copy), RobloxAppEnums (copy)
		v48(FetchAutocompleteSuggestion.Fetch(v50, s2, nil, RobloxAppEnums.SearchTypes.Catalog))
	end, {
		v50,
		v48,
		v54
	})
	local v60 = React.useCallback(function(s3: string) -- line: 104
		-- upvalues: v48 (copy), SetSearchType (copy), RobloxAppEnums (copy)
		v48(SetSearchType(s3, RobloxAppEnums.SearchTypes.Catalog))
	end, { v48 })
	local v61 = React.useCallback(function(s4: string, t2: {[any]: any}) -- line: 108
		-- upvalues: v48 (copy), SetSearchParameters (copy)
		v48(SetSearchParameters(s4, t2))
	end, { v48 })
	local v62 = React.useCallback(function() -- line: 112
		-- upvalues: v48 (copy), SetFullView (copy), v51 (copy), AvatarScreen (copy), FullView (copy)
		v48(SetFullView(v51, AvatarScreen.CatalogSearch, FullView.UIFullView))
	end, {
		v48,
		v51
	})
	local v63 = React.useCallback(function(s5: string, t3: {[any]: any}) -- line: 116
		-- upvalues: NavigationUtils (copy), p1 (copy)
		NavigationUtils.navigateToSearch(p1.navigation, s5, t3)
	end, { p1.navigation })
	local v64 = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else React.useCallback(function(p5) -- line: 121
		-- upvalues: CatalogUtils (copy), v48 (copy), ToggleTryOnThunk (copy), v50 (copy), v51 (copy), p1 (copy)
		local id = p5.id
		local itemType = p5.itemType
		local v80 = CatalogUtils.GetItemSubType(itemType, p5)

		v48(ToggleTryOnThunk(v50, v51, itemType, v80, id, true, p1.avatarRoute, p1.navigation))
	end, {
		v50,
		v51,
		p1.avatarRoute,
		p1.navigation,
		v48
	})
	local v65 = React.useCallback(function(s6: string, n1: number) -- line: 141
		-- upvalues: getAvatarEventCounterNameWithPlatform (copy), v51 (copy)
		local v83 = getAvatarEventCounterNameWithPlatform(s6)

		v51.Diag:reportStats(v83, n1)
	end, { v51 })

	return React.createElement(Focusable.Frame, {
		restorePreviousChildFocus = true,
		BackgroundTransparency = 1,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v45 else nil,
		defaultChild = v46,
		Size = UDim2.fromScale(1, 1)
	}, {
		AvatarExperienceView = React.createElement(AvatarExperienceView, {
			allowAdaptiveScrolling = false,
			isSceneFullView = false,
			defaultChildRef = v46,
			avatarRoute = p1.avatarRoute,
			isUIFullView = v56 == DeviceOrientationMode.Portrait,
			NextSelectionDown = v46,
			showMultiTryOnBottomBar = not v57,
			showRobuxBalance = if not FFlagAXMoveRobuxBalanceButtonLower then nil else not v57
		}, {
			GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
				captureFocusOnMount = true,
				focusController = v45,
				isGamepadInput = wasLastInputGamepad()
			}) else nil,
			SearchLandingPage = React.createElement(SearchLandingPage, useSearchLandingPageProps({
				navigation = p1.navigation,
				statusBarHeight = v55,
				deviceOrientation = v56,
				autocompleteState = v54,
				navigateToSearch = v63,
				fetchAutocompleteSuggestions = v59,
				fetchSearchRecentlyViewed = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else v58,
				createSearchUuid = SearchUuid,
				setSearchType = v60,
				setSearchParameters = v61,
				setFullView = v62,
				toggleTryOn = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else v64,
				searchBarRef = v46,
				firstSuggestedItemRef = v47,
				focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v45 else nil,
				sendStats = v65,
				sendCounter = v52,
				searchTelemetry = v53,
				catalogAnalytics = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else v49
			}))
		})
	})
end))))
