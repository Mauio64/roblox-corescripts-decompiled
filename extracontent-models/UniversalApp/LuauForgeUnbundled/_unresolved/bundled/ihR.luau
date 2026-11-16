local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local React = require(CorePackages.Packages.React)
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local t = require(CorePackages.Packages.t)
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local omniFeedProps = require("@luauforge/bundled/dpZ").Modules.Personalization.OmniFeed.OmniFeedProps

local module2 = require("@luauforge/bundled/eeD")
local module3 = require("@luauforge/bundled/ihS")

local constants = module3.Constants

local fFlagLuaAppCompositionAlways = SharedFlags.FFlagLuaAppCompositionAlways
local fFlagLuaAppUserSeenCollectionUnifiedFields = SharedFlags.FFlagLuaAppUserSeenCollectionUnifiedFields
local fFlagFlyoutHideFriendsHeader = module3.Flags.FFlagFlyoutHideFriendsHeader
local fFlagSocialCarouselShareQREnabled = SharedFlags.FFlagSocialCarouselShareQREnabled
local fFlagEnableFlyoutFriendsHeaderFix = SharedFlags.FFlagEnableFlyoutFriendsHeaderFix
local flyoutSidePanelIXP = require("@luauforge/bundled/dHD").FlyoutSidePanelIXP
local fFlagLuaAppFriendsSortHeaderByPosition = SharedFlags.FFlagLuaAppFriendsSortHeaderByPosition
local fFlagLuaAppHomeFriendsRemoveItemImpressions = SharedFlags.FFlagLuaAppHomeFriendsRemoveItemImpressions

local fIntLuaAppFriendsSortHeaderMaxHiddenPosition = SharedFlags.FIntLuaAppFriendsSortHeaderMaxHiddenPosition

local strictInterface = t.strictInterface
local interfaces = {
	[omniFeedProps.key] = omniFeedProps.interface,
	topic = t.optional(t.string),
	topicId = t.optional(t.string)
}
local v5 = if fFlagLuaAppFriendsSortHeaderByPosition then t.optional(t.number) else nil
interfaces.sortIndex = v5

interfaces.formFactor = t.string

interfaces.refresh = t.callback
interfaces.selectionOrderBase = t.optional(t.number)

interfaces.useGridPageLayout = t.optional(t.boolean)

interfaces.networking = t.any

interfaces.uiModeInfo = t.any
local v6 = strictInterface(interfaces)

return function(p2)
	v6(p2)

	local v7 = if fFlagSocialCarouselShareQREnabled then useDispatch() else nil
	local v8

	if fFlagSocialCarouselShareQREnabled then
		v8 = React.useCallback(function(p3)
			v7(module2(p3))
		end, { v7 })
	end

	local v9 = fFlagLuaAppCompositionAlways and true or p2[omniFeedProps.key].appCompositionEnabled

	local selectionOrderBase = p2[omniFeedProps.key].selectionOrderBase or 0

	local appPage2 = p2[omniFeedProps.key] and p2[omniFeedProps.key].appPage or appPage.Home
	local feedItemPosition = if p2[omniFeedProps.key] then p2[omniFeedProps.key].feedItemPosition or nil else nil
	local feedItemStartRow = if p2[omniFeedProps.key] then p2[omniFeedProps.key].feedItemStartRow or nil else nil

	local v10 = React.useMemo(function()
		return {
			sortIndex = feedItemPosition or -1,
			appPage = appPage2,
			sortId = p2.topicId or fFlagLuaAppUserSeenCollectionUnifiedFields and "600000000" or nil,
			startRow = feedItemStartRow or -1
		}
	end, { feedItemPosition, appPage2, p2.topicId, feedItemStartRow })

	local createElement = Roact.createElement
	local entry = module3.Entry
	local v11 = {
		unifiedLogging = {
			sortIndex = feedItemPosition,
			appPage = appPage2,
			sortId = p2.topicId,
			scrollViewPositionChangedSignal = p2[omniFeedProps.key].scrollViewPositionChangedSignal,
			impressionTag = "HomeFriendCarousel",
			skipItemImpressionsLog = fFlagLuaAppHomeFriendsRemoveItemImpressions and true or nil
		},
		sortAnalyticsData = v10,
		refreshSignal = p2[omniFeedProps.key].refreshSignal,
		selectionOrderBase = selectionOrderBase,
		source = constants.ANALYTICS.SRC.HOMEPAGE_FRIENDS_CAROUSEL,
		hideCarouselHeader = 0,
		appCompositionEnabled = 0,
		navigateToQRCodePage = 0
	}
	local v12

	if fFlagLuaAppFriendsSortHeaderByPosition then
		local sortIndex = p2.sortIndex

		if sortIndex == nil or not (fIntLuaAppFriendsSortHeaderMaxHiddenPosition < sortIndex) then
			v12 = fFlagFlyoutHideFriendsHeader

			if v12 then
				if fFlagEnableFlyoutFriendsHeaderFix then
					v12 = flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp()
				else
					v12 = flyoutSidePanelIXP.isFlyoutSidePanelEnabled()
				end
			end
		else
			v12 = false
		end
	elseif fFlagFlyoutHideFriendsHeader then
		v12 = (if fFlagEnableFlyoutFriendsHeaderFix then flyoutSidePanelIXP.isFriendsSortHeaderHiddenInFlyoutIxp() else flyoutSidePanelIXP.isFlyoutSidePanelEnabled())
			and true
			or nil
	end

	v11.hideCarouselHeader = v12

	v11.appCompositionEnabled = v9

	if not fFlagSocialCarouselShareQREnabled then
		v8 = nil
	end

	v11.navigateToQRCodePage = v8
	return createElement(entry, v11)
end
