local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local Navigation = require(parent.Navigation)
local SocialStopwatch = require(parent.SocialStopwatch)

local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local AddFriendsTile = require(script.Parent.AddFriendsTile)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Constants = require(SocialCarousel.Common.Constants)
local useNewFriendRequestsCount = require(SocialCarousel.Hooks.useNewFriendRequestsCount)

local SharedFlags = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local SharedFlags2 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags2.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function AddFriendsTileContainer(p)
	local v = useNavigation()
	local v2 = useDispatch()
	local v3 = useSocialCarouselAnalytics()
	local v4 = useSocialCarouselContext()
	local badge = useNewFriendRequestsCount()
	local onActivated = React.useCallback(function()
		v3.addFriendsPressed(p.index)
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.AFPUserTileLoadFromHomeCarousel)

		if FFlagCreateConnectionsHub then
			v.navigate(AppPage.CoHubAddConnections)
		elseif FFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage({
				name = AppPage.AddFriendsPage
			}))
		else
			v2(NavigateDown({ name = AppPage.AddFriendsPage }))
		end
	end, { v2, v })

	React.useEffect(function()
		v4.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.ADD_FRIENDS)
	end, {})

	return React.createElement(AddFriendsTile, Cryo.Dictionary.join(p, {
		onActivated = onActivated,
		badge = badge
	}))
end

return AddFriendsTileContainer
