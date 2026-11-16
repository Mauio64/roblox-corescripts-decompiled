local parent = script:FindFirstAncestor("BlockingUtility").Parent

local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local Http = require(parent.Http)
local Url = Http.Url

local BlockingUtility = {}
BlockingUtility.__index = BlockingUtility

local updatePlayerBlockList = nil
spawn(function()
	updatePlayerBlockList = RobloxReplicatedStorage:WaitForChild("UpdatePlayerBlockList", 1e999)
end)

local bindableEvent = Instance.new("BindableEvent")
local bindableEvent2 = Instance.new("BindableEvent")
local bindableEvent3 = Instance.new("BindableEvent")

local v = false
local bindableEvent4 = Instance.new("BindableEvent")
local v2 = {}
local v3 = {}

local function getBlockedUserIdsFromBlockedList() -- 1 equivalent call inferred from this helper
	local blockedUserIds = {}

	for k, _ in v2 do
		table.insert(blockedUserIds, k)
	end

	return blockedUserIds
end

local function getBlockedUserIds()
	if not (Players.LocalPlayer.UserId > 0) then
		return {}
	end

	local total = 0

	while not v do
		total += wait()

		if total > 5 then
			return {}
		end
	end

	return getBlockedUserIdsFromBlockedList() -- inferred equivalent call
end

local function isBlocked(p): boolean -- 4 equivalent calls inferred from this helper
	return if v2[p] then true else false
end

local function isMuted(p): boolean -- 1 equivalent call inferred from this helper
	return v3[p] ~= nil and v3[p] == true
end

local function BlockPlayerAsync(p)
	local localPlayer = Players.LocalPlayer

	if not p or localPlayer == p then
		return false
	end

	local userId = p.UserId

	if not (userId > 0) then
		return false
	end

	if isBlocked(userId) then -- inferred equivalent call
		return true
	end

	v2[userId] = true
	bindableEvent:Fire(userId, true)

	local success, result = pcall(function()
		local v4 = HttpRbxApiService:PostAsyncFullUrl(
			Url.APIS_URL .. "user-blocking-api/v1/users/" .. tostring(p.UserId) .. "/block-user",
			""
		)

		if v4 then
			return (HttpService:JSONDecode(v4))
		end
	end)

	if success and result then
		if updatePlayerBlockList then
			updatePlayerBlockList:FireServer(userId, true)
		end

		bindableEvent2:Fire(userId, true)
	else
		v2[userId] = nil
		bindableEvent:Fire(userId, false)
	end

	return success and result
end

local function UnblockPlayerAsync(p)
	if not p then
		return false
	end

	local userId = p.UserId

	if not isBlocked(userId) then -- inferred equivalent call
		return true
	end

	v2[userId] = nil
	bindableEvent:Fire(userId, false)

	local success, result = pcall(function()
		local v4 = HttpRbxApiService:PostAsyncFullUrl(
			Url.APIS_URL .. "user-blocking-api/v1/users/" .. tostring(p.UserId) .. "/unblock-user",
			""
		)

		if not v4 then
			return
		end

		local jsonDecode = HttpService:JSONDecode(v4)
		return jsonDecode and not jsonDecode.errors
	end)

	if success and result then
		if updatePlayerBlockList then
			updatePlayerBlockList:FireServer(userId, false)
		end

		bindableEvent2:Fire(userId, false)
	else
		v2[userId] = true
		bindableEvent:Fire(userId, true)
	end

	return success and result
end

local function AddPlayerToBlockList(p): boolean
	local localPlayer = Players.LocalPlayer

	if not p or localPlayer == p then
		return false
	end

	local userId = p.UserId

	if not (userId > 0) then
		return false
	end

	if v2[userId] then
		return true
	end

	v2[userId] = true
	bindableEvent:Fire(userId, true)

	if updatePlayerBlockList then
		updatePlayerBlockList:FireServer(userId, true)
	end

	if bindableEvent2 then
		bindableEvent2:Fire(userId, true)
	end

	return true
end

local function RemovePlayerFromBlockList(p): boolean
	if not p then
		return false
	end

	local userId = p.UserId

	if not isBlocked(userId) then -- inferred equivalent call
		return true
	end

	v2[userId] = nil
	bindableEvent:Fire(userId, false)

	if updatePlayerBlockList then
		updatePlayerBlockList:FireServer(userId, false)
	end

	if bindableEvent2 then
		bindableEvent2:Fire(userId, false)
	end

	return true
end

local function MutePlayer(p)
	local localPlayer = Players.LocalPlayer

	if p and localPlayer ~= p then
		local userId = p.UserId

		if userId > 0 and (v3[userId] == nil or v3[userId] ~= true) then
			v3[userId] = true
			bindableEvent3:Fire(userId, true)
		end
	end
end

local function UnmutePlayer(p)
	if p then
		local userId = p.UserId
		v3[userId] = nil
		bindableEvent3:Fire(userId, false)
	end
end

local bindableEvent5 = Instance.new("BindableEvent")
local bindableEvent6 = Instance.new("BindableEvent")
local bindableEvent7 = Instance.new("BindableEvent")
local bindableEvent8 = Instance.new("BindableEvent")

local function blockedStatusChanged(p, p2)
	local playerByUserId = Players:GetPlayerByUserId(p)

	if playerByUserId then
		if p2 then
			bindableEvent5:Fire(playerByUserId)
		else
			bindableEvent6:Fire(playerByUserId)
		end
	end
end

bindableEvent.Event:Connect(blockedStatusChanged)

local function muteStatusChanged(p, p2)
	local playerByUserId = Players:GetPlayerByUserId(p)

	if playerByUserId then
		if p2 then
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

		for k, _ in items do
			set[tonumber(k)] = true
		end

		local v4 = v2
		v2 = set
		v = true

		for k in set do
			if not v4[k] then
				bindableEvent:Fire(k, true)
			end
		end

		for k in v4 do
			if not set[k] then
				bindableEvent:Fire(k, false)
			end
		end

		bindableEvent4:Fire()
	end)
end)

task.spawn(function()
	local RobloxReplicatedStorage2 = game:GetService("RobloxReplicatedStorage")

	RobloxReplicatedStorage2:WaitForChild("UpdateLocalPlayerBlockList", 1e999).OnClientEvent:Connect(function(p, p2)
		v2[p] = p2 and true or nil
		bindableEvent:Fire(p, p2)
	end)
end)

function BlockingUtility.BlockPlayerAsync(_, p)
	return BlockPlayerAsync(p)
end

function BlockingUtility.UnblockPlayerAsync(_, p)
	return UnblockPlayerAsync(p)
end

function BlockingUtility.MutePlayer(_, p)
	return MutePlayer(p)
end

function BlockingUtility.UnmutePlayer(_, p)
	return UnmutePlayer(p)
end

function BlockingUtility.IsPlayerBlockedByUserId(_, p)
	return isBlocked(p) -- inferred equivalent call
end

function BlockingUtility.GetBlockedStatusChangedEvent(_)
	return bindableEvent.Event
end

function BlockingUtility.GetAfterBlockedStatusChangedEvent(_)
	return bindableEvent2.Event
end

function BlockingUtility.GetMutedStatusChangedEvent(_)
	return bindableEvent3.Event
end

function BlockingUtility.IsPlayerMutedByUserId(_, p)
	return isMuted(p) -- inferred equivalent call
end

function BlockingUtility.GetBlockedUserIdsAsync(_)
	return (getBlockedUserIds())
end

function BlockingUtility.AddPlayerToBlockList(_, p)
	return AddPlayerToBlockList(p)
end

function BlockingUtility.RemovePlayerFromBlockList(_, p)
	return RemovePlayerFromBlockList(p)
end

return BlockingUtility
