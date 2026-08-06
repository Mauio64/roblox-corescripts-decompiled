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
local FFlagFixMomentsExperienceFallback = SharedFlags.FFlagFixMomentsExperienceFallback
local v16 = game:DefineFastFlag("FlyoutGateMomentsTile", false)
local MomentsCommon = require(Parent.MomentsCommon)
local useMomentsGating = MomentsCommon.Hooks.useMomentsGating
local canRenderNativeMoments = MomentsCommon.canRenderNativeMoments
local FlyoutContentSettings = require(script.Parent.Parent.Config.FlyoutContentSettings)

local function updateNotifications(p1, p2, p3, p4) -- line: 25
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
local function useFlyoutNavigationItems() -- line: 45
	-- upvalues: Constants (copy), useSelector (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy), React (copy), useAppPolicy (copy), v16 (copy), FFlagFixMomentsExperienceFallback (copy), useMomentsGating (copy), FFlagEnableRMOnMorePageGUAC (copy), FlyoutContentSettings (copy), FFlagEnableBlackbird (copy), FFlagEnableBlackbirdOnFlyoutMenu (copy), updateNotifications (copy), GetFFlagPlatformEventEnabled (copy), GetFStringPlatformEventUrl (copy), FFlagEnableRMOnMorePageForAll (copy), canRenderNativeMoments (copy), AppPage (copy)
	local FLYOUT_DEFAULT_POLICY = Constants.FLYOUT_DEFAULT_POLICY
	local v29 = useSelector(function(p5) -- line: 49
		return p5.NotificationBadgeCounts
	end)
	local v30 = useSelector(function(p6) -- line: 53
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local FriendsCarousel = p6.FriendsCarousel
		local v47 = FriendsCarousel and (FriendsCarousel.Friends and FriendsCarousel.Friends.requests)

		return v47 and v47.receivedCount or 0
	end)
	local v31 = useSelector(function(p7) -- line: 62
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		return p7.SocialTab and p7.SocialTab.UnreadConversationCount or 0
	end)
	local v32 = useSelector(function(p8) -- line: 69
		return p8.OmniRecommendations and p8.OmniRecommendations.Home
	end)
	local v33 = v32 and v32.sorts or {}
	local v34, v35 = React.useMemo(function() -- line: 73
		-- upvalues: v33 (copy), Constants (copy)
		local v50 = nil
		local v51 = nil

		for _, v in pairs(v33) do
			if v.topicId == Constants.SORT_ID_CONTINUE_PLAYING then
				v50 = true
			elseif v.topicId == Constants.SORT_ID_FAVORITES then
				v51 = true
			end
		end

		return v50, v51
	end, { v33 })
	local v36 = useAppPolicy(function(p9) -- line: 85
		return p9.getDisablePremiumEntrypoint() or false
	end)
	local v37 = useAppPolicy(function(p10) -- line: 88
		return p10.getDisableBlackbirdEntrypoints() or false
	end)
	local v38 = useAppPolicy(function(p11) -- line: 91
		return p11.getGiftCardSourceRefOverride()
	end)
	local v39 = useAppPolicy(function(p12) -- line: 94
		return p12.getRedeemTileEnabled()
	end)
	local v40 = if not v16 and not FFlagFixMomentsExperienceFallback then nil else useMomentsGating()
	local v41 = not not v16 and useAppPolicy(function(p13) -- line: 101
		return p13.getDisplayMomentsMoreTabTile()
	end)
	local v42 = not v16 or (not FFlagEnableRMOnMorePageGUAC or v41)
	local v43 = not v38 or v38 == ""

	return React.useMemo(function() -- line: 111
		-- upvalues: FLYOUT_DEFAULT_POLICY (copy), FlyoutContentSettings (copy), v35 (copy), v34 (copy), v36 (copy), v43 (copy), v39 (copy), FFlagEnableBlackbird (copy), FFlagEnableBlackbirdOnFlyoutMenu (copy), v37 (copy), updateNotifications (copy), v29 (copy), v30 (copy), v31 (copy), GetFFlagPlatformEventEnabled (copy), GetFStringPlatformEventUrl (copy), v16 (copy), v40 (copy), FFlagEnableRMOnMorePageForAll (copy), v42 (copy), FFlagFixMomentsExperienceFallback (copy), canRenderNativeMoments (copy), AppPage (copy)
		local t1 = {}
		local t2 = {}

		for _, v62 in FLYOUT_DEFAULT_POLICY.MyLibrary do
			local v63 = FlyoutContentSettings.ItemInfo[v62]

			if v63 ~= nil and (v62 ~= FlyoutContentSettings.ItemType.Favorites or v35) and (v62 ~= FlyoutContentSettings.ItemType.ContinuePlaying or v34) and (v62 ~= FlyoutContentSettings.ItemType.Premium or not v36) and (v62 ~= FlyoutContentSettings.ItemType.GiftCards or not v43) and (v62 ~= FlyoutContentSettings.ItemType.Redeem or v39) and (not FFlagEnableBlackbird or not FFlagEnableBlackbirdOnFlyoutMenu or v62 ~= FlyoutContentSettings.ItemType.Premium and (v62 ~= FlyoutContentSettings.ItemType.Blackbird or not v37)) then
				local v64 = table.clone(v63)

				updateNotifications(v64, v29, v30, v31)
				table.insert(t1, v64)
			end
		end

		for _, v66 in FLYOUT_DEFAULT_POLICY.AdditionalNavigation do
			local v67 = FlyoutContentSettings.ItemInfo[v66]

			if v67 == nil then
				continue
			end

			if v66 == FlyoutContentSettings.ItemType.Events then
				if not GetFFlagPlatformEventEnabled() or GetFStringPlatformEventUrl() == "" then
					continue
				end
			elseif v66 == FlyoutContentSettings.ItemType.Moments and v16 and ((v40 == nil or not v40.isFlyoutEntryEnabled) and (not FFlagEnableRMOnMorePageForAll and not v42)) then
				continue
			end

			local v68 = table.clone(v67)

			if v66 == FlyoutContentSettings.ItemType.Moments and v40 ~= nil then
				if FFlagFixMomentsExperienceFallback then
					v68.context = if not canRenderNativeMoments(v40) then {
						appUri = FlyoutContentSettings.MomentsExperienceUri
					} else {
						appPage = AppPage.Moments
					}
				elseif v40.isFlyoutEntryEnabled and v40.platformIntegrationEnabled then
					v68.context = {
						appPage = AppPage.Moments
					}
				end
			end

			table.insert(t2, v68)
		end

		return {
			myLibraryItems = t1,
			additionalNavigationItems = t2
		}
	end, {
		v35,
		v34,
		FLYOUT_DEFAULT_POLICY,
		v29,
		v36,
		v37,
		v43,
		if not v16 then nil else v42,
		v40,
		if not FFlagLuaAppFixNotificationBadgeCountsSync then nil else v30,
		if not FFlagLuaAppFixNotificationBadgeCountsSync then nil else v31
	})
end

return useFlyoutNavigationItems
