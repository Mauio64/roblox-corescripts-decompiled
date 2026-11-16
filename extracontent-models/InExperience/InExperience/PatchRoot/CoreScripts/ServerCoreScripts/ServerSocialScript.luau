local HttpService = game:GetService("HttpService")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
game:GetService("RunService")
local Chat = game:GetService("Chat")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local RobloxGui = CoreGui:WaitForChild("RobloxGui")
local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url
game:DefineFastFlag("EnableSetUserBlocklistInitialized", false)

local FFlagInExperienceUserProfileSettingsEnabled = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceUserProfileSettingsEnabled)

local FFlagInExperienceRequestProfileSettings = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceRequestProfileSettings)

local FStringRccInExperienceNameEnabledAllowList = require(RobloxGui.Modules.Common.Flags.FStringRccInExperienceNameEnabledAllowList)
local defineFastFlag = game:DefineFastFlag("UseNewDirectChatAPI", false)
local defineFastFlag2 = game:DefineFastFlag("EnableCreatePartyNudge", false)
local defineFastFlag3 = game:DefineFastFlag("EnableCreatePartyNudgeWithVersion", false)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnablePartyNudgeAfterJoin = SharedFlags.FFlagEnablePartyNudgeAfterJoin

local SharedFlags2 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShowFriendJoinedYouToastForNonReferredJoins = SharedFlags2.FFlagShowFriendJoinedYouToastForNonReferredJoins

local SharedFlags3 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagBadgeVisibilitySettingEnabled = SharedFlags3.FFlagBadgeVisibilitySettingEnabled

local SharedFlags4 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableModerateChatRemoteEvent = SharedFlags4.FFlagEnableModerateChatRemoteEvent

local SharedFlags5 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagEnableSummarySystemMessageOnLua = SharedFlags5.FFlagEnableSummarySystemMessageOnLua

local SharedFlags6 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAIRephraseSettingEnabled = SharedFlags6.FFlagAIRephraseSettingEnabled

local SharedFlags7 = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagChatSummariesSettingEnabled = SharedFlags7.FFlagChatSummariesSettingEnabled
local defineFastFlag4 = game:DefineFastFlag("ProfileSettingsSlidingWindowRateLimit", false)
local defineFastInt = game:DefineFastInt("ProfileSettingsRateLimitSeconds", 5)
local defineFastInt2 = game:DefineFastInt("ProfileSettingsMaxRequestsPerWindow", 3)
local defineFastInt3 = game:DefineFastInt("ProfileSettingsRateLimitWindowSeconds", 60)
local defineFastFlag5 = game:DefineFastFlag("DisableRCCAntiHarrasmentAllowList", false)
local shouldShowFriendJoinedPlayerToast = require(RobloxGui.Modules.Server.shouldShowFriendJoinedPlayerToast)
local defineFastFlag6 = game:DefineFastFlag("GatePrivateServerNudge", false)

local v = {}

local v2 = {
	Admin = { GroupId = 1200769 },
	Intern = { GroupId = 2868472, GroupRank = 100 },
	Star = { GroupId = 4199740 },
	SpanishLocalizationExpert = { GroupId = 4265462, GroupRank = 252 },
	BrazilianLocalizationExpert = { GroupId = 4265456, GroupRank = 252 },
	FrenchLocalizationExpert = { GroupId = 4265443, GroupRank = 252 },
	GermanLocalizationExpert = { GroupId = 4265449, GroupRank = 252 }
}

if game.CreatorType == Enum.CreatorType.Group then
	v2.PlaceCreator = { GroupId = game.CreatorId, GroupRank = 255 }
end

local v3 = {}

local v4 = {}

local v5 = {}
local v6 = {}
local v7 = {}

game:DefineFastInt("MaxBlockListSize", 500)

local canChatWith = Instance.new("RemoteEvent")
canChatWith.Name = "CanChatWith"
canChatWith.Parent = RobloxReplicatedStorage

local setPlayerBlockList = Instance.new("RemoteEvent")
setPlayerBlockList.Name = "SetPlayerBlockList"
setPlayerBlockList.Parent = RobloxReplicatedStorage

local updatePlayerBlockList = Instance.new("RemoteEvent")
updatePlayerBlockList.Name = "UpdatePlayerBlockList"
updatePlayerBlockList.Parent = RobloxReplicatedStorage

local newPlayerGroupDetails = Instance.new("RemoteEvent")
newPlayerGroupDetails.Name = "NewPlayerGroupDetails"
newPlayerGroupDetails.Parent = RobloxReplicatedStorage

local newPlayerCanManageDetails = Instance.new("RemoteEvent")
newPlayerCanManageDetails.Name = "NewPlayerCanManageDetails"
newPlayerCanManageDetails.Parent = RobloxReplicatedStorage

local sendPlayerBlockList = Instance.new("RemoteEvent")
sendPlayerBlockList.Name = "SendPlayerBlockList"
sendPlayerBlockList.Parent = RobloxReplicatedStorage

local updateLocalPlayerBlockList = Instance.new("RemoteEvent")
updateLocalPlayerBlockList.Name = "UpdateLocalPlayerBlockList"
updateLocalPlayerBlockList.Parent = RobloxReplicatedStorage

local sendPlayerProfileSettings = Instance.new("RemoteEvent")
sendPlayerProfileSettings.Name = "SendPlayerProfileSettings"
sendPlayerProfileSettings.Parent = RobloxReplicatedStorage
local requestPlayerProfileSettings

if FFlagInExperienceRequestProfileSettings then
	requestPlayerProfileSettings = Instance.new("RemoteEvent")
	requestPlayerProfileSettings.Name = "RequestPlayerProfileSettings"
	requestPlayerProfileSettings.Parent = RobloxReplicatedStorage
end

local updatePlayerProfileSettings

if FFlagBadgeVisibilitySettingEnabled then
	updatePlayerProfileSettings = Instance.new("RemoteEvent")
	updatePlayerProfileSettings.Name = "UpdatePlayerProfileSettings"
	updatePlayerProfileSettings.Parent = RobloxReplicatedStorage
end

local showFriendJoinedPlayerToast = nil
local showPlayerJoinedFriendsToast

if FFlagEnablePartyNudgeAfterJoin then
	showPlayerJoinedFriendsToast = Instance.new("RemoteEvent")
	showPlayerJoinedFriendsToast.Name = "ShowPlayerJoinedFriendsToast"
	showPlayerJoinedFriendsToast.Parent = RobloxReplicatedStorage
else
	showPlayerJoinedFriendsToast = nil
end

if FFlagEnablePartyNudgeAfterJoin or FFlagShowFriendJoinedYouToastForNonReferredJoins then
	showFriendJoinedPlayerToast = Instance.new("RemoteEvent")
	showFriendJoinedPlayerToast.Name = "ShowFriendJoinedPlayerToast"
	showFriendJoinedPlayerToast.Parent = RobloxReplicatedStorage
end

local createOrJoinParty = Instance.new("RemoteEvent")
createOrJoinParty.Name = "CreateOrJoinParty"
createOrJoinParty.Parent = RobloxReplicatedStorage
local moderateChatSettingUpdated

if FFlagEnableModerateChatRemoteEvent then
	moderateChatSettingUpdated = Instance.new("RemoteEvent")
	moderateChatSettingUpdated.Name = "ModerateChatSettingUpdated"
	moderateChatSettingUpdated.Parent = RobloxReplicatedStorage
else
	moderateChatSettingUpdated = nil
end

local expChatFeatureValueChanged

if FFlagEnableSummarySystemMessageOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
	expChatFeatureValueChanged = Instance.new("RemoteEvent")
	expChatFeatureValueChanged.Name = "ExpChatFeatureValueChanged"
	expChatFeatureValueChanged.Parent = RobloxReplicatedStorage
else
	expChatFeatureValueChanged = nil
end

local v8 = {}

local function verifyUserId(value): boolean -- 2 equivalent calls inferred from this helper
	return type(value) == "number"
end

local function verifyBlockList(list): boolean
	if #list == 0 or #list > game:GetFastInt("MaxBlockListSize") then
		return false
	end

	for _, item in pairs(list) do
		if not verifyUserId(item) then -- inferred equivalent call
			return false
		end
	end

	return true
end

local function sendPlayerAllGroupDetails(player) -- 1 equivalent call inferred from this helper
	newPlayerGroupDetails:FireClient(player, v3)
end

local function getPlayerGroupDetails(object)
	local v9 = {}

	for k, v10 in pairs(v2) do
		if v10.GroupRank == nil then
			local success, result = pcall(function()
				return object:IsInGroupAsync(v10.GroupId)
			end)

			v9[k] = success and result
		else
			local success, result = pcall(function(): boolean
				return object:GetRankInGroupAsync(v10.GroupId) >= v10.GroupRank
			end)

			v9[k] = success and result
		end
	end

	if object.Parent then
		local userId = tostring(object.UserId)
		v3[userId] = v9

		newPlayerGroupDetails:FireAllClients({ [userId] = v9 })
	end
end

local function sendCanChatWith(player)
	local v9 = {}

	for _, player2 in ipairs(Players:GetPlayers()) do
		if defineFastFlag then
			local success, result = pcall(function()
				return TextChatService:CanUsersDirectChatAsync(player.UserId, { player2.UserId })
			end)

			v9[player2.UserId] = success and #result > 0
			local v10 = {
				[player.UserId] = success and #result > 0
			}
			canChatWith:FireClient(player2, v10)
		else
			local success, result = pcall(function()
				return Chat:CanUsersChatAsync(player.UserId, player2.UserId)
			end)

			v9[player2.userId] = success and result
			local v10 = {
				[player.userId] = success and result
			}
			canChatWith:FireClient(player2, v10)
		end
	end

	canChatWith:FireClient(player, v9)
end

local function sendPlayerAllCanManage(player)
	for k, v9 in pairs(v4) do
		newPlayerCanManageDetails:FireClient(player, k, v9)
	end
end

local function getPlayerCanManage(data)
	if data.UserId <= 0 or not data.Parent then
		return
	end

	local success, canManageAsync = pcall(data.GetCanManageAsync, data)
	local v9 = success and canManageAsync and true or false
	local userId = tostring(data.UserId)
	v4[userId] = v9
	newPlayerCanManageDetails:FireAllClients(userId, v9)
end

local function sendPlayerBlockList2(player)
	if player.UserId <= 0 then
		return
	end

	local function scanAndSendBlockList(p)
		if not player.Parent then
			return
		end

		local userIdSet = {}

		for _, player2 in Players:GetPlayers() do
			if player2 == player then
				continue
			end

			if player:HasBlockedPlayer(player2.UserId) then
				userIdSet[player2.UserId] = true
			end

			if p and player2:HasBlockedPlayer(player.UserId) then
				updateLocalPlayerBlockList:FireClient(player2, player.UserId, true)
			end
		end

		sendPlayerBlockList:FireClient(player, userIdSet)
	end

	local flag = false

	player.BlockListChanged:Connect(function()
		if flag then
			scanAndSendBlockList(false)

			return
		end

		scanAndSendBlockList(true)
		flag = true
	end)

	if player:GetBlockListInitialized() then
		scanAndSendBlockList(true)
		flag = true
	end
end

local function sendPlayerAllInExperienceNameEnabled(player)
	for k, isInExperienceNameEnabled in pairs(v5) do
		sendPlayerProfileSettings:FireClient(player, k, {
			isInExperienceNameEnabled = isInExperienceNameEnabled
		})
	end
end

local function fn(p)
	if p.UserId <= 0 then
		return
	end

	local isInExperienceNameEnabled = false

	if FStringRccInExperienceNameEnabledAllowList.isAllowListedUserId(p.UserId) or defineFastFlag5 then
		local success, result = pcall(function()
			local formatted = `user-profile-api/v1/user/profiles/rcc/settings?userId={p.UserId}`
			return HttpService:JSONDecode((HttpRbxApiService:GetAsyncFullUrl(
				Url.APIS_URL .. formatted,
				Enum.ThrottlingPriority.Default,
				Enum.HttpRequestType.Players
			)))
		end)

		if success and result then
			isInExperienceNameEnabled = result.isSettingsEnabled
				and result.userProfileSettings
				and result.userProfileSettings.isInExperienceNameEnabled
		end
	end

	local userId = tostring(p.UserId)
	v5[userId] = isInExperienceNameEnabled
	sendPlayerProfileSettings:FireAllClients(userId, {
		isInExperienceNameEnabled = isInExperienceNameEnabled
	})
end

if FFlagInExperienceRequestProfileSettings then
	requestPlayerProfileSettings.OnServerEvent:Connect(function(player)
		local userId = tostring(player.UserId)
		local isInExperienceNameEnabled = v5[userId]

		if isInExperienceNameEnabled == nil then
			coroutine.wrap(fn)(player)
		else
			sendPlayerProfileSettings:FireClient(player, userId, {
				isInExperienceNameEnabled = isInExperienceNameEnabled
			})
		end
	end)
end

local function canCreatePartyNudge(data)
	if not data then
		return false
	end

	return data.PartyId == "" and data.VRDevice == "" and typeof(data.OsPlatform) == "string" and ({
		Windows = true,
		iOS = true,
		Android = true,
		OSX = true,
		Win32 = true,
		Windows_Universal = true
	})[data.OsPlatform]
end

local function fn2(player)
	local players = Players:GetPlayers()
	local v9 = nil

	for _, player2 in players do
		if player2.UserId == player.FollowUserId then
			v9 = player2
			break
		end
	end

	local success

	if
		FFlagEnablePartyNudgeAfterJoin
		and defineFastFlag2
		and canCreatePartyNudge(v9)
		and canCreatePartyNudge(player)
	then
		local userId = player.UserId
		local userId2 = v9.UserId
		local nudgeType = "OneToOneNudgeInExperience"
		local result
		success, result = pcall(function()
			local v10 = string.format(Url.APIS_URL .. "group-up/v1/create-party-nudge")

			local v11 = {
				inviterId = userId,
				inviteeId = userId2,
				nudgeType = nudgeType,
				placeId = game.PlaceId,
				gameInstanceId = game.JobId,
				universeId = game.GameId,
				version = defineFastFlag3 and 1 or nil,
				privateServerId = 0,
				privateServerOwnerId = 0
			}
			local privateServerId

			if defineFastFlag6 then
				privateServerId = game.PrivateServerId
			end

			v11.privateServerId = privateServerId
			local privateServerOwnerId

			if defineFastFlag6 then
				privateServerOwnerId = game.PrivateServerOwnerId
			end

			v11.privateServerOwnerId = privateServerOwnerId
			return HttpService:JSONDecode((HttpRbxApiService:PostAsyncFullUrl(v10, (HttpService:JSONEncode(v11)))))
		end)

		if success and result and result.shouldAutoCreateOrJoinGroupUp then
			createOrJoinParty:FireClient(player, "PartyNudge", result.nudge)
		end
	else
		success = false
	end

	if not success and #players > 0 then
		if
			v9
			and (not FFlagShowFriendJoinedYouToastForNonReferredJoins or shouldShowFriendJoinedPlayerToast(player))
		then
			showFriendJoinedPlayerToast:FireClient(v9, player)
		end

		if FFlagEnablePartyNudgeAfterJoin then
			showPlayerJoinedFriendsToast:FireClient(player)
		end
	end
end

local function onPlayerAdded(player)
	coroutine.wrap(sendPlayerBlockList2)(player)
	sendPlayerAllGroupDetails(player) -- inferred equivalent call

	if player.UserId > 0 then
		coroutine.wrap(getPlayerGroupDetails)(player)
	end

	if FFlagInExperienceUserProfileSettingsEnabled then
		sendPlayerAllInExperienceNameEnabled(player)
		coroutine.wrap(fn)(player)
	end

	sendPlayerAllCanManage(player)
	coroutine.wrap(getPlayerCanManage)(player)

	sendCanChatWith(player)

	if FFlagEnablePartyNudgeAfterJoin or FFlagShowFriendJoinedYouToastForNonReferredJoins then
		coroutine.wrap(fn2)(player)
	end
end

setPlayerBlockList.OnServerEvent:Connect(function(object, p)
	if game:GetFastFlag("EnableSetUserBlocklistInitialized") then
		object:SetBlockListInitialized()
	end

	if type(p) == "table" and verifyBlockList(p) then
		object:AddToBlockList(p)
	end
end)

updatePlayerBlockList.OnServerEvent:Connect(function(object, value, p)
	if type(p) == "boolean" and verifyUserId(value) then -- inferred equivalent call
		object:UpdatePlayerBlocked(value, p)
	end
end)

if FFlagBadgeVisibilitySettingEnabled then
	updatePlayerProfileSettings.OnServerEvent:Connect(function(p, p2)
		if type(p2) ~= "table" then
			return
		end

		local v9 = {}

		if type(p2.isInExperienceNameEnabled) ~= "boolean" then
			return
		end

		v9.isInExperienceNameEnabled = p2.isInExperienceNameEnabled

		local userId = tostring(p.UserId)
		local now = tick()

		if defineFastFlag4 then
			if not v7[userId] then
				v7[userId] = {}
			end

			local nows = v7[userId]
			local v10 = now - defineFastInt3

			for i = #nows, 1, -1 do
				if nows[i] < v10 then
					table.remove(nows, i)
				end
			end

			if defineFastInt2 <= #nows then
				return
			end

			table.insert(nows, now)
		else
			local v10 = v6[userId]

			if v10 and now - v10 < defineFastInt then
				return
			end

			v6[userId] = now
		end

		v5[userId] = v9.isInExperienceNameEnabled

		sendPlayerProfileSettings:FireAllClients(userId, v9)
	end)
end

if FFlagEnableModerateChatRemoteEvent then
	moderateChatSettingUpdated.OnServerEvent:Connect(function(player, p)
		if typeof(p) == "boolean" and TextChatService:setModerationModeEnabled(player.UserId, p) then
			moderateChatSettingUpdated:FireClient(player, p)
		end
	end)
end

if FFlagEnableSummarySystemMessageOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
	TextChatService.ExpChatFeatureValueChanged:Connect(function(p: number, p2: string, p3: string)
		local playerByUserId = Players:GetPlayerByUserId(p)

		if playerByUserId then
			expChatFeatureValueChanged:FireClient(playerByUserId, p, p2, p3)
		end
	end)
end

Players.PlayerAdded:connect(onPlayerAdded)

for _, v9 in pairs(Players:GetPlayers()) do
	onPlayerAdded(v9)
end

Players.PlayerRemoving:connect(function(p)
	local userId = tostring(p.UserId)

	if v[userId] then
		v[userId] = nil
		v8[userId] = nil
	end

	if v3[userId] then
		v3[userId] = nil
	end

	if v4[userId] ~= nil then
		v4[userId] = nil
	end

	if v5[userId] ~= nil then
		v5[userId] = nil
	end

	if FFlagBadgeVisibilitySettingEnabled then
		if defineFastFlag4 then
			if v7[userId] ~= nil then
				v7[userId] = nil
			end
		elseif v6[userId] ~= nil then
			v6[userId] = nil
		end
	end
end)

local function onOnServerEvent() end

for _, remoteEvent in ipairs(RobloxReplicatedStorage:GetChildren()) do
	if remoteEvent:IsA("RemoteEvent") then
		remoteEvent.OnServerEvent:Connect(onOnServerEvent)
	end
end
