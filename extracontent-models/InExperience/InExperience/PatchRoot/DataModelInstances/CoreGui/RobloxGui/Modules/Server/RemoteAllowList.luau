local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableModerateChatRemoteEvent = SharedFlags.FFlagEnableModerateChatRemoteEvent
local FFlagPlatformLeaderboardRccEnabled = SharedFlags.FFlagPlatformLeaderboardRccEnabled
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local defineFastFlag = game:DefineFastFlag("RemoteAllowListAddExpChatFeatureValueChanged", false)

return function()
	assert(game:FindService("NetworkServer") ~= nil)
	local NetworkServer = game:GetService("NetworkServer")

	local v = {}

	table.insert(v, "GetServerVersion")
	table.insert(v, "GetServerChannel")

	table.insert(v, "WhisperChat")

	table.insert(v, "GetServerType")

	table.insert(v, "ServerSideBulkPurchaseEvent")

	table.insert(v, "CanChatWith")
	table.insert(v, "SetPlayerBlockList")
	table.insert(v, "UpdatePlayerBlockList")
	table.insert(v, "NewPlayerGroupDetails")
	table.insert(v, "NewPlayerCanManageDetails")
	table.insert(v, "SendPlayerBlockList")
	table.insert(v, "UpdateLocalPlayerBlockList")
	table.insert(v, "SendPlayerProfileSettings")
	table.insert(v, "UpdatePlayerProfileSettings")
	table.insert(v, "ShowPlayerJoinedFriendsToast")
	table.insert(v, "ShowFriendJoinedPlayerToast")
	table.insert(v, "CreateOrJoinParty")
	table.insert(v, "RequestPlayerProfileSettings")

	if FFlagEnableModerateChatRemoteEvent then
		table.insert(v, "ModerateChatSettingUpdated")
	end

	if defineFastFlag then
		table.insert(v, "ExpChatFeatureValueChanged")
	end

	table.insert(v, "SetDialogInUse")

	table.insert(v, "RequestDeviceCameraOrientationCapability")
	table.insert(v, "RequestDeviceCameraCFrame")
	table.insert(v, "ReplicateDeviceCameraCFrame")

	table.insert(v, "ReferredPlayerJoin")

	table.insert(v, "BuildExperiencePlaytestTeleport")

	if FFlagLuaAppsEnablePromptVIPServerPurchase then
		table.insert(v, "TeleportToPurchasedVIPServer")
	end

	table.insert(v, "SetUserActive")

	table.insert(v, "AvatarGesturesVRPlayer")

	if FFlagPlatformLeaderboardRccEnabled then
		table.insert(v, "PlatformLeaderboardPush")
		table.insert(v, "PlatformLeaderboardTabOpened")
		table.insert(v, "PlatformLeaderboardTabClosed")
	end

	NetworkServer:InitializeRemoteAllowList(v)
end
