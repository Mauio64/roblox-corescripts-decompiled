local AssetService = game:GetService("AssetService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local v = nil
local v2 = {}

local buildExperiencePlaytestTeleport = Instance.new("RemoteEvent")
buildExperiencePlaytestTeleport.Name = "BuildExperiencePlaytestTeleport"
buildExperiencePlaytestTeleport.Parent = RobloxReplicatedStorage

Players.PlayerRemoving:Connect(function(player)
	v2[player.UserId] = nil
end)

local function getCurrentExperiencePlaceIds()
	if v ~= nil then
		return v
	end

	local gamePlacesAsync = AssetService:GetGamePlacesAsync()
	local placeIdSet = {}

	while true do
		for _, v3 in gamePlacesAsync:GetCurrentPage() do
			placeIdSet[v3.PlaceId] = true
		end

		if gamePlacesAsync.IsFinished then
			v = placeIdSet
			return placeIdSet
		end

		gamePlacesAsync:AdvanceToNextPageAsync()
	end
end

buildExperiencePlaytestTeleport.OnServerEvent:Connect(function(object, value)
	local v3 = v2[object.UserId]

	if v3 ~= nil and v3 > 5 then
		return
	end

	if v3 == nil then
		v2[object.UserId] = 1
	else
		v2[object.UserId] = v3 + 1
	end

	if
		not object:GetCanManageAsync()
		or (typeof(value) ~= "number" or value <= 0)
		or game.PlaceId ~= value and not getCurrentExperiencePlaceIds()[value]
	then
		return
	end

	local teleportOptions = Instance.new("TeleportOptions")
	teleportOptions.ReservedServerId = HttpService:GenerateGUID(false)
	TeleportService:TeleportAsync(value, { object }, teleportOptions)
end)
