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
local FFlagSignalsNavP3Dispatch = require(SocialCarouselParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialCarouselParent.RobloxAppNavigation).NavigationCommands

local function AddFriendsTileContainer(t1: {[any]: any}) -- line: 31
	-- upvalues: useNavigation (copy), useDispatch (copy), useSocialCarouselAnalytics (copy), useSocialCarouselContext (copy), useNewFriendRequestsCount (copy), React (copy), SocialStopwatch (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy), Constants (copy), AddFriendsTile (copy), Cryo (copy)
	local v24 = useNavigation()
	local v25 = useDispatch()
	local v26 = useSocialCarouselAnalytics()
	local v27 = useSocialCarouselContext()
	local v28 = useNewFriendRequestsCount()
	local v29 = React.useCallback(function() -- line: 37
		-- upvalues: v26 (copy), t1 (copy), SocialStopwatch (copy), FFlagCreateConnectionsHub (copy), v24 (copy), AppPage (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), v25 (copy), NavigateDown (copy)
		v26.addFriendsPressed(t1.index)
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.AFPUserTileLoadFromHomeCarousel)

		if FFlagCreateConnectionsHub then
			v24.navigate(AppPage.CoHubAddConnections)

			return
		end

		if FFlagSignalsNavP3Dispatch then
			v21.down(v21.fromLegacyPage({
				name = AppPage.AddFriendsPage
			}))

			return
		end

		v25(NavigateDown({
			name = AppPage.AddFriendsPage
		}))
	end, {
		v25,
		v24
	})

	React.useEffect(function() -- line: 49
		-- upvalues: v27 (copy), Constants (copy)
		v27.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.ADD_FRIENDS)
	end, {})

	return React.createElement(AddFriendsTile, Cryo.Dictionary.join(t1, {
		onActivated = v29,
		badge = v28
	}))
end

return AddFriendsTileContainer
