local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local module = require("@luauforge/deferred/gNu")

local fFlagAXShowFaeUpsell = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXShowFaeUpsell

local module2 = require("@luauforge/deferred/gNv")
local getFaeFeatureAccessStore = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog").Stores.GetFaeFeatureAccessStore

local module3 = require("@luauforge/deferred/gOe")
local module4 = require("@luauforge/deferred/gOj")

local module5 = require("@luauforge/deferred/gqM")

local module6 = require("@luauforge/deferred/gOk")

local module7 = require("@luauforge/deferred/gOm")
local module8 = require("@luauforge/bundled/dMx")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module9 = require("@luauforge/bundled/dTM")
local module10 = require("@luauforge/bundled/fvF")
local defineFastInt = game:DefineFastInt("AXTopLevelCountersThrottleInterval", 800)
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious

local function trackTopLevelCounters(avatarRoute, p2)
	local name = avatarRoute.current.name
	local counter = module8.Counter
	local v6 = ({
		[avatarScreen.Catalog] = counter.CatalogView,
		[avatarScreen.CatalogSearch] = counter.SearchView,
		[avatarScreen.AvatarEditor] = counter.EditorView,
		[avatarScreen.ItemDetails] = function()
			return module9.isWithinViewContext(avatarRoute, avatarScreen.CatalogSearch)
				and counter.SearchItemDetailsView
				or counter.CatalogItemDetailsView
		end,
		[avatarScreen.SortAndFilters] = function()
			return module9.isWithinViewContext(avatarRoute, avatarScreen.CatalogSearch)
				and counter.SearchFiltersView
				or counter.CatalogFiltersView
		end,
		[avatarScreen.CatalogSearchLanding] = counter.SearchLandingView
	})[name] or counter.OthersView

	if type(v6) == "function" then
		v6 = v6()
	end

	p2.sendAXCounter(v6)
	p2.sendAXCounterV2(counter.TopLevelViews, { Page = v6 })
end

local function AvatarExperienceAlwaysMounted(p2)
	local avatarRoute = p2.avatarRoute
	local navigation = p2.navigation

	module(avatarRoute)

	module2()

	if fFlagAXShowFaeUpsell then
		getFaeFeatureAccessStore.useFaeFeatureAccess()
	end

	local v5 = useRoactService(module10)

	local ref = React.useRef(0)
	local v6 = usePrevious(avatarRoute)

	React.useEffect(function()
		local name = avatarRoute.current.name

		if (v6 and v6.current.name or nil) ~= name then
			local v7 = os.clock() * 1000

			if v7 and ref and ref.current and defineFastInt <= v7 - ref.current then
				trackTopLevelCounters(avatarRoute, v5)
				ref.current = v7
			end
		end
	end, { v6, avatarRoute, v5 })

	return Roact.createFragment({
		BackButtonHandler = Roact.createElement(module3, { navigation = navigation }),
		ExternalNavigationHandler = Roact.createElement(module5, {
			navigation = navigation
		}),
		AvatarExperienceTransitionManager = Roact.createElement(module6, {
			navigation = navigation
		}),
		AvatarRouteUpdater = Roact.createElement(module4, { avatarRoute = avatarRoute }),
		LayeredClothingSortHandler = Roact.createElement(module7, {
			avatarRoute = avatarRoute
		})
	})
end

return AvatarExperienceAlwaysMounted
