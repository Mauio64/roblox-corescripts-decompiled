local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local parent = SocialCarousel.Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local NavigationRodux = require(parent.NavigationRodux)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local Navigation = require(parent.Navigation)

local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local ShareQRTile = require(script.Parent.ShareQRTile)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Constants = require(SocialCarousel.Common.Constants)

local SharedFlags = require(parent.SharedFlags)
local FFlagSocialCarouselShareQRBackToAddFriends = SharedFlags.FFlagSocialCarouselShareQRBackToAddFriends
local SharedFlags2 = require(parent.SharedFlags)
local FFlagCreateConnectionsHub = SharedFlags2.FFlagCreateConnectionsHub
local SharedFlags3 = require(parent.SharedFlags)
local FFlagSignalsNavP3Dispatch = SharedFlags3.FFlagSignalsNavP3Dispatch
local navigationCommands

if FFlagSignalsNavP3Dispatch then
	local RobloxAppNavigation = require(parent.RobloxAppNavigation)
	navigationCommands = RobloxAppNavigation.NavigationCommands
else
	navigationCommands = nil
end

local function ShareQRTileContainer(p)
	local v = useNavigation()
	local v2 = useDispatch()
	local v3 = useSocialCarouselAnalytics()
	local v4 = useSocialCarouselContext()

	local onActivated = React.useCallback(function()
		v3.shareQRPressed(p.index)

		local fn = FFlagSocialCarouselShareQRBackToAddFriends and function()
			if FFlagSignalsNavP3Dispatch then
				navigationCommands.back(true)
			else
				v2(NavigateBack(true))
			end

			if FFlagCreateConnectionsHub then
				v.navigate(AppPage.CoHubAddConnections)
			elseif FFlagSignalsNavP3Dispatch then
				navigationCommands.down(navigationCommands.fromLegacyPage({
					name = AppPage.AddFriendsPage
				}))
			else
				v2(NavigateDown({ name = AppPage.AddFriendsPage }))
			end
		end or nil

		if v4.navigateToQRCodePage then
			v4.navigateToQRCodePage({
				source = Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
				onClose = fn
			})
		end
	end, { v2, v, p.index, v3.shareQRPressed, v4.navigateToQRCodePage })

	React.useEffect(function()
		v4.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.SHARE_QR)
	end, {})

	return React.createElement(ShareQRTile, Cryo.Dictionary.join(p, { onActivated = onActivated }))
end

return ShareQRTileContainer
