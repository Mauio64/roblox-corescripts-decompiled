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

function isJoinExperience(p1) -- line: 87
	-- upvalues: Enums (copy)
	for _, v34 in p1 do
		if v34.type == Enums.ProfileActions.JoinExperience then
			return true
		end
	end

	return false
end

return function(s1: string) -- line: 96
	-- upvalues: useDispatch (copy), useProfileJsonComponent (copy), Enums (copy), useSelector (copy), NetworkingPresence (copy), NetworkStatus (copy), useProfileActions (copy), FFlagProfilePlatformAddCurrentlyPlaying (copy), React (copy), useEffectOnce (copy), FFlagProfilePlatformEnableUserProfileButtonsBacktest (copy), Dash (copy), t1 (copy), FFlagProfilePlatformEnableEditAppearanceMenu (copy), FFlagEnableProfilePlatformDisabledActions (copy), FFlagEnableCommunityVerificationModal (copy), FFlagPortEnableCommunityVerificationModal (copy), IconName (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), NavigateDown (copy), FFlagEnableProfilePlatformDisabledReasonText (copy)
	local v36 = useDispatch()
	local v37 = useProfileJsonComponent(Enums.Components.Actions) or {}
	local v38 = useSelector(function(p2) -- line: 100
		-- upvalues: NetworkingPresence (copy), s1 (copy), NetworkStatus (copy)
		return NetworkingPresence.GetPresencesFromUserIds.getStatus(p2, s1) == NetworkStatus.NotStarted
	end)
	local v39 = useProfileActions(Enums.ButtonSurface.Actions)
	local t2 = {}
	local t3 = {}
	local t4 = {}

	if FFlagProfilePlatformAddCurrentlyPlaying then
		React.useEffect(function() -- line: 113
			-- upvalues: v37 (copy), v36 (copy), NetworkingPresence (copy), s1 (copy)
			if isJoinExperience(v37.buttons) then
				v36(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
			end
		end, {
			v37.buttons,
			v36,
			s1
		})
	else
		useEffectOnce(function() -- line: 119
			-- upvalues: v36 (copy), NetworkingPresence (copy), s1 (copy)
			v36(NetworkingPresence.GetPresencesFromUserIds.API({ s1 }))
		end, isJoinExperience(v37.buttons) and v38)
	end

	local v43 = FFlagProfilePlatformEnableUserProfileButtonsBacktest and Dash.find(v37.buttons, function(p3) -- line: 125
		-- upvalues: Enums (copy)
		return p3.type == Enums.ProfileActions.JoinExperience
	end)

	for _, v in ipairs(v37.buttons) do
		if not v43 or v.type == Enums.ProfileActions.JoinExperience or not t1[v.type] then
			local v46 = v39[v.type]

			if FFlagProfilePlatformEnableEditAppearanceMenu and v.subActions then
				local t5 = {}

				for _, v49 in v.subActions do
					local v50 = v39[v49]

					if v50 then
						table.insert(t5, {
							id = v49,
							text = v50.text,
							icon = v50.icon,
							onActivated = v50.onActivated
						})
					end
				end

				if #t5 > 0 then
					v46.menuItems = t5
				end
			end

			if FFlagEnableProfilePlatformDisabledActions and v.disabledReason then
				if FFlagEnableCommunityVerificationModal and v.type == Enums.ProfileActions.JoinCommunity and (v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelLow or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelMedium or v.disabledReason == Enums.DisabledReasons.InsufficientVerificationLevelHigh) then
					v46.icon = if not FFlagEnableCommunityVerificationModal or not FFlagPortEnableCommunityVerificationModal then nil else IconName.LockClosed

					function v46.onActivated() -- line: 174
						-- upvalues: Enums (copy), v (copy), FFlagSignalsNavP3Dispatch (copy), v13 (copy), v36 (copy), NavigateDown (copy)
						local t6 = {
							name = Enums.Screens.CommunityVerificationModal,
							extraProps = {
								disabledReason = v.disabledReason
							}
						}

						if FFlagSignalsNavP3Dispatch then
							return v13.down(v13.fromLegacyPage(t6))
						end

						return v36(NavigateDown(t6))
					end
				else
					v46.isDisabled = true
					v46.disabledReason = if not FFlagEnableProfilePlatformDisabledReasonText then nil else v.disabledReason
				end
			end

			if t1[v.type] then
				table.insert(t3, v46)
			else
				table.insert(t4, v46)
			end
		end
	end

	if #t3 > 0 then
		t2.primary = t3
	end

	if #t4 > 0 then
		t2.secondary = t4
	end

	return t2, not not v37.contextual
end
