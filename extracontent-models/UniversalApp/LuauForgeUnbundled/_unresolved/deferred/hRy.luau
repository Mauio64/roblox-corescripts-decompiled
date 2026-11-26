local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local RoactAppExperiment = require(CorePackages.Packages.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment

local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")
local module3 = require("@luauforge/bundled/dFu")
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module4 = require("@luauforge/deferred/fFQ")
local useIsSpatial = require("@game/CorePackages/Workspace/Packages/Responsive").useIsSpatial

local module5 = require("@luauforge/bundled/hRz")
local getFFlagPlatformEventEnabled = SharedFlags.GetFFlagPlatformEventEnabled
local getFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local fFlagEnableRMOnMorePageGUAC = SharedFlags.FFlagEnableRMOnMorePageGUAC
local fFlagEnableRMOnMorePageForAll = SharedFlags.FFlagEnableRMOnMorePageForAll
local fStringRMDefinition = SharedFlags.FStringRMDefinition
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagEnableBlackbirdOnMorePage = SharedFlags.FFlagEnableBlackbirdOnMorePage
local fFlagLuaAppFixNotificationBadgeCountsSync = SharedFlags.FFlagLuaAppFixNotificationBadgeCountsSync
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagFlyoutRemoveMomentsForArgoEnabled = SharedFlags.FFlagFlyoutRemoveMomentsForArgoEnabled
local fFlagArgoEnableMoments = SharedFlags.FFlagArgoEnableMoments
local defineFastFlag = game:DefineFastFlag("GuacDisableBlackbirdOnMorePage", false)
local module6 = require("@luauforge/bundled/fIP")
local useMomentsGating = module6.Hooks.useMomentsGating
local canRenderNativeMoments = module6.canRenderNativeMoments

local v5 = {
	Navigation = { "About_Terms" },
	Action = { "LogOut" }
}

local function shouldAddToMorePageItem(p2, p3, p4, p5, p6, p7, p8, p9, p10)
	local v6 = module4.ItemType[p2]

	if v6 == nil then
		return nil
	end

	local clone = module4.ItemInfo[v6]

	if
		clone == nil
		or clone.itemType == module4.ItemType.BuildersClub and p9
		or clone.itemType == module4.ItemType.Trades and p3 == false
	then
		return nil
	end

	if
		clone.itemType == module4.ItemType.TheHunt
		and not (getFFlagPlatformEventEnabled() and #getFStringPlatformEventUrl() > 0)
	then
		return nil
	end

	if
		clone.itemType == module4.ItemType.ReportLogs and not (module5() or p4)
		or clone.itemType == module4.ItemType.VRFTUX and not p5
		or clone.itemType == module4.ItemType.AdjustScreen and not p6
	then
		return nil
	end

	if clone.itemType == module4.ItemType.RM then
		if
			fFlagFlyoutRemoveMomentsForArgoEnabled and fFlagEnableArgus and fFlagArgoEnableMoments
			or (p10 == nil or not p10.isFlyoutEntryEnabled) and not (fFlagEnableRMOnMorePageForAll or p7)
		then
			return nil
		end

		if p10 ~= nil then
			clone = table.clone(clone)
			local v7 = if canRenderNativeMoments(p10) then { page = module3.Moments } else {
				appURI = module4.MomentsExperienceURI
			}
			clone.context = v7
		end
	end

	if
		clone.itemType == module4.ItemType.Redeem and not p8
		or clone.itemType == module4.ItemType.Blackbird and not p9
	then
		return nil
	end

	return clone
end

local function updateMoreItemBadgeCount(state, data, p2, p3)
	local v6 = 0

	if state.itemType == module4.ItemType.Friends then
		v6 = if fFlagLuaAppFixNotificationBadgeCountsSync then p2 else data.MorePageFriends
	elseif state.itemType == module4.ItemType.Messages then
		v6 = if fFlagLuaAppFixNotificationBadgeCountsSync then p3 else data.MorePageMessages
	elseif
		state.itemType == module4.ItemType.Settings
		or state.itemType == module4.ItemType.Settings_AccountInfo
	then
		v6 = data.MorePageSettings
	elseif state.itemType == module4.ItemType.TencentNoticeCenter then
		v6 = data.MorePageTencentUnreadNotice
	end

	if state.badgeCount ~= v6 then
		state.badgeCount = v6
	end
end

return function()
	local v6 = useAppPolicy(function(p2)
		return p2.getMorePageContent()
	end) or v5

	local v7 = useAppPolicy(function(p2)
		return p2.getSupportsOverscan()
	end)

	local v8 = useSelector(function(p2)
		return p2.NotificationBadgeCounts
	end)

	local v9 = useSelector(function(p2)
		if not fFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local friendsCarousel = p2.FriendsCarousel
		local requests = friendsCarousel and friendsCarousel.Friends and friendsCarousel.Friends.requests
		return requests and requests.receivedCount or 0
	end)

	local v10 = useSelector(function(p2)
		if fFlagLuaAppFixNotificationBadgeCountsSync then
			return p2.SocialTab and p2.SocialTab.UnreadConversationCount or 0
		end

		return 0
	end)

	local v11 = useSelector(function(p2): boolean
		local user = p2.Users[p2.LocalUserId]

		if user then
			return user.membership == Enum.MembershipType.Premium
		end

		return false
	end)

	local v12 = useUserExperiment({ appUserLayers.AppHealthReportLogs }, function(p2)
		return (p2[appUserLayers.AppHealthReportLogs] or {}).ReportLogsButtonEnabled or nil
	end)

	local v13 = if fFlagEnableArgus or fFlagEnableRMOnMorePageGUAC then useMomentsGating() else nil
	local v14

	if fFlagEnableRMOnMorePageGUAC then
		v14 = v13.isAmpPolicyEnabled
	else
		v14 = useUserExperiment({ appUserLayers.RMLayer }, function(p2)
			return (p2[appUserLayers.RMLayer] or {})[fStringRMDefinition] or nil
		end)
	end

	local v15 = useIsSpatial()

	local v16 = useAppPolicy(function(p2)
		return p2.getRedeemTileEnabled()
	end)
	local v17

	if defineFastFlag then
		v17 = useAppPolicy(function(p2)
			return p2.getDisableBlackbirdEntrypoints()
		end)
	else
		v17 = false
	end

	local v18 = fFlagEnableBlackbird and fFlagEnableBlackbirdOnMorePage and not v17
	local useMemo = React.useMemo
	local function fn()
		return Cryo.Dictionary.values(Cryo.Dictionary.map(v6, function(p2, p3)
			return {
				["contents"] = Cryo.Dictionary.values(Cryo.Dictionary.map(p2, function(p4)
					local v19 = shouldAddToMorePageItem(p4, v11, v12, v15, v7, v14, v16, v18, v13)

					if v19 then
						updateMoreItemBadgeCount(v19, v8, v9, v10)
					end

					return v19
				end)),
				type = p3
			}
		end))
	end

	local v20 = if fFlagLuaAppFixNotificationBadgeCountsSync then v9 else nil
	return useMemo(fn, {
		v6,
		v8,
		v11,
		v15,
		v12,
		v18,
		v20,
		if fFlagLuaAppFixNotificationBadgeCountsSync then v10 else nil,
		v13,
		v14
	})
end
