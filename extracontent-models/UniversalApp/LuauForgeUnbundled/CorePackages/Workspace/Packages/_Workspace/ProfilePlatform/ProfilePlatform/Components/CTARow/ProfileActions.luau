local AcceptFriendRequestActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/AcceptFriendRequestActions")
local AddFriendActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/AddFriendActions")
local BlockActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/BlockActions")
local CallAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/CallAction")
local ChatAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/ChatAction")
local CommunityActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/CommunityActions")
local CurrencyTransferAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/CurrencyTransferAction")
local EditAliasAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/EditAliasAction")
local EditAppearanceActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/EditAppearanceActions")
local EditProfileAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/EditProfileAction")
local FollowActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/FollowActions")
local IgnoreFriendRequestAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/IgnoreFriendRequestAction")
local JoinExperienceAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/JoinExperienceAction")
local PlayExperienceAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/PlayExperienceAction")
local PendingFriendRequestAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/PendingFriendRequestAction")
local QrCodeAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/QrCodeAction")
local ReportAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/ReportAction")
local ShareProfileAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/ShareProfileAction")
local TradeItemsAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/TradeItemsAction")
local TrustedConnectionActions = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/TrustedConnectionActions")
local UnfriendAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/UnfriendAction")
local UnlockChatAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/UnlockChatAction")
local ViewAboutAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/ViewAboutAction")
local ViewPlatformProfileAction = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/ViewPlatformProfileAction")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local SupportedProfileTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/ProfileActions/SupportedProfileTypes")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagFriendsCallingClientGate_DEV = SharedFlags.FFlagFriendsCallingClientGate_DEV
local fFlagJoinabilityCTARefactor = SharedFlags.FFlagJoinabilityCTARefactor

local result = {}

local modules = {
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

if fFlagFriendsCallingClientGate_DEV then
	table.insert(modules, CallAction)
end

if fFlagJoinabilityCTARefactor then
	table.insert(modules, PlayExperienceAction)
end

local function withValidation(p2, callback)
	return function(p3)
		local v5 = callback(p3)

		if v5 == nil then
			return nil
		end

		assert(
			type(v5.onActivated) == "table",
			p2 .. " has onActivated as " .. type(v5.onActivated) .. ", expected table"
		)

		for k in v5.onActivated do
			local v6 = SupportedProfileTypes[k]
			assert(
				v6 and table.find(v6, p2),
				p2 .. " has onActivated for " .. tostring(k) .. " but is missing from SupportedProfileTypes"
			)
		end

		return v5
	end
end

for k, v5 in modules do
	for k2, v6 in v5 do
		assert(result[k2] == nil, "Duplicate ProfileAction key: " .. tostring(k2))
		local v7 = v6
		local v8 = k2

		result[k2] = function(p2)
			local v9 = v7(p2)

			if v9 == nil then
				return nil
			end

			assert(
				type(v9.onActivated) == "table",
				v8 .. " has onActivated as " .. type(v9.onActivated) .. ", expected table"
			)

			for k3 in v9.onActivated do
				local v10 = SupportedProfileTypes[k3]
				assert(
					v10 and table.find(v10, v8),
					v8 .. " has onActivated for " .. tostring(k3) .. " but is missing from SupportedProfileTypes"
				)
			end

			return v9
		end
	end
end

for k, v5 in SupportedProfileTypes do
	for k2, v6 in v5 do
		assert(
			result[v6] ~= nil,
			v6 .. " is listed in SupportedProfileTypes for " .. tostring(k) .. " but has no matching factory"
		)
	end
end

return result
