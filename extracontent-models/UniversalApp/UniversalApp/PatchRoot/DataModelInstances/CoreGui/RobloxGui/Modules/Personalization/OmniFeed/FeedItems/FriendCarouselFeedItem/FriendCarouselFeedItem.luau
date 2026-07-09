local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local t = require(CorePackages.Packages.t)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local OmniFeedProps = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.Personalization.OmniFeed.OmniFeedProps
local NavigateDownTo3DQRCodePage = require(Modules.LuaApp.Thunks.NavigateDownTo3DQRCodePage)
local SocialCarousel = require(CorePackages.Workspace.Packages.SocialCarousel)
local Constants = SocialCarousel.Constants
local FFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local FFlagLuaAppAddSortDataToSocialCarouselClicks = SharedFlags.FFlagLuaAppAddSortDataToSocialCarouselClicks
local FFlagFlyoutHideFriendsHeader = SocialCarousel.Flags.FFlagFlyoutHideFriendsHeader
local FFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local FFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local FlyoutSidePanelIXP = require(CorePackages.Workspace.Packages.SharedExperimentDefinition).FlyoutSidePanelIXP
local v19 = t.strictInterface({
	[OmniFeedProps.key] = OmniFeedProps.interface,
	topic = t.optional(t.string),
	topicId = t.optional(t.string),
	formFactor = t.string,
	refresh = t.callback,
	selectionOrderBase = t.optional(t.number),
	useGridPageLayout = t.optional(t.boolean),
	networking = t.any,
	uiModeInfo = t.any
})

return function(t1: {[any]: any}) -- line: 51
	-- upvalues: v19 (copy), FFlagSocialCarouselShareQREnabled (copy), useDispatch (copy), React (copy), NavigateDownTo3DQRCodePage (copy), FFlagLuaAppCompositionAlways (copy), OmniFeedProps (copy), FFlagLuaAppAddSortDataToSocialCarouselClicks (copy), AppPage (copy), Roact (copy), SocialCarousel (copy), Constants (copy), FFlagFlyoutHideFriendsHeader (copy), FFlagEnableFlyoutFriendsHeaderFix (copy), FlyoutSidePanelIXP (copy)
	v19(t1)

	local v21 = if not FFlagSocialCarouselShareQREnabled then nil else useDispatch()
	local v22 = if not FFlagSocialCarouselShareQREnabled then nil else React.useCallback(function(p1) -- line: 56
		-- upvalues: v21 (copy), NavigateDownTo3DQRCodePage (copy)
		v21(NavigateDownTo3DQRCodePage(p1))
	end, { v21 })
	local v23 = not not FFlagLuaAppCompositionAlways or t1[OmniFeedProps.key].appCompositionEnabled
	local v24 = t1[OmniFeedProps.key].selectionOrderBase or 0
	local v25 = nil
	local u26 = nil
	local u27 = nil

	if FFlagLuaAppAddSortDataToSocialCarouselClicks then
		u26 = t1[OmniFeedProps.key] and t1[OmniFeedProps.key].appPage or AppPage.Home
		u27 = t1[OmniFeedProps.key] and t1[OmniFeedProps.key].feedItemPosition or nil

		local v28 = t1[OmniFeedProps.key] and t1[OmniFeedProps.key].feedItemStartRow or nil

		v25 = React.useMemo(function() -- line: 75
			-- upvalues: u27 (ref), u26 (ref), t1 (copy), v28 (copy)
			return {
				sortIndex = u27 or -1,
				appPage = u26,
				sortId = t1.topicId,
				startRow = v28 or -1
			}
		end, {
			u27,
			u26,
			t1.topicId,
			v28
		})
	end

	return Roact.createElement(SocialCarousel.Entry, {
		unifiedLogging = {
			impressionTag = "HomeFriendCarousel",
			sortIndex = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then t1[OmniFeedProps.key].feedItemPosition else u27,
			appPage = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then t1[OmniFeedProps.key].appPage else u26,
			sortId = t1.topicId,
			scrollViewPositionChangedSignal = t1[OmniFeedProps.key].scrollViewPositionChangedSignal
		},
		sortAnalyticsData = if not FFlagLuaAppAddSortDataToSocialCarouselClicks then nil else v25,
		refreshSignal = t1[OmniFeedProps.key].refreshSignal,
		selectionOrderBase = v24,
		source = Constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
		hideCarouselHeader = FFlagFlyoutHideFriendsHeader and not not (if not FFlagEnableFlyoutFriendsHeaderFix then FlyoutSidePanelIXP.isFlyoutSidePanelEnabled() else FlyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()) or nil,
		appCompositionEnabled = v23,
		navigateToQRCodePage = if not FFlagSocialCarouselShareQREnabled then nil else v22
	})
end
