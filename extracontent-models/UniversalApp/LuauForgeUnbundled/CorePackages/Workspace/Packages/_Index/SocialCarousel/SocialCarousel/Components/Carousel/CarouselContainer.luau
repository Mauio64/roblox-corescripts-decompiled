local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")

local Carousel = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Carousel/Carousel")
local navigateDown = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/NavigationRodux").Thunks.NavigateDown
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation")

local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local useTilesSeenCollection = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useTilesSeenCollection")
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local appPage = RobloxAppEnums.AppPage
local useNavigation = Navigation.useNavigation
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagCreateConnectionsHub
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSignalsNavP3Dispatch
local fFlagShowRequestsInCarouselForAllUsers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagShowRequestsInCarouselForAllUsers

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppNavigation").NavigationCommands else nil

local function CarouselContainer(p2)
	local v5 = useSocialCarouselAnalytics()
	local v6 = useTilesSeenCollection()
	local v7 = useDispatch()
	local v8 = useNavigation()
	local ref = React.useRef({ startIndex = 1, endIndex = 1 })

	local v9 = React.useCallback(function()
		v5.friendsHeaderPressed()

		if fFlagCreateConnectionsHub then
			v8.navigate(appPage.CoHubMyConnections)
		elseif fFlagSignalsNavP3Dispatch then
			navigationCommands.down(navigationCommands.fromLegacyPage({
				name = appPage.ViewFriends
			}))
		else
			v7(navigateDown({ name = appPage.ViewFriends }))
		end
	end, { v7, v8 })

	local v10 = React.useCallback(function(p3, p4, p5)
		local current = ref.current

		if current.startIndex <= p4 and p4 <= current.endIndex then
			v6.addTileToCollection(p3, p4, p5)
		end
	end, { v6 })

	local createElement = React.createElement

	if fFlagShowRequestsInCarouselForAllUsers then
		v10 = nil
	end

	return createElement(Carousel, {
		onActivateHeader = v9,
		onTileContentChanged = v10,
		appCompositionEnabled = p2.appCompositionEnabled
	})
end

return CarouselContainer
