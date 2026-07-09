local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local Cryo = require(SocialCarouselParent.Cryo)
local React = require(SocialCarouselParent.React)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local NavigationRodux = require(SocialCarouselParent.NavigationRodux)
local RobloxAppEnums = require(SocialCarouselParent.RobloxAppEnums)
local Navigation = require(SocialCarouselParent.Navigation)
local SocialStopwatch = require(SocialCarouselParent.SocialStopwatch)
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local AddFriendsTile = require(script.Parent.AddFriendsTile)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Constants = require(SocialCarousel.Common.Constants)
local useNewFriendRequestsCount = require(SocialCarousel.Hooks.useNewFriendRequestsCount)
local FFlagCreateConnectionsHub = require(SocialCarouselParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagAddFriendsTileLoadFromHomeCarouselAnalytics = require(SocialCarouselParent.SharedFlags).FFlagAddFriendsTileLoadFromHomeCarouselAnalytics
local FFlagSignalsNavP3Dispatch = require(SocialCarouselParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v22 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialCarouselParent.RobloxAppNavigation).NavigationCommands

local function AddFriendsTileContainer(t1: {[any]: any}) -- line: 33
	-- upvalues: useNavigation (copy), useDispatch (copy), useSocialCarouselAnalytics (copy), useSocialCarouselContext (copy), useNewFriendRequestsCount (copy), React (copy), FFlagAddFriendsTileLoadFromHomeCarouselAnalytics (copy), SocialStopwatch (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), NavigateDown (copy), Constants (copy), AddFriendsTile (copy), Cryo (copy)
	local v25 = useNavigation()
	local v26 = useDispatch()
	local v27 = useSocialCarouselAnalytics()
	local v28 = useSocialCarouselContext()
	local v29 = useNewFriendRequestsCount()
	local v30 = React.useCallback(function() -- line: 39
		-- upvalues: v27 (copy), t1 (copy), FFlagAddFriendsTileLoadFromHomeCarouselAnalytics (copy), SocialStopwatch (copy), FFlagCreateConnectionsHub (copy), v25 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v22 (copy), v26 (copy), NavigateDown (copy)
		v27.addFriendsPressed(t1.index)

		if FFlagAddFriendsTileLoadFromHomeCarouselAnalytics then
			SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.AFPUserTileLoadFromHomeCarousel)
		end

		if FFlagCreateConnectionsHub then
			v25.navigate(AppPage.CoHubAddConnections)

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v22.down(v22.fromLegacyPage({
				name = AppPage.AddFriendsPage
			}))

			return
		end

		v26(NavigateDown({
			name = AppPage.AddFriendsPage
		}))
	end, {
		v26,
		v25
	})

	React.useEffect(function() -- line: 53
		-- upvalues: v28 (copy), Constants (copy)
		v28.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.ADD_FRIENDS)
	end, {})

	return React.createElement(AddFriendsTile, Cryo.Dictionary.join(t1, {
		onActivated = v30,
		badge = v29
	}))
end

return AddFriendsTileContainer
