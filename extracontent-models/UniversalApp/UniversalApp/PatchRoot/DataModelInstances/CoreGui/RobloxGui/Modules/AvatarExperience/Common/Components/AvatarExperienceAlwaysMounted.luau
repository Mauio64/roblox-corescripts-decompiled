local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local useRouteSessionManager = require(Modules.AvatarExperience.Catalog.Hooks.useRouteSessionManager)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXMarketplaceSubscriptionRefetchListener = AvatarExperienceFlags.FFlagAXMarketplaceSubscriptionRefetchListener
local FFlagAXShowFaeUpsell = AvatarExperienceFlags.FFlagAXShowFaeUpsell
local useRefetchMarketplaceOnSubscriptionChange = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useRefetchMarketplaceOnSubscriptionChange)
local GetFaeFeatureAccessStore = require(Modules.AvatarExperience.Catalog.Stores.GetFaeFeatureAccessStore)
local BackButtonHandler = require(Modules.AvatarExperience.Common.Components.RoactNavigation.BackButtonHandler)
local AvatarRouteUpdater = require(Modules.AvatarExperience.Common.Components.AvatarRouteUpdater)
local ExternalNavigationHandler = require(Modules.AvatarExperience.Common.Components.RoactNavigation.ExternalNavigationHandler)
local AvatarExperienceTransitionManager = require(Modules.AvatarExperience.Common.Components.AvatarExperienceTransitionManager)
local LayeredClothingSortHandler = require(Modules.AvatarExperience.LayeredClothingSort.Components.LayeredClothingSortHandler)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)
local v22 = game:DefineFastInt("AXTopLevelCountersThrottleInterval", 800)
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious

local function trackTopLevelCounters(p1, p2) -- line: 50
	-- upvalues: Constants (copy), AvatarScreen (copy), NavigationUtils (copy)
	local name = p1.current.name
	local Counter = Constants.Counter
	local v30 = ({
		[AvatarScreen.Catalog] = Counter.CatalogView,
		[AvatarScreen.CatalogSearch] = Counter.SearchView,
		[AvatarScreen.AvatarEditor] = Counter.EditorView,
		[AvatarScreen.ItemDetails] = function() -- line: 57
			-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy), Counter (copy)
			return NavigationUtils.isWithinViewContext(p1, AvatarScreen.CatalogSearch) and Counter.SearchItemDetailsView or Counter.CatalogItemDetailsView
		end,
		[AvatarScreen.SortAndFilters] = function() -- line: 61
			-- upvalues: NavigationUtils (copy), p1 (copy), AvatarScreen (copy), Counter (copy)
			return NavigationUtils.isWithinViewContext(p1, AvatarScreen.CatalogSearch) and Counter.SearchFiltersView or Counter.CatalogFiltersView
		end,
		[AvatarScreen.CatalogSearchLanding] = Counter.SearchLandingView
	})[name] or Counter.OthersView

	if type(v30) == "function" then
		v30 = v30()
	end

	p2.sendAXCounter(v30)
	p2.sendAXCounterV2(Counter.TopLevelViews, {
		Page = v30
	})
end
local function AvatarExperienceAlwaysMounted(p3) -- line: 76
	-- upvalues: useRouteSessionManager (copy), FFlagAXMarketplaceSubscriptionRefetchListener (copy), useRefetchMarketplaceOnSubscriptionChange (copy), FFlagAXShowFaeUpsell (copy), GetFaeFeatureAccessStore (copy), useRoactService (copy), Analytics (copy), React (copy), usePrevious (copy), v22 (copy), trackTopLevelCounters (copy), Roact (copy), BackButtonHandler (copy), ExternalNavigationHandler (copy), AvatarExperienceTransitionManager (copy), AvatarRouteUpdater (copy), LayeredClothingSortHandler (copy)
	local avatarRoute = p3.avatarRoute
	local navigation = p3.navigation

	useRouteSessionManager(avatarRoute)

	if FFlagAXMarketplaceSubscriptionRefetchListener then
		useRefetchMarketplaceOnSubscriptionChange()
	end

	if FFlagAXShowFaeUpsell then
		GetFaeFeatureAccessStore.useFaeFeatureAccess()
	end

	local v34 = useRoactService(Analytics)
	local v35 = React.useRef(0)
	local v36 = usePrevious(avatarRoute)

	React.useEffect(function() -- line: 95
		-- upvalues: avatarRoute (copy), v36 (copy), v35 (copy), v22 (copy), trackTopLevelCounters (copy), v34 (copy)
		if avatarRoute.current.name ~= (v36 and v36.current.name or nil) then
			local v37 = os.clock() * 1000

			if v37 and v35 and v35.current and v37 - v35.current >= v22 then
				trackTopLevelCounters(avatarRoute, v34)
				v35.current = v37
			end
		end
	end, {
		v36,
		avatarRoute,
		v34
	})

	return Roact.createFragment({
		BackButtonHandler = Roact.createElement(BackButtonHandler, {
			navigation = navigation
		}),
		ExternalNavigationHandler = Roact.createElement(ExternalNavigationHandler, {
			navigation = navigation
		}),
		AvatarExperienceTransitionManager = Roact.createElement(AvatarExperienceTransitionManager, {
			navigation = navigation
		}),
		AvatarRouteUpdater = Roact.createElement(AvatarRouteUpdater, {
			avatarRoute = avatarRoute
		}),
		LayeredClothingSortHandler = Roact.createElement(LayeredClothingSortHandler, {
			avatarRoute = avatarRoute
		})
	})
end

return AvatarExperienceAlwaysMounted
