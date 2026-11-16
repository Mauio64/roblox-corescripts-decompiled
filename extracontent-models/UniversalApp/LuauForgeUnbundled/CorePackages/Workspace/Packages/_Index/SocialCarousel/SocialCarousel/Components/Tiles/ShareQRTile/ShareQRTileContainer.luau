local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/React")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RoactUtils")
local NavigationRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/NavigationRodux")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppEnums")
local Navigation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/Navigation")

local appPage = RobloxAppEnums.AppPage
local navigateDown = NavigationRodux.Thunks.NavigateDown
local navigateBack = NavigationRodux.Thunks.NavigateBack
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local ShareQRTile = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Components/Tiles/ShareQRTile/ShareQRTile")
local useSocialCarouselAnalytics = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Analytics/useSocialCarouselAnalytics")
local useSocialCarouselContext = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Contexts/useSocialCarouselContext")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/SocialCarousel/SocialCarousel/Common/Constants")

local fFlagSocialCarouselShareQRBackToAddFriends = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSocialCarouselShareQRBackToAddFriends
local fFlagCreateConnectionsHub = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagCreateConnectionsHub
local fFlagSignalsNavP3Dispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/SharedFlags").FFlagSignalsNavP3Dispatch

local navigationCommands = if fFlagSignalsNavP3Dispatch then require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCarousel/RobloxAppNavigation").NavigationCommands else nil

local function ShareQRTileContainer(p2)
	local v5 = useNavigation()
	local v6 = useDispatch()
	local v7 = useSocialCarouselAnalytics()
	local v8 = useSocialCarouselContext()

	local v9 = React.useCallback(function()
		v7.shareQRPressed(p2.index)

		local fn = fFlagSocialCarouselShareQRBackToAddFriends and function()
			if fFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
			else
				v6(navigateBack(true))
			end

			if fFlagCreateConnectionsHub then
				v5.navigate(appPage.CoHubAddConnections)
			elseif fFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage({
					name = appPage.AddFriendsPage
				}))
			else
				v6(navigateDown({ name = appPage.AddFriendsPage }))
			end
		end or nil

		if v8.navigateToQRCodePage then
			v8.navigateToQRCodePage({
				source = Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
				onClose = fn
			})
		end
	end, { v6, v5, p2.index, v7.shareQRPressed, v8.navigateToQRCodePage })

	React.useEffect(function()
		v8.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.SHARE_QR)
	end, {})

	return React.createElement(ShareQRTile, Cryo.Dictionary.join(p2, {
		onActivated = v9
	}))
end

return ShareQRTileContainer
