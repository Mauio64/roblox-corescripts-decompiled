local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableModerateChatRemoteEvent = SharedFlags.FFlagEnableModerateChatRemoteEvent
local FFlagPlatformLeaderboardRccEnabled = SharedFlags.FFlagPlatformLeaderboardRccEnabled
local v5 = game:DefineFastFlag("RemoteAllowListAddExpChatFeatureValueChanged", false)

return function() -- line: 8
	-- upvalues: FFlagEnableModerateChatRemoteEvent (copy), v5 (copy), FFlagPlatformLeaderboardRccEnabled (copy)
	assert(game:FindService("NetworkServer") ~= nil)

	local NetworkServer = game:GetService("NetworkServer")
	local t1 = {}

	table.insert(t1, "GetServerVersion")
	table.insert(t1, "GetServerChannel")
	table.insert(t1, "WhisperChat")
	table.insert(t1, "GetServerType")
	table.insert(t1, "ServerSideBulkPurchaseEvent")
	table.insert(t1, "CanChatWith")
	table.insert(t1, "SetPlayerBlockList")
	table.insert(t1, "UpdatePlayerBlockList")
	table.insert(t1, "NewPlayerGroupDetails")
	table.insert(t1, "NewPlayerCanManageDetails")
	table.insert(t1, "SendPlayerBlockList")
	table.insert(t1, "UpdateLocalPlayerBlockList")
	table.insert(t1, "SendPlayerProfileSettings")
	table.insert(t1, "UpdatePlayerProfileSettings")
	table.insert(t1, "ShowPlayerJoinedFriendsToast")
	table.insert(t1, "ShowFriendJoinedPlayerToast")
	table.insert(t1, "CreateOrJoinParty")
	table.insert(t1, "RequestPlayerProfileSettings")

	if FFlagEnableModerateChatRemoteEvent then
		table.insert(t1, "ModerateChatSettingUpdated")
	end

	if v5 then
		table.insert(t1, "ExpChatFeatureValueChanged")
	end

	table.insert(t1, "SetDialogInUse")
	table.insert(t1, "ContactListInvokeIrisInvite")
	table.insert(t1, "ContactListIrisInviteTeleport")
	table.insert(t1, "UpdateCurrentCall")
	table.insert(t1, "RequestDeviceCameraOrientationCapability")
	table.insert(t1, "RequestDeviceCameraCFrame")
	table.insert(t1, "ReplicateDeviceCameraCFrame")
	table.insert(t1, "ReferredPlayerJoin")
	table.insert(t1, "BuildExperiencePlaytestTeleport")
	table.insert(t1, "SetUserActive")
	table.insert(t1, "AvatarGesturesVRPlayer")

	if FFlagPlatformLeaderboardRccEnabled then
		table.insert(t1, "PlatformLeaderboardPush")
		table.insert(t1, "PlatformLeaderboardTabOpened")
		table.insert(t1, "PlatformLeaderboardTabClosed")
	end

	NetworkServer:InitializeRemoteAllowList(t1)
end
