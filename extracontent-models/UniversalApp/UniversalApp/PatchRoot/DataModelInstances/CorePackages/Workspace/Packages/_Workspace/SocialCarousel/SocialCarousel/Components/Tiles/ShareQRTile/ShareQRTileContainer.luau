local SocialCarousel = script:FindFirstAncestor("SocialCarousel")
local SocialCarouselParent = SocialCarousel.Parent
local Cryo = require(SocialCarouselParent.Cryo)
local React = require(SocialCarouselParent.React)
local RoactUtils = require(SocialCarouselParent.RoactUtils)
local NavigationRodux = require(SocialCarouselParent.NavigationRodux)
local RobloxAppEnums = require(SocialCarouselParent.RobloxAppEnums)
local Navigation = require(SocialCarouselParent.Navigation)
local AppPage = RobloxAppEnums.AppPage
local NavigateDown = NavigationRodux.Thunks.NavigateDown
local NavigateBack = NavigationRodux.Thunks.NavigateBack
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useNavigation = Navigation.useNavigation
local ShareQRTile = require(script.Parent.ShareQRTile)
local useSocialCarouselAnalytics = require(SocialCarousel.Analytics.useSocialCarouselAnalytics)
local useSocialCarouselContext = require(SocialCarousel.Contexts.useSocialCarouselContext)
local Constants = require(SocialCarousel.Common.Constants)
local FFlagSocialCarouselShareQRBackToAddFriends = require(SocialCarouselParent.SharedFlags).FFlagSocialCarouselShareQRBackToAddFriends
local FFlagCreateConnectionsHub = require(SocialCarouselParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagSignalsNavP3Dispatch = require(SocialCarouselParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(SocialCarouselParent.RobloxAppNavigation).NavigationCommands

local function ShareQRTileContainer(t1: {[any]: any}) -- line: 32
	-- upvalues: useNavigation (copy), useDispatch (copy), useSocialCarouselAnalytics (copy), useSocialCarouselContext (copy), React (copy), FFlagSocialCarouselShareQRBackToAddFriends (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateBack (copy), FFlagCreateConnectionsHub (copy), AppPage (copy), NavigateDown (copy), Constants (copy), ShareQRTile (copy), Cryo (copy)
	local v24 = useNavigation()
	local v25 = useDispatch()
	local v26 = useSocialCarouselAnalytics()
	local v27 = useSocialCarouselContext()
	local v28 = React.useCallback(function() -- line: 39
		-- upvalues: v26 (copy), t1 (copy), FFlagSocialCarouselShareQRBackToAddFriends (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), v25 (copy), NavigateBack (copy), FFlagCreateConnectionsHub (copy), v24 (copy), AppPage (copy), NavigateDown (copy), v27 (copy), Constants (copy)
		v26.shareQRPressed(t1.index)

		local v29 = nil

		if FFlagSocialCarouselShareQRBackToAddFriends then
			function v29() -- line: 43
				-- upvalues: FFlagSignalsNavP3Dispatch (copy), v21 (copy), v25 (copy), NavigateBack (copy), FFlagCreateConnectionsHub (copy), v24 (copy), AppPage (copy), NavigateDown (copy)
				if FFlagSignalsNavP3Dispatch then
					v21.back(true)
				else
					v25(NavigateBack(true))
				end

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
			end
		end

		if v27.navigateToQRCodePage then
			v27.navigateToQRCodePage({
				source = Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
				onClose = v29
			})
		end
	end, {
		v25,
		v24,
		t1.index,
		v26.shareQRPressed,
		v27.navigateToQRCodePage
	})

	React.useEffect(function() -- line: 76
		-- upvalues: v27 (copy), Constants (copy)
		v27.onSuccessfulRender(Constants.ANALYTICS.UI_LOADING_EVENTS.SHARE_QR)
	end, {})

	return React.createElement(ShareQRTile, Cryo.Dictionary.join(t1, {
		onActivated = v28
	}))
end

return ShareQRTileContainer
