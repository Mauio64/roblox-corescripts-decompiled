local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local RoactUtils = require(ProfilePlatformParent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffectOnce = RoactUtils.Hooks.useEffectOnce
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local NetworkingPresence = require(ProfilePlatform.Networking.NetworkingPresence)
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local IconName = require(ProfilePlatformParent.Foundation).Enums.IconName
local NavigateDown = require(ProfilePlatformParent.NavigationRodux).Thunks.NavigateDown
local FFlagSignalsNavP3Dispatch = require(ProfilePlatformParent.SharedFlags).FFlagSignalsNavP3Dispatch
local v13 = if not FFlagSignalsNavP3Dispatch then nil else require(ProfilePlatformParent.RobloxAppNavigation).NavigationCommands
local NetworkStatus = myRoduxNetworking.Enum.NetworkStatus
local Enums = require(ProfilePlatform.Common.Enums)
local useProfileActions = require(ProfilePlatform.Hooks.useProfileActions)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local FFlagEnableProfilePlatformDisabledActions = require(ProfilePlatformParent.SharedFlags).FFlagEnableProfilePlatformDisabledActions
local FFlagEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagEnableCommunityVerificationModal)
local FFlagPortEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagPortEnableCommunityVerificationModal)
local FFlagEnableProfilePlatformDisabledReasonText = require(ProfilePlatform.Flags.FFlagEnableProfilePlatformDisabledReasonText)
local FFlagProfilePlatformEnableUserProfileButtonsBacktest = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUserProfileButtonsBacktest)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagProfilePlatformAddCurrentlyPlaying = require(ProfilePlatform.Flags.FFlagProfilePlatformAddCurrentlyPlaying)
local FFlagProfilePlatformEnableUnlockChat = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUnlockChat)
local FFlagProfilePlatformPresenceStoreMigration = require(ProfilePlatform.Flags.FFlagProfilePlatformPresenceStoreMigration)
local v31 = if not FFlagProfilePlatformPresenceStoreMigration then nil else require(ProfilePlatformParent.DataHydration).Presence.PresenceStore.get()
local Dash = require(ProfilePlatformParent.Dash)
local t1 = {
	[Enums.ProfileActions.AcceptFriendRequest] = true,
	[Enums.ProfileActions.AcceptOffNetworkFriendRequest] = true,
	[Enums.ProfileActions.AddFriend] = true,
	[Enums.ProfileActions.AddFriendFromContacts] = true,
	[Enums.ProfileActions.AddFriendFromContactsSent] = true,
	[Enums.ProfileActions.CannotAddFriend] = true,
	[Enums.ProfileActions.Chat] = true,
	[Enums.ProfileActions.UnlockChat] = not not FFlagProfilePlatformEnableUnlockChat or nil,
	[Enums.ProfileActions.EditAlias] = true,
	[Enums.ProfileActions.EditAppearance] = not not FFlagProfilePlatformEnableEditAppearanceMenu or nil,
	[Enums.ProfileActions.EditBackground] = FFlagProfilePlatformEnableEditAppearanceMenu and not not FFlagProfilePlatformEditBackgroundMenuItem or nil,
	[Enums.ProfileActions.EditAvatar] = true,
	[Enums.ProfileActions.EditLook] = not not FFlagProfilePlatformEnableEditLook or nil,
	[Enums.ProfileActions.EditProfile] = true,
	[Enums.ProfileActions.JoinExperience] = true,
	[Enums.ProfileActions.PendingFriendRequest] = true,
	[Enums.ProfileActions.Unblock] = true,
	[Enums.ProfileActions.JoinCommunity] = true,
	[Enums.ProfileActions.Follow] = not not FFlagProfilePlatformUpdateUXForNonSocialCommunities or nil,
	[Enums.ProfileActions.CancelJoinCommunityRequest] = true,
	[Enums.ProfileActions.ViewCommunity] = true,
	[Enums.ProfileActions.ViewFullProfile] = not not FFlagProfilePlatformUpdateUXForNonSocialCommunities or nil,
	[Enums.ProfileActions.ShareProfile] = true,
	[Enums.ProfileActions.Unfriend] = true,
	[Enums.ProfileActions.CurrencyTransfer] = not not FFlagProfilePlatformEnableCurrencyTransfer or nil
}

function isJoinExperience(p1) -- line: 94
	-- upvalues: Enums (copy)
	for _, v36 in p1 do
		if v36.type == Enums.ProfileActions.JoinExperience then
			return true
		end
	end

	return false
end

return function(s1: string) -- line: 103
	-- upvalues: useDispatch (copy), useProfileJsonComponent (copy), Enums (copy), FFlagProfilePlatformPresenceStoreMigration (copy), useSelector (copy), NetworkingPresence (copy), NetworkStatus (copy), useProfileActions (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), React (copy), v31 (copy), useEffectOnce (copy), FFlagProfilePlatformEnableUserProfileButtonsBacktest (copy), Dash (copy), t1 (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), FFlagEnableProfilePlatformDisabledActions (copy), FFlagEnableCommunityVerificationModal (copy), FFlagPortEnableCommunityVerificationModal (copy), IconName (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy), FFlagEnableProfilePlatformDisabledReasonText (copy)
	local v38 = useDispatch()
	local v39 = useProfileJsonComponent(Enums.Components.Actions) or {}
	local v40 = if not FFlagProfilePlatformPresenceStoreMigration then useSelector(function(p2) -- line: 109
		-- upvalues: NetworkingPresence (copy), s1 (copy), NetworkStatus (copy)
		return NetworkingPresence.GetPresencesFromUserIds.getStatus(p2, s1) == NetworkStatus.NotStarted
	end) else nil
	local v41 = useProfileActions(Enums.ButtonSurface.Actions)
	local t2 = {}
	local t3 = {}
	local t4 = {}

	if FFlagProfilePlatformAddCurrentlyPlaying then
		React.useEffect(function() -- line: 122
			-- upvalues: v39 (copy), FFlagProfilePlatformPresenceStoreMigration (copy), v31 (copy), s1 (copy), v38 (copy), NetworkingPresence (copy)
			if isJoinExperience(v39.buttons) then
				if FFlagProfilePlatformPresenceStoreMigration then
					v31.RefreshPresenceByUserId(s1)

					return
				end

				v38(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
			end
		end, {
			v39.buttons,
			v38,
			s1
		})
	else
		useEffectOnce(function() -- line: 133
			-- upvalues: FFlagProfilePlatformPresenceStoreMigration (copy), v31 (copy), s1 (copy), v38 (copy), NetworkingPresence (copy)
			if FFlagProfilePlatformPresenceStoreMigration then
				v31.RefreshPresenceByUserId(s1)

				return
			end

			v38(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
		end, isJoinExperience(v39.buttons) and (not not FFlagProfilePlatformPresenceStoreMigration or v40))
	end

	local v45 = FFlagProfilePlatformEnableUserProfileButtonsBacktest and Dash.find(v39.buttons, function(p3) -- line: 146
		-- upvalues: Enums (copy)
		return p3.type == Enums.ProfileActions.JoinExperience
	end)

	for _, v in ipairs(v39.buttons) do
		if not v45 or v.type == Enums.ProfileActions.JoinExperience or not t1[v.type] then
			local v48 = v41[v.type]

			if FFlagProfilePlatformEnableEditAppearanceMenu and v.subActions then
				local t5 = {}

				for _, v51 in v.subActions do
					local v52 = v41[v51]

					if v52 then
						table.insert(t5, {
							id = v51,
							text = v52.text,
							icon = v52.icon,
							onActivated = v52.onActivated
						})
					end
				end

				if #t5 > 0 then
					v48.menuItems = t5
				end
			end

			if FFlagEnableProfilePlatformDisabledActions and v.disabledReason then
				if FFlagEnableCommunityVerificationModal and v.type == Enums.ProfileActions.JoinCommunity and (v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelLow or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelMedium or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelHigh) then
					v48.icon = if not FFlagEnableCommunityVerificationModal or not FFlagPortEnableCommunityVerificationModal then nil else IconName.LockClosed

					function v48.onActivated() -- line: 195
						-- upvalues: Enums (copy), v (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), v38 (copy), NavigateDown (copy)
						local t6 = {
							name = Enums.Screens.CommunityVerificationModal,
							extraProps = {
								disabledReason = v.disabledReason
							}
						}

						if FFlagSignalsNavP3Dispatch then
							return v13.down(v13.fromLegacyPage(t6))
						end

						return v38(NavigateDown(t6))
					end
				else
					v48.isDisabled = true
					v48.disabledReason = if not FFlagEnableProfilePlatformDisabledReasonText then nil else v.disabledReason
				end
			end

			if t1[v.type] then
				table.insert(t3, v48)
			else
				table.insert(t4, v48)
			end
		end
	end

	if #t3 > 0 then
		t2.primary = t3
	end

	if #t4 > 0 then
		t2.secondary = t4
	end

	return t2, not not v39.contextual
end
