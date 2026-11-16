local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RunService = game:GetService("RunService")

if not RunService:IsStudio() then
	return
end

local function ensureRemote(name: string) -- 1 equivalent call inferred from this helper
	local remoteEvent = RobloxReplicatedStorage:FindFirstChild(name)

	if remoteEvent and remoteEvent:IsA("RemoteEvent") then
		return remoteEvent
	end

	local remoteEvent2 = Instance.new("RemoteEvent")
	remoteEvent2.Name = name
	remoteEvent2.Parent = RobloxReplicatedStorage
	return remoteEvent2
end

local function waitForBindable(childName: string) -- 3 equivalent calls inferred from this helper
	local bindableEvent = ReplicatedStorage:WaitForChild(childName, 5)

	if bindableEvent == nil or not bindableEvent:IsA("BindableEvent") then
		return nil
	end

	return bindableEvent
end

local PlatformLeaderboardPush = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardPush")

if not (PlatformLeaderboardPush and PlatformLeaderboardPush:IsA("RemoteEvent")) then
	PlatformLeaderboardPush = Instance.new("RemoteEvent")
	PlatformLeaderboardPush.Name = "PlatformLeaderboardPush"
	PlatformLeaderboardPush.Parent = RobloxReplicatedStorage
end

local PlatformLeaderboardTabOpened = RobloxReplicatedStorage:FindFirstChild("PlatformLeaderboardTabOpened")

if not (PlatformLeaderboardTabOpened and PlatformLeaderboardTabOpened:IsA("RemoteEvent")) then
	PlatformLeaderboardTabOpened = Instance.new("RemoteEvent")
	PlatformLeaderboardTabOpened.Name = "PlatformLeaderboardTabOpened"
	PlatformLeaderboardTabOpened.Parent = RobloxReplicatedStorage
end

ensureRemote("PlatformLeaderboardTabClosed") -- inferred equivalent call
local platformLeaderboardMockPushToAll = waitForBindable("PlatformLeaderboardMockPushToAll") -- inferred equivalent call

if platformLeaderboardMockPushToAll == nil then
	return
end

local platformLeaderboardMockPushToPlayer = waitForBindable("PlatformLeaderboardMockPushToPlayer") -- inferred equivalent call
local platformLeaderboardMockTabOpened = waitForBindable("PlatformLeaderboardMockTabOpened") -- inferred equivalent call

if platformLeaderboardMockPushToPlayer == nil or platformLeaderboardMockTabOpened == nil then
	return
end

platformLeaderboardMockPushToAll.Event:Connect(function(p)
	PlatformLeaderboardPush:FireAllClients(p)
end)

platformLeaderboardMockPushToPlayer.Event:Connect(function(player, p)
	if typeof(player) == "Instance" and player:IsA("Player") then
		PlatformLeaderboardPush:FireClient(player, p)
	end
end)

PlatformLeaderboardTabOpened.OnServerEvent:Connect(function(p, p2)
	platformLeaderboardMockTabOpened:Fire(p, p2)
end)
