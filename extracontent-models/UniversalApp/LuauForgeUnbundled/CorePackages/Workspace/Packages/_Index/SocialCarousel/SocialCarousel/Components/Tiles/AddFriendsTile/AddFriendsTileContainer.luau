local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/NavigationRodux")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation")
local SocialStopwatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SocialStopwatch")

local appPage = RobloxAppEnums.AppPage
local navigateDown = NavigationRodux.Thunks.NavigateDown
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local AddFriendsTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/AddFriendsTile/AddFriendsTile")
local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")
local useNewFriendRequestsCount = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Hooks/useNewFriendRequestsCount")

local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagCreateConnectionsHub
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppNavigation").NavigationCommands else nil

local function AddFriendsTileContainer(p2)
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = useSocialCarouselAnalytics()
	local v8 = useSocialCarouselContext()
	local v9 = useNewFriendRequestsCount()
	local v10 = React.useCallback(function()
		v7.addFriendsPressed(p2.index)
		SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.AFPUserTileLoadFromHomeCarousel)

		if fFlagCreateConnectionsHub then
			v5.navigate(appPage.CoHubAddConnections)
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage({
				name = appPage.AddFriendsPage
			}))
		else
			v6(navigateDown({ name = appPage.AddFriendsPage }))
		end
	end, { v6, v5 })

	React.useEffect(function()
		v8.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.ADD_FRIENDS)
	end, {})

	return React.createElement(AddFriendsTile, Cryo.Dictionary.join(p2, {
		onActivated = v10,
		badge = v9
	}))
end

return AddFriendsTileContainer
