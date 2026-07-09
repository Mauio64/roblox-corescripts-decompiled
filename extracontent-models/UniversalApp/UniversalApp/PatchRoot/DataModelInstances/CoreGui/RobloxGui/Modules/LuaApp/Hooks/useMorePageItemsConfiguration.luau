local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useUserExperiment = require(CorePackages.Packages.RoactAppExperiment).useUserExperiment
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local AppPage = require(Modules.LuaApp.AppPage)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local MorePageSettings = require(Modules.LuaApp.Components.More.Config.MorePageSettings)
local useIsSpatial = require(CorePackages.Workspace.Packages.Responsive).useIsSpatial
local GetFFlagForceEnableReportLogsButton = require(Modules.LuaApp.Flags.GetFFlagForceEnableReportLogsButton)
local GetFFlagPlatformEventEnabled = SharedFlags.GetFFlagPlatformEventEnabled
local GetFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local FFlagEnableRMOnMorePageGUAC = SharedFlags.FFlagEnableRMOnMorePageGUAC
local FFlagEnableRMOnMorePageForAll = SharedFlags.FFlagEnableRMOnMorePageForAll
local FStringRMDefinition = SharedFlags.FStringRMDefinition
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnMorePage = SharedFlags.FFlagEnableBlackbirdOnMorePage
local FFlagLuaAppFixNotificationBadgeCountsSync = SharedFlags.FFlagLuaAppFixNotificationBadgeCountsSync
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local v23 = game:DefineFastFlag("GuacDisableBlackbirdOnMorePage", false)
local useMomentsGating = require(CorePackages.Workspace.Packages.MomentsCommon).Hooks.useMomentsGating
local t1 = {
	Navigation = { "About_Terms" },
	Action = { "LogOut" }
}

local function shouldAddToMorePageItem(p1, p2, p3, p4, p5, p6, p7, p8, t2: {[any]: any}?) -- line: 43
	-- upvalues: MorePageSettings (copy), GetFFlagPlatformEventEnabled (copy), GetFStringPlatformEventUrl (copy), GetFFlagForceEnableReportLogsButton (copy), FFlagEnableRMOnMorePageForAll (copy), AppPage (copy)
	local v37 = MorePageSettings.ItemType[p1]

	if v37 == nil then
		return nil
	end

	local v38 = MorePageSettings.ItemInfo[v37]

	if v38 == nil then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.BuildersClub and p8 then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.Trades and p2 == false then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.TheHunt and (not GetFFlagPlatformEventEnabled() or not (#GetFStringPlatformEventUrl() > 0)) then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.ReportLogs and (not GetFFlagForceEnableReportLogsButton() and not p3) then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.VRFTUX and not p4 then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.AdjustScreen and not p5 then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.RM then
		if t2 == nil or not t2.isFlyoutEntryEnabled then
			if not FFlagEnableRMOnMorePageForAll and not p6 then
				return nil
			end
		elseif t2.platformIntegrationEnabled then
			v38 = table.clone(v38)
			v38.context = {
				page = AppPage.Moments
			}
		end
	end

	if v38.itemType == MorePageSettings.ItemType.Redeem and not p7 then
		return nil
	end

	if v38.itemType == MorePageSettings.ItemType.Blackbird and not p8 then
		return nil
	end

	return v38
end
local function updateMoreItemBadgeCount(p9, p10, p11, p12) -- line: 130
	-- upvalues: MorePageSettings (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy)
	local n1 = 0

	if p9.itemType == MorePageSettings.ItemType.Friends then
		n1 = if not FFlagLuaAppFixNotificationBadgeCountsSync then p10.MorePageFriends else p11
	elseif p9.itemType == MorePageSettings.ItemType.Messages then
		n1 = if not FFlagLuaAppFixNotificationBadgeCountsSync then p10.MorePageMessages else p12
	elseif p9.itemType == MorePageSettings.ItemType.Settings or p9.itemType == MorePageSettings.ItemType.Settings_AccountInfo then
		n1 = p10.MorePageSettings
	elseif p9.itemType == MorePageSettings.ItemType.TencentNoticeCenter then
		n1 = p10.MorePageTencentUnreadNotice
	end

	if n1 ~= p9.badgeCount then
		p9.badgeCount = n1
	end
end

return function() -- line: 158
	-- upvalues: useAppPolicy (copy), t1 (copy), useSelector (copy), FFlagLuaAppFixNotificationBadgeCountsSync (copy), useUserExperiment (copy), AppUserLayers (copy), FFlagEnableArgus (copy), useMomentsGating (copy), FFlagEnableRMOnMorePageGUAC (copy), FStringRMDefinition (copy), useIsSpatial (copy), v23 (copy), FFlagEnableBlackbird (copy), FFlagEnableBlackbirdOnMorePage (copy), React (copy), Cryo (copy), shouldAddToMorePageItem (copy), updateMoreItemBadgeCount (copy)
	local v44 = useAppPolicy(function(p13) -- line: 159
		return p13.getMorePageContent()
	end) or t1
	local v45 = useAppPolicy(function(p14) -- line: 163
		return p14.getSupportsOverscan()
	end)
	local v46 = useSelector(function(p15) -- line: 167
		return p15.NotificationBadgeCounts
	end)
	local v47 = useSelector(function(p16) -- line: 171
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		local FriendsCarousel = p16.FriendsCarousel
		local v62 = FriendsCarousel and (FriendsCarousel.Friends and FriendsCarousel.Friends.requests)

		return v62 and v62.receivedCount or 0
	end)
	local v48 = useSelector(function(p17) -- line: 180
		-- upvalues: FFlagLuaAppFixNotificationBadgeCountsSync (copy)
		if not FFlagLuaAppFixNotificationBadgeCountsSync then
			return 0
		end

		return p17.SocialTab and p17.SocialTab.UnreadConversationCount or 0
	end)
	local v49 = useSelector(function(p18) -- line: 187
		local v65 = p18.Users[p18.LocalUserId]

		if v65 then
			return v65.membership == Enum.MembershipType.Premium
		end

		return false
	end)
	local v50 = useUserExperiment({ AppUserLayers.AppHealthReportLogs }, function(p19) -- line: 196
		-- upvalues: AppUserLayers (copy)
		return (p19[AppUserLayers.AppHealthReportLogs] or {}).ReportLogsButtonEnabled or nil
	end)
	local v51 = if not FFlagEnableArgus then nil else useMomentsGating()
	local v52 = if not FFlagEnableRMOnMorePageGUAC then useUserExperiment({ AppUserLayers.RMLayer }, function(p20) -- line: 206
		-- upvalues: AppUserLayers (copy), FStringRMDefinition (copy)
		return (p20[AppUserLayers.RMLayer] or {})[FStringRMDefinition] or nil
	end) else useAppPolicy(function(p21) -- line: 203
		return p21.getDisplayMomentsMoreTabTile()
	end)
	local v53 = useIsSpatial()
	local v54 = useAppPolicy(function(p22) -- line: 213
		return p22.getRedeemTileEnabled()
	end)
	local v55 = not not v23 and useAppPolicy(function(p23) -- line: 218
		return p23.getDisableBlackbirdEntrypoints()
	end)
	local v56 = FFlagEnableBlackbird and (FFlagEnableBlackbirdOnMorePage and not v55)

	return React.useMemo(function() -- line: 226
		-- upvalues: Cryo (copy), v44 (copy), shouldAddToMorePageItem (copy), v49 (copy), v50 (copy), v53 (copy), v45 (copy), v52 (copy), v54 (copy), v56 (copy), v51 (copy), updateMoreItemBadgeCount (copy), v46 (copy), v47 (copy), v48 (copy)
		return Cryo.Dictionary.values(Cryo.Dictionary.map(v44, function(p24, p25) -- line: 227
			-- upvalues: Cryo (copy), shouldAddToMorePageItem (copy), v49 (copy), v50 (copy), v53 (copy), v45 (copy), v52 (copy), v54 (copy), v56 (copy), v51 (copy), updateMoreItemBadgeCount (copy), v46 (copy), v47 (copy), v48 (copy)
			return {
				contents = Cryo.Dictionary.values(Cryo.Dictionary.map(p24, function(p26) -- line: 228
					-- upvalues: shouldAddToMorePageItem (copy), v49 (copy), v50 (copy), v53 (copy), v45 (copy), v52 (copy), v54 (copy), v56 (copy), v51 (copy), updateMoreItemBadgeCount (copy), v46 (copy), v47 (copy), v48 (copy)
					local v74 = shouldAddToMorePageItem(p26, v49, v50, v53, v45, v52, v54, v56, v51)

					if v74 then
						updateMoreItemBadgeCount(v74, v46, v47, v48)
					end

					return v74
				end)),
				type = p25
			}
		end))
	end, {
		v44,
		v46,
		v49,
		v53,
		v50,
		v56,
		if not FFlagLuaAppFixNotificationBadgeCountsSync then nil else v47,
		if not FFlagLuaAppFixNotificationBadgeCountsSync then nil else v48,
		v51,
		v52
	})
end
