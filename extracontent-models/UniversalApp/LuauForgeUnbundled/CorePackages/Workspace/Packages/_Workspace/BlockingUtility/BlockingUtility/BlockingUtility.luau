local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/BlockingUtility/Http").Url

local v5 = {}
v5.__index = v5

local updatePlayerBlockList = nil
spawn(function()
	updatePlayerBlockList = RobloxReplicatedStorage:WaitForChild("UpdatePlayerBlockList", 1e999)
end)

local bindableEvent = Instance.new("BindableEvent")
local bindableEvent2 = Instance.new("BindableEvent")
local bindableEvent3 = Instance.new("BindableEvent")

local v6 = false
local bindableEvent4 = Instance.new("BindableEvent")
local v7 = {}
local v8 = {}

local function getBlockedUserIdsFromBlockedList()
	local blockedUserIds = {}

	for k, v9 in v7 do
		table.insert(blockedUserIds, k)
	end

	return blockedUserIds
end

local function getBlockedUserIds()
	if not (Players.LocalPlayer.UserId > 0) then
		return {}
	end

	local total = 0

	while not v6 do
		total += wait()

		if total > 5 then
			return {}
		end
	end

	local result = {}

	for k, v9 in v7 do
		table.insert(result, k)
	end

	return result
end

local function isBlocked(p2): boolean
	if v7[p2] then
		return true
	end

	return false
end

local function isMuted(p2): boolean
	return v8[p2] ~= nil and v8[p2] == true
end

local function BlockPlayerAsync(p2)
	local localPlayer = Players.LocalPlayer

	if not p2 or localPlayer == p2 then
		return false
	end

	local userId = p2.UserId

	if not (userId > 0) then
		return false
	end

	if v7[userId] then
		return true
	end

	v7[userId] = true
	bindableEvent:Fire(userId, true)

	local success, result = pcall(function()
		local v10 = HttpRbxApiService:PostAsyncFullUrl(
			url.APIS_URL .. "user-blocking-api/v1/users/" .. tostring(p2.UserId) .. "/block-user",
			""
		)

		if v10 then
			return (HttpService:JSONDecode(v10))
		end
	end)

	if success and result then
		if updatePlayerBlockList then
			updatePlayerBlockList:FireServer(userId, true)
		end

		bindableEvent2:Fire(userId, true)
	else
		v7[userId] = nil
		bindableEvent:Fire(userId, false)
	end

	return success and result
end

local function UnblockPlayerAsync(p2)
	if not p2 then
		return false
	end

	local userId = p2.UserId

	if not v7[userId] then
		return true
	end

	v7[userId] = nil
	bindableEvent:Fire(userId, false)

	local success, result = pcall(function()
		local v10 = HttpRbxApiService:PostAsyncFullUrl(
			url.APIS_URL .. "user-blocking-api/v1/users/" .. tostring(p2.UserId) .. "/unblock-user",
			""
		)

		if not v10 then
			return
		end

		local jsonDecode = HttpService:JSONDecode(v10)
		return jsonDecode and not jsonDecode.errors
	end)

	if success and result then
		if updatePlayerBlockList then
			updatePlayerBlockList:FireServer(userId, false)
		end

		bindableEvent2:Fire(userId, false)
	else
		v7[userId] = true
		bindableEvent:Fire(userId, true)
	end

	return success and result
end

local function AddPlayerToBlockList(p2): boolean
	local localPlayer = Players.LocalPlayer

	if not p2 or localPlayer == p2 then
		return false
	end

	local userId = p2.UserId

	if not (userId > 0) then
		return false
	end

	if v7[userId] then
		return true
	end

	v7[userId] = true
	bindableEvent:Fire(userId, true)

	if updatePlayerBlockList then
		updatePlayerBlockList:FireServer(userId, true)
	end

	if bindableEvent2 then
		bindableEvent2:Fire(userId, true)
	end

	return true
end

local function RemovePlayerFromBlockList(p2): boolean
	if not p2 then
		return false
	end

	local userId = p2.UserId

	if not v7[userId] then
		return true
	end

	v7[userId] = nil
	bindableEvent:Fire(userId, false)

	if updatePlayerBlockList then
		updatePlayerBlockList:FireServer(userId, false)
	end

	if bindableEvent2 then
		bindableEvent2:Fire(userId, false)
	end

	return true
end

local function MutePlayer(p2)
	local localPlayer = Players.LocalPlayer

	if p2 and localPlayer ~= p2 then
		local userId = p2.UserId

		if userId > 0 and (v8[userId] == nil or v8[userId] ~= true) then
			v8[userId] = true
			bindableEvent3:Fire(userId, true)
		end
	end
end

local function UnmutePlayer(p2)
	if p2 then
		local userId = p2.UserId
		v8[userId] = nil
		bindableEvent3:Fire(userId, false)
	end
end

local bindableEvent5 = Instance.new("BindableEvent")
local bindableEvent6 = Instance.new("BindableEvent")
local bindableEvent7 = Instance.new("BindableEvent")
local bindableEvent8 = Instance.new("BindableEvent")

local function blockedStatusChanged(p2, p3)
	local playerByUserId = Players:GetPlayerByUserId(p2)

	if playerByUserId then
		if p3 then
			bindableEvent5:Fire(playerByUserId)
		else
			bindableEvent6:Fire(playerByUserId)
		end
	end
end

bindableEvent.Event:Connect(blockedStatusChanged)

local function muteStatusChanged(p2, p3)
	local playerByUserId = Players:GetPlayerByUserId(p2)

	if playerByUserId then
		if p3 then
			bindableEvent7:Fire(playerByUserId)
		else
			bindableEvent8:Fire(playerByUserId)
		end
	end
end

bindableEvent3.Event:Connect(muteStatusChanged)

StarterGui:RegisterGetCore("PlayerBlockedEvent", function()
	return bindableEvent5
end)

StarterGui:RegisterGetCore("PlayerUnblockedEvent", function()
	return bindableEvent6
end)

StarterGui:RegisterGetCore("PlayerMutedEvent", function()
	return bindableEvent7
end)

StarterGui:RegisterGetCore("PlayerUnmutedEvent", function()
	return bindableEvent8
end)

task.spawn(function()
	local RobloxReplicatedStorage2 = game:GetService("RobloxReplicatedStorage")
	RobloxReplicatedStorage2:WaitForChild("SendPlayerBlockList", 1e999).OnClientEvent:Connect(function(items)
		local set = {}

		for k, item in items do
			set[tonumber(k)] = true
		end

		local v9 = v7
		v7 = set
		v6 = true

		for k in set do
			if not v9[k] then
				bindableEvent:Fire(k, true)
			end
		end

		for k in v9 do
			if not set[k] then
				bindableEvent:Fire(k, false)
			end
		end

		bindableEvent4:Fire()
	end)
end)

task.spawn(function()
	local RobloxReplicatedStorage2 = game:GetService("RobloxReplicatedStorage")

	RobloxReplicatedStorage2:WaitForChild("UpdateLocalPlayerBlockList", 1e999).OnClientEvent:Connect(function(p2, p3)
		v7[p2] = p3 and true or nil
		bindableEvent:Fire(p2, p3)
	end)
end)

function v5.BlockPlayerAsync(p2, p3)
	return BlockPlayerAsync(p3)
end

function v5.UnblockPlayerAsync(p2, p3)
	return UnblockPlayerAsync(p3)
end

function v5.MutePlayer(p2, p3)
	return MutePlayer(p3)
end

function v5.UnmutePlayer(p2, p3)
	return UnmutePlayer(p3)
end

function v5.IsPlayerBlockedByUserId(p2, p3): boolean
	if v7[p3] then
		return true
	end

	return false
end

function v5.GetBlockedStatusChangedEvent(p2)
	return bindableEvent.Event
end

function v5:GetAfterBlockedStatusChangedEvent()
	return bindableEvent2.Event
end

function v5.GetMutedStatusChangedEvent(p2)
	return bindableEvent3.Event
end

function v5.IsPlayerMutedByUserId(p2, p3): boolean
	return v8[p3] ~= nil and v8[p3] == true
end

function v5.GetBlockedUserIdsAsync(p2)
	return getBlockedUserIds()
end

function v5:AddPlayerToBlockList(p3)
	return AddPlayerToBlockList(p3)
end

function v5.RemovePlayerFromBlockList(p2, p3)
	return RemovePlayerFromBlockList(p3)
end

return v5
