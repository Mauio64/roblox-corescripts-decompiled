local AcceptFriendRequestActions = require(script.AcceptFriendRequestActions)
local AddFriendActions = require(script.AddFriendActions)
local BlockActions = require(script.BlockActions)
local CallAction = require(script.CallAction)
local ChatAction = require(script.ChatAction)
local CommunityActions = require(script.CommunityActions)
local CurrencyTransferAction = require(script.CurrencyTransferAction)
local EditAliasAction = require(script.EditAliasAction)
local EditAppearanceActions = require(script.EditAppearanceActions)
local EditProfileAction = require(script.EditProfileAction)
local FollowActions = require(script.FollowActions)
local IgnoreFriendRequestAction = require(script.IgnoreFriendRequestAction)
local JoinExperienceAction = require(script.JoinExperienceAction)
local PlayExperienceAction = require(script.PlayExperienceAction)
local PendingFriendRequestAction = require(script.PendingFriendRequestAction)
local QrCodeAction = require(script.QrCodeAction)
local ReportAction = require(script.ReportAction)
local ShareProfileAction = require(script.ShareProfileAction)
local TradeItemsAction = require(script.TradeItemsAction)
local TrustedConnectionActions = require(script.TrustedConnectionActions)
local UnfriendAction = require(script.UnfriendAction)
local UnlockChatAction = require(script.UnlockChatAction)
local ViewAboutAction = require(script.ViewAboutAction)
local ViewPlatformProfileAction = require(script.ViewPlatformProfileAction)

local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local SupportedProfileTypes = require(script.SupportedProfileTypes)
local SharedFlags = require(parent.SharedFlags)
local FFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local FFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

local ProfileActions = {}

local v = {
	AcceptFriendRequestActions,
	AddFriendActions,
	BlockActions,
	ChatAction,
	CommunityActions,
	CurrencyTransferAction,
	EditAliasAction,
	EditAppearanceActions,
	EditProfileAction,
	FollowActions,
	IgnoreFriendRequestAction,
	JoinExperienceAction,
	PendingFriendRequestAction,
	QrCodeAction,
	ReportAction,
	ShareProfileAction,
	TradeItemsAction,
	TrustedConnectionActions,
	UnfriendAction,
	UnlockChatAction,
	ViewAboutAction,
	ViewPlatformProfileAction
}

if FFlagFriendsCallingClientGate_DEV then
	table.insert(v, CallAction)
end

if FFlagJoinabilityCTARefactor then
	table.insert(v, PlayExperienceAction)
end

local function withValidation(k: string, callback) -- 1 equivalent call inferred from this helper
	return function(p)
		local v2 = callback(p)

		if v2 == nil then
			return nil
		end

		assert(
			type(v2.onActivated) == "table",
			k .. " has onActivated as " .. type(v2.onActivated) .. ", expected table"
		)

		for k2 in v2.onActivated do
			local supportedProfileType = SupportedProfileTypes[k2]
			assert(
				supportedProfileType and table.find(supportedProfileType, k),
				k .. " has onActivated for " .. tostring(k2) .. " but is missing from SupportedProfileTypes"
			)
		end

		return v2
	end
end

for _, v2 in v do
	for k, v3 in v2 do
		assert(ProfileActions[k] == nil, "Duplicate ProfileAction key: " .. tostring(k))
		ProfileActions[k] = withValidation(k, v3) -- inferred equivalent call
	end
end

for k, supportedProfileType in SupportedProfileTypes do
	for _, v2 in supportedProfileType do
		assert(
			ProfileActions[v2] ~= nil,
			v2 .. " is listed in SupportedProfileTypes for " .. tostring(k) .. " but has no matching factory"
		)
	end
end

return ProfileActions
