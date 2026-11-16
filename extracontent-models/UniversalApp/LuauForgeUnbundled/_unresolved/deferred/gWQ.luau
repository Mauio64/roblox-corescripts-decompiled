local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local module = require("@luauforge/bundled/fpM")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local AvatarExperienceAnalytics = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module4 = require("@luauforge/bundled/eda")
local module5 = require("@luauforge/bundled/dYT")
local module6 = require("@luauforge/bundled/fvF")

local module7 = require("@luauforge/bundled/fpG")
local module8 = require("@luauforge/deferred/gWR")
local module9 = require("@luauforge/bundled/fvZ")
local module10 = require("@luauforge/bundled/gnZ")

local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local module11 = require("@luauforge/bundled/eeH")
local module12 = require("@luauforge/deferred/gfz")
local module13 = require("@luauforge/deferred/gWS")

local module14 = require("@luauforge/bundled/gfm")

local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums")
local fullView = AvatarExperienceCommon.Enums.FullView
require("@luauforge/bundled/dTN")
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode

local module16 = require("@luauforge/bundled/dTM")
local searchUuid = require("@luauforge/bundled/dOk").SearchUuid
local getAvatarEventCounterNameWithPlatform = AvatarExperienceAnalytics.getAvatarEventCounterNameWithPlatform
local module17 = require("@luauforge/bundled/dRQ")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local module18 = require("@luauforge/bundled/fpx")
local module19 = require("@luauforge/bundled/fpw")

local focusable = RoactGamepad.Focusable
local module20 = require("@luauforge/deferred/goQ")
local searchLandingPage = module.Features.SearchLandingPage
local useSearchLandingPageProps = module.Features.useSearchLandingPageProps

local module21 = require("@luauforge/deferred/gmV")

local module22 = require("@luauforge/deferred/gfb")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local module23 = require("@luauforge/deferred/gpb")

return (module22((module21(function(p2)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)

	local v5 = useDispatch()
	local v6 = if axRecentlyViewedSearchItemsIXPTest.isEnabled() then module11(module6) else nil

	local v7 = module11(module4)
	local v8 = module11(module5)
	local v9 = module12()
	local v10 = module13()

	local v11 = useSelector(function(p3)
		return p3.AvatarExperience.AvatarAutocompleteSuggestions
	end, getUseSelectorDeepEquals())
	local v12 = useSelector(function(p3)
		return p3.TopBar.statusBarHeight
	end, getUseSelectorDeepEquals())
	local v13 = useSelector(function(p3)
		return p3.DeviceOrientation
	end, getUseSelectorDeepEquals())
	local v14 = useSelector(module14, getUseSelectorDeepEquals())
	local v15

	if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		v15 = React.useCallback(function(p3, p4)
			v5(module8(v7, p3, p4))
		end, { v7, v5 })
	end

	local v16 = React.useCallback(function(p3)
		v5(module7.Fetch(v7, p3, nil, RobloxAppEnums.SearchTypes.Catalog))
	end, { v7, v5, v11 })

	local v17 = React.useCallback(function(p3)
		v5(module19(p3, RobloxAppEnums.SearchTypes.Catalog))
	end, { v5 })

	local v18 = React.useCallback(function(p3, p4)
		v5(module18(p3, p4))
	end, { v5 })

	local v19 = React.useCallback(function()
		v5(module10(v8, avatarScreen.CatalogSearch, fullView.UIFullView))
	end, { v5, v8 })

	local v20 = React.useCallback(function(p3, p4)
		module16.navigateToSearch(p2.navigation, p3, p4)
	end, { p2.navigation })
	local v21

	if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		v21 = React.useCallback(function(p3)
			local id = p3.id
			local itemType = p3.itemType
			v5(module9(
				v7,
				v8,
				itemType,
				module17.GetItemSubType(itemType, p3),
				id,
				true,
				p2.avatarRoute,
				p2.navigation
			))
		end, { v7, v8, p2.avatarRoute, p2.navigation, v5 })
	end

	local v22 = React.useCallback(function(p3, p4)
		local avatarEventCounterNameWithPlatform = getAvatarEventCounterNameWithPlatform(p3)
		v8.Diag:reportStats(avatarEventCounterNameWithPlatform, p4)
	end, { v8 })

	local createElement = React.createElement
	local frame = focusable.Frame
	local v23 = {
		defaultChild = ref,
		restorePreviousChildFocus = true,
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}

	local createElement2 = React.createElement
	local v26 = {
		defaultChildRef = ref,
		avatarRoute = p2.avatarRoute,
		allowAdaptiveScrolling = false,
		isSceneFullView = false,
		isUIFullView = v13 == deviceOrientationMode.Portrait,
		NextSelectionDown = ref,
		showMultiTryOnBottomBar = not v14,
		showRobuxBalance = if module23 then not v14 else nil
	}

	local createElement3 = React.createElement

	local v31 = {
		navigation = p2.navigation,
		statusBarHeight = v12,
		deviceOrientation = v13,
		autocompleteState = v11,
		navigateToSearch = v20,
		fetchAutocompleteSuggestions = v16,
		fetchSearchRecentlyViewed = 0,
		createSearchUuid = 0,
		setSearchType = 0,
		setSearchParameters = 0,
		setFullView = 0,
		toggleTryOn = 0,
		searchBarRef = 0,
		firstSuggestedItemRef = 0,
		sendStats = 0,
		sendCounter = 0,
		searchTelemetry = 0,
		catalogAnalytics = 0
	}

	if not axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		v15 = nil
	end

	v31.fetchSearchRecentlyViewed = v15

	v31.createSearchUuid = searchUuid
	v31.setSearchType = v17
	v31.setSearchParameters = v18
	v31.setFullView = v19

	if not axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		v21 = nil
	end

	v31.toggleTryOn = v21

	v31.searchBarRef = ref
	v31.firstSuggestedItemRef = ref2

	v31.sendStats = v22
	v31.sendCounter = v9
	v31.searchTelemetry = v10

	if not axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		v6 = nil
	end

	v31.catalogAnalytics = v6
	return createElement(frame, v23, {
		AvatarExperienceView = createElement2(module20, v26, {
			SearchLandingPage = createElement3(searchLandingPage, useSearchLandingPageProps(v31))
		})
	})
end))))
