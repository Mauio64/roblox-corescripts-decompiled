local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local profileTypes = Enums.ProfileTypes

local FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")

local FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")
local FFlagProfilePlatformEnableEditLook = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditLook")
local fFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

local fFlagEnablePlatformProfileContextualMenuOption = SharedFlags.FFlagEnablePlatformProfileContextualMenuOption
local fFlagProfilePlatformEnableCurrencyTransfer = SharedFlags.FFlagProfilePlatformEnableCurrencyTransfer
local FFlagProfilePlatformEnableTradeItems = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableTradeItems")
local fFlagProfilePlatformAddTC = SharedFlags.FFlagProfilePlatformAddTC
local FFlagFixTFLinksVRGating = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagFixTFLinksVRGating")
local FFlagProfilePlatformEnableUserFollow = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableUserFollow")
local fFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

local v5 = {
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

if fFlagFriendsCallingClientGate_DEV then
	table.insert(v5, Enums.ProfileActions.Call)
end

if fFlagJoinabilityCTARefactor then
	table.insert(v5, Enums.ProfileActions.PlayExperience)
end

if FFlagProfilePlatformEnableEditAppearanceMenu then
	table.insert(v5, Enums.ProfileActions.EditAppearance)
	table.insert(v5, Enums.ProfileActions.EditEmotes)
	table.insert(v5, Enums.ProfileActions.SwitchAvatar)

	if FFlagProfilePlatformEditBackgroundMenuItem then
		table.insert(v5, Enums.ProfileActions.EditBackground)
	end
end

if FFlagProfilePlatformEnableEditLook then
	table.insert(v5, Enums.ProfileActions.EditLook)
end

if fFlagProfilePlatformEnableCurrencyTransfer then
	table.insert(v5, Enums.ProfileActions.CurrencyTransfer)
end

if FFlagProfilePlatformEnableTradeItems then
	table.insert(v5, Enums.ProfileActions.TradeItems)
end

if fFlagProfilePlatformAddTC then
	table.insert(v5, Enums.ProfileActions.AddTrustedConnection)
	table.insert(v5, Enums.ProfileActions.AddIncomingTrustedConnection)
	table.insert(v5, Enums.ProfileActions.PendingTrustedConnection)
end

if FFlagFixTFLinksVRGating then
	if fFlagProfilePlatformAddTC then
		table.insert(v5, Enums.ProfileActions.AddTrustedConnectionViaLink)
	end
else
	table.insert(v5, Enums.ProfileActions.AddTrustedConnectionViaLink)
end

table.insert(v5, Enums.ProfileActions.PendingIncomingTrustedConnection)

if fFlagProfilePlatformNewProfileHeader then
	table.insert(v5, Enums.ProfileActions.ViewAbout)
end

if fFlagEnablePlatformProfileContextualMenuOption then
	table.insert(v5, Enums.ProfileActions.ViewPlatformProfile)
end

if FFlagProfilePlatformEnableUserFollow then
	table.insert(v5, Enums.ProfileActions.Follow)
	table.insert(v5, Enums.ProfileActions.Unfollow)
end

local v6 = {}
table.insert(v6, Enums.ProfileActions.CopyLink)
table.insert(v6, Enums.ProfileActions.JoinCommunity)
table.insert(v6, Enums.ProfileActions.CancelJoinCommunityRequest)
table.insert(v6, Enums.ProfileActions.ViewCommunity)
table.insert(v6, Enums.ProfileActions.LeaveCommunity)
table.insert(v6, Enums.ProfileActions.MakePrimaryCommunity)
table.insert(v6, Enums.ProfileActions.RemovePrimaryCommunity)
table.insert(v6, Enums.ProfileActions.Report)
table.insert(v6, Enums.ProfileActions.ViewFullProfile)
table.insert(v6, Enums.ProfileActions.Follow)
table.insert(v6, Enums.ProfileActions.Unfollow)

local v7 = {
	Enums.ProfileActions.AddFriendFromContacts,
	Enums.ProfileActions.AddFriendFromContactsSent
}

return {
	[profileTypes.User] = v5,
	[profileTypes.Community] = v6,
	[profileTypes.Contact] = v7
}
