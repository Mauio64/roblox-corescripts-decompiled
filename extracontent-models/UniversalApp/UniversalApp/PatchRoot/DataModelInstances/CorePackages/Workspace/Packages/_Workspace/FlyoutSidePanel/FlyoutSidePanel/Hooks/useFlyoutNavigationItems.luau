local Parent = script:FindFirstAncestor("FlyoutSidePanel").Parent
local React = require(Parent.React)
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local Constants = require(script.Parent.Parent.Constants)
local AppPage = require(Parent.RobloxAppEnums).AppPage
local useAppPolicy = require(Parent.UniversalAppPolicy).useAppPolicy
local SharedFlags = require(Parent.SharedFlags)
local GetFFlagPlatformEventEnabled = SharedFlags.GetFFlagPlatformEventEnabled
local GetFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnFlyoutMenu = SharedFlags.FFlagEnableBlackbirdOnFlyoutMenu
local FFlagEnableRMOnMorePageGUAC = SharedFlags.FFlagEnableRMOnMorePageGUAC
local FFlagEnableRMOnMorePageForAll = SharedFlags.FFlagEnableRMOnMorePageForAll
local FFlagLuaAppFixNotificationBadgeCountsSync = SharedFlags.FFlagLuaAppFixNotificationBadgeCountsSync
local v15 = game:DefineFastFlag("FlyoutGateMomentsTile", false)
local useMomentsGating = require(Parent.MomentsCommon).Hooks.useMomentsGating
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local function updateNotifications(p1, p2, p3, p4) -- line: 22
	-- upvalues: FlyoutContentSettings (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy)
	local n1 = 0

	if p1.itemType == FlyoutContentSettings.ItemType.Settings then
		n1 = p2.MorePageSettings
	elseif p1.itemType == FlyoutContentSettings.ItemType.Connections then
		n1 = if not FFlagLuaAppFixNotificationBadgeCountsSync then p2.MorePageFriends else p3
	elseif p1.itemType == FlyoutContentSettings.ItemType.Messages then
		n1 = if not FFlagLuaAppFixNotificationBadgeCountsSync then p2.MorePageMessages else p4
	end

	if n1 > 0 and (not p1.notificationCount or n1 ~= p1.notificationCount) then
		p1.notificationCount = n1
	end
end
local function useFlyoutNavigationItems() -- line: 42
	-- upvalues: Constants (copy), useSelector (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy), React (copy), useAppPolicy (copy), v15 (copy), useMomentsGating (copy), FFlagEnableRMOnMorePageGUAC (copy), FlyoutContentSettings (copy), FFlagEnableBlackbird (copy), FFlagEnableBlackbirdOnFlyoutMenu (copy), updateNotifications (copy), GetFFlagPlatformEventEnabled (copy), GetFStringPlatformEventUrl (copy), FFlagEnableRMOnMorePageForAll (copy), AppPage (copy)
	local FLYOUT_DEFAULT_POLICY = Constants.FLYOUT_DEFAULT_POLICY
	local v26 = useSelector(function(p5) -- line: 46
		return p5.NotificationBadgeCounts
	end)
	local v27 = useSelector(function(p6) -- line: 50
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local FriendsCarousel = p6.FriendsCarousel
		local v44 = FriendsCarousel and (FriendsCarousel.Friends and FriendsCarousel.Friends.requests)

		return v44 and v44.receivedCount or 0
	end)
	local v28 = useSelector(function(p7) -- line: 59
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		return p7.SocialTab and p7.SocialTab.UnreadConversationCount or 0
	end)
	local v29 = useSelector(function(p8) -- line: 66
		return p8.OmniRecommendations and p8.OmniRecommendations.Home
	end)
	local v30 = v29 and v29.sorts or {}
	local v31, v32 = React.useMemo(function() -- line: 70
		-- upvalues: v30 (copy), Constants (copy)
		local v47 = nil
		local v48 = nil

		for _, v in pairs(v30) do
			if v.topicId == Constants.SORT_ID_CONTINUE_PLAYING then
				v47 = true
			elseif v.topicId == Constants.SORT_ID_FAVORITES then
				v48 = true
			end
		end

		return v47, v48
	end, { v30 })
	local v33 = useAppPolicy(function(p9) -- line: 82
		return p9.getDisablePremiumEntrypoint() or false
	end)
	local v34 = useAppPolicy(function(p10) -- line: 85
		return p10.getDisableBlackbirdEntrypoints() or false
	end)
	local v35 = useAppPolicy(function(p11) -- line: 88
		return p11.getGiftCardSourceRefOverride()
	end)
	local v36 = useAppPolicy(function(p12) -- line: 91
		return p12.getRedeemTileEnabled()
	end)
	local v37 = if not v15 then nil else useMomentsGating()
	local v38 = not not v15 and useAppPolicy(function(p13) -- line: 96
		return p13.getDisplayMomentsMoreTabTile()
	end)
	local v39 = not v15 or (not FFlagEnableRMOnMorePageGUAC or v38)
	local v40 = not v35 or v35 == ""

	return React.useMemo(function() -- line: 106
		-- upvalues: FLYOUT_DEFAULT_POLICY (copy), FlyoutContentSettings (copy), v32 (copy), v31 (copy), v33 (copy), v40 (copy), v36 (copy), FFlagEnableBlackbird (copy), FFlagEnableBlackbirdOnFlyoutMenu (copy), v34 (copy), updateNotifications (copy), v26 (copy), v27 (copy), v28 (copy), GetFFlagPlatformEventEnabled (copy), GetFStringPlatformEventUrl (copy), v15 (copy), v37 (copy), FFlagEnableRMOnMorePageForAll (copy), v39 (copy), AppPage (copy)
		local t1 = {}
		local t2 = {}

		for _, v59 in FLYOUT_DEFAULT_POLICY.MyLibrary do
			local v60 = FlyoutContentSettings.ItemInfo[v59]

			if v60 ~= nil and (v59 ~= FlyoutContentSettings.ItemType.Favorites or v32) and (v59 ~= FlyoutContentSettings.ItemType.ContinuePlaying or v31) and (v59 ~= FlyoutContentSettings.ItemType.Premium or not v33) and (v59 ~= FlyoutContentSettings.ItemType.GiftCards or not v40) and (v59 ~= FlyoutContentSettings.ItemType.Redeem or v36) and (not FFlagEnableBlackbird or not FFlagEnableBlackbirdOnFlyoutMenu or v59 ~= FlyoutContentSettings.ItemType.Premium and (v59 ~= FlyoutContentSettings.ItemType.Blackbird or not v34)) then
				local v61 = table.clone(v60)

				updateNotifications(v61, v26, v27, v28)
				table.insert(t1, v61)
			end
		end

		for _, v63 in FLYOUT_DEFAULT_POLICY.AdditionalNavigation do
			local v64 = FlyoutContentSettings.ItemInfo[v63]

			if v64 == nil then
				continue
			end

			if v63 == FlyoutContentSettings.ItemType.Events then
				if not GetFFlagPlatformEventEnabled() or GetFStringPlatformEventUrl() == "" then
					continue
				end
			elseif v63 == FlyoutContentSettings.ItemType.Moments and v15 and ((v37 == nil or not v37.isFlyoutEntryEnabled) and (not FFlagEnableRMOnMorePageForAll and not v39)) then
				continue
			end

			local v65 = table.clone(v64)

			if v63 == FlyoutContentSettings.ItemType.Moments and v37 ~= nil and v37.isFlyoutEntryEnabled and v37.platformIntegrationEnabled then
				v65.context = {
					appPage = AppPage.Moments
				}
			end

			table.insert(t2, v65)
		end

		return {
			myLibraryItems = t1,
			additionalNavigationItems = t2
		}
	end, {
		v32,
		v31,
		FLYOUT_DEFAULT_POLICY,
		v26,
		v33,
		v34,
		v40,
		if not v15 then nil else v39,
		v37,
		if not FFlagLuaAppFixNotificationBadgeCountsSync then nil else v27,
		if not FFlagLuaAppFixNotificationBadgeCountsSync then nil else v28
	})
end

return useFlyoutNavigationItems
