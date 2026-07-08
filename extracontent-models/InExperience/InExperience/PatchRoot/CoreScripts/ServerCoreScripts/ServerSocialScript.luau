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
local Url = require(CorePackages.Workspace.Packages.CoreScriptsCommon).Url

game:DefineFastFlag("EnableSetUserBlocklistInitialized", false)

local FFlagInExperienceUserProfileSettingsEnabled = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceUserProfileSettingsEnabled)
local FFlagInExperienceRequestProfileSettings = require(RobloxGui.Modules.Common.Flags.FFlagInExperienceRequestProfileSettings)
local FStringRccInExperienceNameEnabledAllowList = require(RobloxGui.Modules.Common.Flags.FStringRccInExperienceNameEnabledAllowList)
local v14 = game:DefineFastFlag("UseNewDirectChatAPI", false)
local v15 = game:DefineFastFlag("EnableCreatePartyNudge", false)
local v16 = game:DefineFastFlag("EnableCreatePartyNudgeWithVersion", false)
local FFlagEnablePartyNudgeAfterJoin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnablePartyNudgeAfterJoin
local FFlagBadgeVisibilitySettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagBadgeVisibilitySettingEnabled
local FFlagEnableModerateChatRemoteEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableModerateChatRemoteEvent
local FFlagEnableSummarySystemMessageOnLua = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSummarySystemMessageOnLua
local FFlagAIRephraseSettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAIRephraseSettingEnabled
local FFlagChatSummariesSettingEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagChatSummariesSettingEnabled
local v23 = game:DefineFastFlag("ProfileSettingsSlidingWindowRateLimit", false)
local v24 = game:DefineFastInt("ProfileSettingsRateLimitSeconds", 5)
local v25 = game:DefineFastInt("ProfileSettingsMaxRequestsPerWindow", 3)
local v26 = game:DefineFastInt("ProfileSettingsRateLimitWindowSeconds", 60)
local v27 = game:DefineFastFlag("DisableRCCAntiHarrasmentAllowList", false)
local v28 = game:DefineFastFlag("UseGetCanManageAsync", false) and game:GetEngineFeature("LuaGetCanManageAsync")
local FFlagUserPresenceTokenRccCheckPermissionsLua = require(RobloxGui.Modules.Common.Flags.FFlagUserPresenceTokenRccCheckPermissionsLua)
local v30 = game:DefineFastFlag("GatePrivateServerNudge", false)
local v31 = game:DefineFastFlag("GlobalUserBlockingLuaReadsFromSCMCache", false)
local t1 = {}
local t2 = {
	Admin = {
		GroupId = 1200769
	},
	Intern = {
		GroupId = 2868472,
		GroupRank = 100
	},
	Star = {
		GroupId = 4199740
	},
	SpanishLocalizationExpert = {
		GroupId = 4265462,
		GroupRank = 252
	},
	BrazilianLocalizationExpert = {
		GroupId = 4265456,
		GroupRank = 252
	},
	FrenchLocalizationExpert = {
		GroupId = 4265443,
		GroupRank = 252
	},
	GermanLocalizationExpert = {
		GroupId = 4265449,
		GroupRank = 252
	}
}

if game.CreatorType == Enum.CreatorType.Group then
	t2.PlaceCreator = {
		GroupRank = 255,
		GroupId = game.CreatorId
	}
end

local t3 = {}
local t4 = {}
local t5 = {}
local t6 = {}
local t7 = {}

game:DefineFastInt("MaxBlockListSize", 500)

local RemoteEvent = Instance.new("RemoteEvent")

RemoteEvent.Name = "CanChatWith"
RemoteEvent.Parent = RobloxReplicatedStorage

local RemoteEvent2 = Instance.new("RemoteEvent")

RemoteEvent2.Name = "SetPlayerBlockList"
RemoteEvent2.Parent = RobloxReplicatedStorage

local RemoteEvent3 = Instance.new("RemoteEvent")

RemoteEvent3.Name = "UpdatePlayerBlockList"
RemoteEvent3.Parent = RobloxReplicatedStorage

local RemoteEvent4 = Instance.new("RemoteEvent")

RemoteEvent4.Name = "NewPlayerGroupDetails"
RemoteEvent4.Parent = RobloxReplicatedStorage

local RemoteEvent5 = Instance.new("RemoteEvent")

RemoteEvent5.Name = "NewPlayerCanManageDetails"
RemoteEvent5.Parent = RobloxReplicatedStorage

local RemoteEvent6 = Instance.new("RemoteEvent")

RemoteEvent6.Name = "SendPlayerBlockList"
RemoteEvent6.Parent = RobloxReplicatedStorage

local RemoteEvent7 = Instance.new("RemoteEvent")

RemoteEvent7.Name = "UpdateLocalPlayerBlockList"
RemoteEvent7.Parent = RobloxReplicatedStorage

local RemoteEvent8 = Instance.new("RemoteEvent")

RemoteEvent8.Name = "SendPlayerProfileSettings"
RemoteEvent8.Parent = RobloxReplicatedStorage

local RemoteEvent9 = nil

if FFlagInExperienceRequestProfileSettings then
	RemoteEvent9 = Instance.new("RemoteEvent")
	RemoteEvent9.Name = "RequestPlayerProfileSettings"
	RemoteEvent9.Parent = RobloxReplicatedStorage
end

local RemoteEvent10 = nil

if FFlagBadgeVisibilitySettingEnabled then
	RemoteEvent10 = Instance.new("RemoteEvent")
	RemoteEvent10.Name = "UpdatePlayerProfileSettings"
	RemoteEvent10.Parent = RobloxReplicatedStorage
end

local RemoteEvent11 = nil
local RemoteEvent12 = nil

if FFlagEnablePartyNudgeAfterJoin then
	RemoteEvent12 = Instance.new("RemoteEvent")
	RemoteEvent12.Name = "ShowPlayerJoinedFriendsToast"
	RemoteEvent12.Parent = RobloxReplicatedStorage
	RemoteEvent11 = Instance.new("RemoteEvent")
	RemoteEvent11.Name = "ShowFriendJoinedPlayerToast"
	RemoteEvent11.Parent = RobloxReplicatedStorage
end

local RemoteEvent13 = Instance.new("RemoteEvent")

RemoteEvent13.Name = "CreateOrJoinParty"
RemoteEvent13.Parent = RobloxReplicatedStorage

local RemoteEvent14 = nil

if FFlagEnableModerateChatRemoteEvent then
	RemoteEvent14 = Instance.new("RemoteEvent")
	RemoteEvent14.Name = "ModerateChatSettingUpdated"
	RemoteEvent14.Parent = RobloxReplicatedStorage
end

local RemoteEvent15 = nil

if FFlagEnableSummarySystemMessageOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
	RemoteEvent15 = Instance.new("RemoteEvent")
	RemoteEvent15.Name = "ExpChatFeatureValueChanged"
	RemoteEvent15.Parent = RobloxReplicatedStorage
end

local t8 = {}

local function verifyUserId(p1) -- line: 173
	return type(p1) == "number"
end
local function verifyBlockList(p2) -- line: 177
	if #p2 == 0 or #p2 > game:GetFastInt("MaxBlockListSize") then
		return false
	end

	for _, v in pairs(p2) do
		if type(v) ~= "number" then
			return false
		end
	end

	return true
end
local function sendPlayerAllGroupDetails(p3) -- line: 190
	-- upvalues: RemoteEvent4 (copy), t3 (copy)
	RemoteEvent4:FireClient(p3, t3)
end
local function getPlayerGroupDetails(p4) -- line: 194
	-- upvalues: t2 (copy), t3 (copy), RemoteEvent4 (copy)
	local t9 = {}

	for k, v in pairs(t2) do
		if v.GroupRank ~= nil then
			local ok, result = pcall(function() -- line: 198
				-- upvalues: p4 (copy), v (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return p4:GetRankInGroupAsync(v.GroupId) >= v.GroupRank
				end

				return p4:GetRankInGroup(v.GroupId) >= v.GroupRank
			end)

			t9[k] = ok and result
		else
			local ok, result = pcall(function() -- line: 208
				-- upvalues: p4 (copy), v (copy)
				if game:GetEngineFeature("AsyncRenamesUsedInLuaApps") then
					return p4:IsInGroupAsync(v.GroupId)
				end

				return p4:IsInGroup(v.GroupId)
			end)

			t9[k] = ok and result
		end
	end

	if p4.Parent then
		local str = tostring(p4.UserId)

		t3[str] = t9
		RemoteEvent4:FireAllClients({
			[str] = t9
		})
	end
end
local function sendCanChatWith(p5) -- line: 229
	-- upvalues: Players (copy), v14 (copy), TextChatService (copy), RemoteEvent (copy), Chat (copy)
	local t10 = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if v14 then
			local ok, result = pcall(function() -- line: 234
				-- upvalues: TextChatService (copy), p5 (copy), player (copy)
				return TextChatService:CanUsersDirectChatAsync(p5.UserId, { player.UserId })
			end)

			t10[player.UserId] = ok and #result > 0
			RemoteEvent:FireClient(player, {
				[p5.UserId] = ok and #result > 0
			})
		else
			local ok, result = pcall(function() -- line: 243
				-- upvalues: Chat (copy), p5 (copy), player (copy)
				return Chat:CanUsersChatAsync(p5.UserId, player.UserId)
			end)

			t10[player.userId] = ok and result
			RemoteEvent:FireClient(player, {
				[p5.userId] = ok and result
			})
		end
	end

	RemoteEvent:FireClient(p5, t10)
end
local function sendPlayerAllCanManage(p6) -- line: 257
	-- upvalues: t4 (copy), RemoteEvent5 (copy)
	for k, v in pairs(t4) do
		RemoteEvent5:FireClient(p6, k, v)
	end
end
local function getPlayerCanManage(p7) -- line: 263
	-- upvalues: v28 (copy), t4 (copy), RemoteEvent5 (copy), Url (copy), HttpService (copy), FFlagUserPresenceTokenRccCheckPermissionsLua (copy), HttpRbxApiService (copy)
	if v28 then
		if p7.UserId <= 0 or not p7.Parent then
			return
		end

		local v98 = false
		local ok, result = pcall(p7.GetCanManageAsync, p7)

		if ok and result then
			v98 = true
		end

		local str = tostring(p7.UserId)

		t4[str] = v98
		RemoteEvent5:FireAllClients(str, v98)

		return
	end

	local v102 = false

	if p7.UserId > 0 then
		local ok, result = pcall(function() -- line: 282
			-- upvalues: Url (copy), HttpService (copy), p7 (copy), FFlagUserPresenceTokenRccCheckPermissionsLua (copy), HttpRbxApiService (copy)
			local v172 = string.format(Url.APIS_URL .. "asset-permissions-api/v1/rcc/assets/check-permissions")
			local json = HttpService:JSONEncode({
				requests = {{
					action = "Edit",
					subject = {
						subjectType = "User",
						subjectId = p7.UserId
					},
					assetId = game.PlaceId
				}}
			})
			local v174 = if not FFlagUserPresenceTokenRccCheckPermissionsLua then HttpRbxApiService:PostAsyncFullUrl(v172, json) else HttpRbxApiService:PostAsyncFullUrlForPlayer(v172, json, p7)

			return HttpService:JSONDecode(v174)
		end)

		if ok then
			local v105 = result.results[1]

			if v105.value and v105.value.status == "HasPermission" then
				v102 = true
			end
		end
	end

	if p7.Parent then
		local str = tostring(p7.UserId)

		t4[str] = v102
		RemoteEvent5:FireAllClients(str, v102)
	end
end
local function sendPlayerBlockList(p8) -- line: 338
	-- upvalues: v31 (copy), Players (copy), RemoteEvent7 (copy), RemoteEvent6 (copy), Url (copy), HttpService (copy), HttpRbxApiService (copy)
	if p8.UserId <= 0 then
		return
	end

	if v31 then
		local function scanAndSendBlockList(p9) -- line: 344
			-- upvalues: p8 (copy), Players (copy), RemoteEvent7 (copy), RemoteEvent6 (copy)
			if not p8.Parent then
				return
			end

			local t11 = {}

			for _, player in Players:GetPlayers() do
				if player ~= p8 then
					if p8:HasBlockedPlayer(player.UserId) then
						t11[player.UserId] = true
					end

					if p9 and player:HasBlockedPlayer(p8.UserId) then
						RemoteEvent7:FireClient(player, p8.UserId, true)
					end
				end
			end

			RemoteEvent6:FireClient(p8, t11)
		end

		local u111 = false

		p8.BlockListChanged:Connect(function() -- line: 369
			-- upvalues: u111 (ref), scanAndSendBlockList (copy)
			if not u111 then
				scanAndSendBlockList(true)
				u111 = true

				return
			end

			scanAndSendBlockList(false)
		end)

		if p8:GetBlockListInitialized() then
			scanAndSendBlockList(true)
			u111 = true
		end

		return
	end

	local t12 = {}

	for _, player in (Players:GetPlayers()) do
		if p8 ~= player then
			table.insert(t12, player.UserId)
		end
	end

	local ok, result = pcall(function() -- line: 324
		-- upvalues: Url (copy), HttpService (copy), t12 (copy), p8 (copy), HttpRbxApiService (copy)
		local v182 = string.format(Url.APIS_URL .. "user-blocking-api/v1/users/rcc/batch-check-reciprocal-block")
		local json = HttpService:JSONEncode({
			userIds = t12,
			requesterUserId = p8.UserId
		})
		local v184 = HttpRbxApiService:PostAsyncFullUrl(v182, json)

		return HttpService:JSONDecode(v184)
	end)
	local t13 = {}
	local t14 = {}

	if ok and result then
		for _, v120 in result.users do
			if v120.isBlocked then
				t14[v120.userId] = true
				table.insert(t13, v120.userId)
			end

			if v120.isBlockingViewer then
				local PlayerByUserId = Players:GetPlayerByUserId(v120.userId)

				PlayerByUserId:UpdatePlayerBlocked(p8.UserId, true)
				RemoteEvent7:FireClient(PlayerByUserId, p8.UserId, true)
			end
		end
	end

	p8:AddToBlockList(t13)

	if game:GetFastFlag("EnableSetUserBlocklistInitialized") then
		p8:SetBlockListInitialized()
	end

	RemoteEvent6:FireClient(p8, t14)
end
local function sendPlayerAllInExperienceNameEnabled(p10) -- line: 419
	-- upvalues: t5 (copy), RemoteEvent8 (copy)
	for k, v in pairs(t5) do
		RemoteEvent8:FireClient(p10, k, {
			isInExperienceNameEnabled = v
		})
	end
end
local function v64(p11) -- line: 440
	-- upvalues: FStringRccInExperienceNameEnabledAllowList (copy), v27 (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy), t5 (copy), RemoteEvent8 (copy)
	if p11.UserId <= 0 then
		return
	end

	local v127 = false

	if FStringRccInExperienceNameEnabledAllowList.isAllowListedUserId(p11.UserId) or v27 then
		local ok, result = pcall(function() -- line: 430
			-- upvalues: p11 (copy), Url (copy), HttpRbxApiService (copy), HttpService (copy)
			local v188 = `user-profile-api/v1/user/profiles/rcc/settings?userId={ p11.UserId }`
			local v189 = Url.APIS_URL .. v188
			local AsyncFullUrl = HttpRbxApiService:GetAsyncFullUrl(v189, Enum.ThrottlingPriority.Default, Enum.HttpRequestType.Players)

			return HttpService:JSONDecode(AsyncFullUrl)
		end)

		if ok and result then
			v127 = result.isSettingsEnabled and (result.userProfileSettings and result.userProfileSettings.isInExperienceNameEnabled)
		end
	end

	local str = tostring(p11.UserId)

	t5[str] = v127
	RemoteEvent8:FireAllClients(str, {
		isInExperienceNameEnabled = v127
	})
end

if FFlagInExperienceRequestProfileSettings then
	RemoteEvent9.OnServerEvent:Connect(function(player) -- line: 467
		-- upvalues: t5 (copy), RemoteEvent8 (copy), v64 (copy)
		local str = tostring(player.UserId)
		local v133 = t5[str]

		if v133 ~= nil then
			RemoteEvent8:FireClient(player, str, {
				isInExperienceNameEnabled = v133
			})

			return
		end

		coroutine.wrap(v64)(player)
	end)
end

local function canCreatePartyNudge(p12) -- line: 506
	if not p12 then
		return false
	end

	local t15 = {
		Windows = true,
		iOS = true,
		Android = true,
		OSX = true,
		Win32 = true,
		Windows_Universal = true
	}

	return p12.PartyId == "" and (p12.VRDevice == "" and (typeof(p12.OsPlatform) == "string" and t15[p12.OsPlatform]))
end
local function v66(p13) -- line: 528
	-- upvalues: Players (copy), v15 (copy), canCreatePartyNudge (copy), Url (copy), HttpService (copy), v16 (copy), v30 (copy), HttpRbxApiService (copy), RemoteEvent13 (copy), RemoteEvent11 (ref), RemoteEvent12 (ref)
	local v140 = nil
	local players = Players:GetPlayers()

	for _, v143 in players do
		if v143.UserId == p13.FollowUserId then
			v140 = v143

			break
		end
	end

	local v144 = false

	if v15 and canCreatePartyNudge(v140) and canCreatePartyNudge(p13) then
		local UserId = p13.UserId
		local UserId2 = v140.UserId
		local s1 = "OneToOneNudgeInExperience"
		local result

		v144, result = pcall(function() -- line: 485
			-- upvalues: Url (copy), HttpService (copy), UserId (copy), UserId2 (copy), s1 (copy), v16 (copy), v30 (copy), HttpRbxApiService (copy)
			local v194 = string.format(Url.APIS_URL .. "group-up/v1/create-party-nudge")
			local json = HttpService:JSONEncode({
				inviterId = UserId,
				inviteeId = UserId2,
				nudgeType = s1,
				placeId = game.PlaceId,
				gameInstanceId = game.JobId,
				universeId = game.GameId,
				version = if not v16 then nil else 1,
				privateServerId = if not v30 then nil else game.PrivateServerId,
				privateServerOwnerId = if not v30 then nil else game.PrivateServerOwnerId
			})
			local v196 = HttpRbxApiService:PostAsyncFullUrl(v194, json)

			return HttpService:JSONDecode(v196)
		end)

		if v144 and result and result.shouldAutoCreateOrJoinGroupUp then
			RemoteEvent13:FireClient(p13, "PartyNudge", result.nudge)
		end
	end

	if not v144 and #players > 0 then
		if v140 then
			RemoteEvent11:FireClient(v140, p13)
		end

		RemoteEvent12:FireClient(p13)
	end
end
local function onPlayerAdded(p14) -- line: 558
	-- upvalues: sendPlayerBlockList (copy), RemoteEvent4 (copy), t3 (copy), getPlayerGroupDetails (copy), FFlagInExperienceUserProfileSettingsEnabled (copy), sendPlayerAllInExperienceNameEnabled (copy), v64 (copy), sendPlayerAllCanManage (copy), getPlayerCanManage (copy), sendCanChatWith (copy), FFlagEnablePartyNudgeAfterJoin (copy), v66 (copy)
	coroutine.wrap(sendPlayerBlockList)(p14)
	RemoteEvent4:FireClient(p14, t3)

	if p14.UserId > 0 then
		coroutine.wrap(getPlayerGroupDetails)(p14)
	end

	if FFlagInExperienceUserProfileSettingsEnabled then
		sendPlayerAllInExperienceNameEnabled(p14)
		coroutine.wrap(v64)(p14)
	end

	sendPlayerAllCanManage(p14)
	coroutine.wrap(getPlayerCanManage)(p14)
	sendCanChatWith(p14)

	if FFlagEnablePartyNudgeAfterJoin then
		coroutine.wrap(v66)(p14)
	end
end

RemoteEvent2.OnServerEvent:Connect(function(player, p15) -- line: 579
	-- upvalues: verifyBlockList (copy)
	if game:GetFastFlag("EnableSetUserBlocklistInitialized") then
		player:SetBlockListInitialized()
	end

	if type(p15) == "table" and verifyBlockList(p15) then
		player:AddToBlockList(p15)
	end
end)
RemoteEvent3.OnServerEvent:Connect(function(player, p16, p17) -- line: 590
	if type(p17) == "boolean" and type(p16) == "number" then
		player:UpdatePlayerBlocked(p16, p17)
	end
end)

if FFlagBadgeVisibilitySettingEnabled then
	RemoteEvent10.OnServerEvent:Connect(function(player, p18) -- line: 599
		-- upvalues: v23 (copy), t7 (copy), v26 (copy), v25 (copy), t6 (copy), v24 (copy), t5 (copy), RemoteEvent8 (copy)
		if type(p18) ~= "table" then
			return
		end

		local t16 = {}

		if type(p18.isInExperienceNameEnabled) == "boolean" then
			t16.isInExperienceNameEnabled = p18.isInExperienceNameEnabled

			local str = tostring(player.UserId)
			local timestamp = tick()

			if v23 then
				if not t7[str] then
					t7[str] = {}
				end

				local v160 = t7[str]
				local v161 = timestamp - v26

				for i = #v160, 1, -1 do
					if v161 > v160[i] then
						table.remove(v160, i)
					end
				end

				if #v160 >= v25 then
					return
				end

				table.insert(v160, timestamp)
			else
				local v163 = t6[str]

				if v163 and timestamp - v163 < v24 then
					return
				end

				t6[str] = timestamp
			end

			t5[str] = t16.isInExperienceNameEnabled
			RemoteEvent8:FireAllClients(str, t16)

			return
		end
	end)
end

if FFlagEnableModerateChatRemoteEvent then
	RemoteEvent14.OnServerEvent:Connect(function(player, p19) -- line: 647
		-- upvalues: TextChatService (copy), RemoteEvent14 (ref)
		if typeof(p19) == "boolean" and TextChatService:setModerationModeEnabled(player.UserId, p19) then
			RemoteEvent14:FireClient(player, p19)
		end
	end)
end

if FFlagEnableSummarySystemMessageOnLua or FFlagAIRephraseSettingEnabled or FFlagChatSummariesSettingEnabled then
	TextChatService.ExpChatFeatureValueChanged:Connect(function(n1: number, s2: string, s3: string) -- line: 657
		-- upvalues: Players (copy), RemoteEvent15 (ref)
		local PlayerByUserId = Players:GetPlayerByUserId(n1)

		if PlayerByUserId then
			RemoteEvent15:FireClient(PlayerByUserId, n1, s2, s3)
		end
	end)
end

Players.PlayerAdded:connect(onPlayerAdded)

for _, player in pairs(Players:GetPlayers()) do
	onPlayerAdded(player)
end

Players.PlayerRemoving:connect(function(p20) -- line: 671
	-- upvalues: t1 (copy), t8 (copy), t3 (copy), t4 (copy), t5 (copy), FFlagBadgeVisibilitySettingEnabled (copy), v23 (copy), t7 (copy), t6 (copy)
	local str = tostring(p20.UserId)

	if t1[str] then
		t1[str] = nil
		t8[str] = nil
	end

	if t3[str] then
		t3[str] = nil
	end

	if t4[str] ~= nil then
		t4[str] = nil
	end

	if t5[str] ~= nil then
		t5[str] = nil
	end

	if FFlagBadgeVisibilitySettingEnabled then
		if v23 then
			if t7[str] ~= nil then
				t7[str] = nil

				return
			end
		elseif t6[str] ~= nil then
			t6[str] = nil
		end
	end
end)

for _, child in ipairs(RobloxReplicatedStorage:GetChildren()) do
	if child:IsA("RemoteEvent") then
		child.OnServerEvent:Connect(function() -- line: 699
		end)
	end
end
