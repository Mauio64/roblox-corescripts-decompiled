local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SharedFlags = require(parent.SharedFlags)
local Enums = require(ProfilePlatform.Common.Enums)
local ProfileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableEditLook = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditLook)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags.FFlagEnablePlatformProfileContextualMenuOption
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableTradeItems)
local FFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagFixTFLinksVRGating = require(ProfilePlatform.Flags.FFlagFixTFLinksVRGating)
local FFlagProfilePlatformEnableUserFollow = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableUserFollow)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

local v = {
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
	Enums.ProfileActions.RemoveTrustedConnection,
	Enums.ProfileActions.UnlockChat
}

if FFlagFriendsCallingClientGate_DEV then
	table.insert(v, Enums.ProfileActions.Call)
end

if FFlagJoinabilityCTARefactor then
	table.insert(v, Enums.ProfileActions.PlayExperience)
end

if FFlagProfilePlatformEnableEditAppearanceMenu then
	table.insert(v, Enums.ProfileActions.EditAppearance)
	table.insert(v, Enums.ProfileActions.EditEmotes)
	table.insert(v, Enums.ProfileActions.SwitchAvatar)

	if FFlagProfilePlatformEditBackgroundMenuItem then
		table.insert(v, Enums.ProfileActions.EditBackground)
	end
end

if FFlagProfilePlatformEnableEditLook then
	table.insert(v, Enums.ProfileActions.EditLook)
end

if FFlagProfilePlatformEnableCurrencyTransfer then
	table.insert(v, Enums.ProfileActions.CurrencyTransfer)
end

if FFlagProfilePlatformEnableTradeItems then
	table.insert(v, Enums.ProfileActions.TradeItems)
end

if FFlagProfilePlatformAddTC then
	table.insert(v, Enums.ProfileActions.AddTrustedConnection)
	table.insert(v, Enums.ProfileActions.AddIncomingTrustedConnection)
	table.insert(v, Enums.ProfileActions.PendingTrustedConnection)
end

if FFlagFixTFLinksVRGating then
	if FFlagProfilePlatformAddTC then
		table.insert(v, Enums.ProfileActions.AddTrustedConnectionViaLink)
	end
else
	table.insert(v, Enums.ProfileActions.AddTrustedConnectionViaLink)
end

table.insert(v, Enums.ProfileActions.PendingIncomingTrustedConnection)

if FFlagProfilePlatformNewProfileHeader then
	table.insert(v, Enums.ProfileActions.ViewAbout)
end

if FFlagEnablePlatformProfileContextualMenuOption then
	table.insert(v, Enums.ProfileActions.ViewPlatformProfile)
end

if FFlagProfilePlatformEnableUserFollow then
	table.insert(v, Enums.ProfileActions.Follow)
	table.insert(v, Enums.ProfileActions.Unfollow)
end

local v2 = {}
table.insert(v2, Enums.ProfileActions.CopyLink)
table.insert(v2, Enums.ProfileActions.JoinCommunity)
table.insert(v2, Enums.ProfileActions.CancelJoinCommunityRequest)
table.insert(v2, Enums.ProfileActions.ViewCommunity)
table.insert(v2, Enums.ProfileActions.LeaveCommunity)
table.insert(v2, Enums.ProfileActions.MakePrimaryCommunity)
table.insert(v2, Enums.ProfileActions.RemovePrimaryCommunity)
table.insert(v2, Enums.ProfileActions.Report)
table.insert(v2, Enums.ProfileActions.ViewFullProfile)
table.insert(v2, Enums.ProfileActions.Follow)
table.insert(v2, Enums.ProfileActions.Unfollow)

local v3 = { Enums.ProfileActions.AddFriendFromContacts, Enums.ProfileActions.AddFriendFromContactsSent }

return { [ProfileTypes.User] = v, [ProfileTypes.Community] = v2, [ProfileTypes.Contact] = v3 }
