local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local Enums = require(ProfilePlatform.Common.Enums)
local ProfileTypes = Enums.ProfileTypes
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags.FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagPendingIncomingTrustedConnection = require(ProfilePlatform.Flags.FFlagPendingIncomingTrustedConnection)
local FFlagProfilePlatformEnableUnlockChat = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUnlockChat)
local t1 = {
	Enums.ProfileActions.AddFriend,
	Enums.ProfileActions.CannotAddFriend,
	Enums.ProfileActions.AcceptFriendRequest,
	Enums.ProfileActions.AcceptOffNetworkFriendRequest,
	Enums.ProfileActions.Block,
	Enums.ProfileActions.Unblock,
	Enums.ProfileActions.Chat,
	Enums.ProfileActions.EditAlias,
	Enums.ProfileActions.EditAvatar,
	Enums.ProfileActions.EditProfile,
	Enums.ProfileActions.IgnoreFriendRequest,
	Enums.ProfileActions.JoinExperience,
	Enums.ProfileActions.PendingFriendRequest,
	Enums.ProfileActions.QrCode,
	Enums.ProfileActions.Report,
	Enums.ProfileActions.ShareProfile,
	Enums.ProfileActions.Unfriend,
	Enums.ProfileActions.RemoveTrustedConnection
}

if FFlagProfilePlatformEnableUnlockChat then
	table.insert(t1, Enums.ProfileActions.UnlockChat)
end

if FFlagProfilePlatformEnableEditAppearanceMenu then
	table.insert(t1, Enums.ProfileActions.EditAppearance)
	table.insert(t1, Enums.ProfileActions.EditEmotes)
	table.insert(t1, Enums.ProfileActions.SwitchAvatar)

	if FFlagProfilePlatformEditBackgroundMenuItem then
		table.insert(t1, Enums.ProfileActions.EditBackground)
	end
end

if FFlagProfilePlatformEnableEditLook then
	table.insert(t1, Enums.ProfileActions.EditLook)
end

if FFlagProfilePlatformEnableCurrencyTransfer then
	table.insert(t1, Enums.ProfileActions.CurrencyTransfer)
end

if FFlagProfilePlatformAddTC then
	table.insert(t1, Enums.ProfileActions.AddTrustedConnection)
	table.insert(t1, Enums.ProfileActions.AddIncomingTrustedConnection)
	table.insert(t1, Enums.ProfileActions.PendingTrustedConnection)
end

table.insert(t1, Enums.ProfileActions.AddTrustedConnectionViaLink)

if FFlagPendingIncomingTrustedConnection then
	table.insert(t1, Enums.ProfileActions.PendingIncomingTrustedConnection)
end

if FFlagProfilePlatformNewProfileHeader then
	table.insert(t1, Enums.ProfileActions.ViewAbout)
end

if FFlagEnablePlatformProfileContextualMenuOption then
	table.insert(t1, Enums.ProfileActions.ViewPlatformProfile)
end

local t2 = {}

table.insert(t2, Enums.ProfileActions.CopyLink)
table.insert(t2, Enums.ProfileActions.JoinCommunity)
table.insert(t2, Enums.ProfileActions.CancelJoinCommunityRequest)
table.insert(t2, Enums.ProfileActions.ViewCommunity)
table.insert(t2, Enums.ProfileActions.LeaveCommunity)
table.insert(t2, Enums.ProfileActions.MakePrimaryCommunity)
table.insert(t2, Enums.ProfileActions.RemovePrimaryCommunity)
table.insert(t2, Enums.ProfileActions.Report)

if FFlagProfilePlatformUpdateUXForNonSocialCommunities then
	table.insert(t2, Enums.ProfileActions.ViewFullProfile)
	table.insert(t2, Enums.ProfileActions.Follow)
	table.insert(t2, Enums.ProfileActions.Unfollow)
end

local t3 = {
	Enums.ProfileActions.AddFriendFromContacts,
	Enums.ProfileActions.AddFriendFromContactsSent
}

return {
	[ProfileTypes.User] = t1,
	[ProfileTypes.Community] = t2,
	[ProfileTypes.Contact] = t3
}
