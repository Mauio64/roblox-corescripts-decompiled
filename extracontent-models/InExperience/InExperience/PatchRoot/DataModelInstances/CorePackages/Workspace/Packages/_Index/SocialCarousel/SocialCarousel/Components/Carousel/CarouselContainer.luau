local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local RoactUtils = require(parent.RoactUtils)

local Carousel = require(script.Parent.Carousel)
local NavigationRodux = require(parent.NavigationRodux)
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local Navigation = require(parent.Navigation)

local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useTilesSeenCollection = require(SocialCarousel.Analytics.useTilesSeenCollection)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local AppPage = RobloxAppEnums.AppPage
local useNavigation = Navigation.useNavigation
local SharedFlags = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local SharedFlags3 = require(parent.SharedFlags)
local FFlagShowRequestsInCarouselForAllUsers = SharedFlags3.FFlagShowRequestsInCarouselForAllUsers
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function CarouselContainer(p)
	local v = useSocialCarouselAnalytics()
	local v2 = useTilesSeenCollection()
	local v3 = useDispatch()
	local v4 = useNavigation()
	local ref = React.useRef({ startIndex = 1, endIndex = 1 })

	local onActivateHeader = React.useCallback(function()
		v.friendsHeaderPressed()

		if FFlagCreateConnectionsHub then
			v4.navigate(AppPage.CoHubMyConnections)
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage({ name = AppPage.ViewFriends }))
		else
			v3(NavigateDown({ name = AppPage.ViewFriends }))
		end
	end, { v3, v4 })

	local onTileContentChanged = React.useCallback(function(p2: string, p3: number, p4)
		local current = ref.current

		if current.startIndex <= p3 and p3 <= current.endIndex then
			v2.addTileToCollection(p2, p3, p4)
		end
	end, { v2 })

	local createElement = React.createElement

	if FFlagShowRequestsInCarouselForAllUsers then
		onTileContentChanged = nil
	end

	return createElement(Carousel, {
		onActivateHeader = onActivateHeader,
		onTileContentChanged = onTileContentChanged,
		appCompositionEnabled = p.appCompositionEnabled
	})
end

return CarouselContainer
