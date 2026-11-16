local CorePackages = game:GetService("CorePackages")
local HttpRbxApiService = game:GetService("HttpRbxApiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")

local CoreScriptsCommon = require(CorePackages.Workspace.Packages.CoreScriptsCommon)
local Url = CoreScriptsCommon.Url

local v = {}
local rootPlaceId = nil

local teleportToPurchasedVIPServer = Instance.new("RemoteEvent")
teleportToPurchasedVIPServer.Name = "TeleportToPurchasedVIPServer"
teleportToPurchasedVIPServer.Parent = RobloxReplicatedStorage

local function getRootPlaceId()
	if rootPlaceId ~= nil then
		return rootPlaceId
	end

	local jsonDecode = HttpService:JSONDecode((HttpRbxApiService:GetAsyncFullUrl(
		`{Url.DEVELOP_URL}v1/universes/{game.GameId}`,
		Enum.ThrottlingPriority.Default,
		Enum.HttpRequestType.Default
	)))

	if typeof(jsonDecode) ~= "table" or typeof(jsonDecode.rootPlaceId) ~= "number" then
		error("The universe response has no root place")
	end

	rootPlaceId = jsonDecode.rootPlaceId

	return rootPlaceId
end

Players.PlayerRemoving:Connect(function(player)
	v[player.UserId] = nil
end)

teleportToPurchasedVIPServer.OnServerEvent:Connect(function(player, vipServerId)
	local v2 = (v[player.UserId] or 0) + 1
	v[player.UserId] = v2

	if v2 > 3 or typeof(vipServerId) ~= "string" or #vipServerId == 0 or #vipServerId > 64 then
		teleportToPurchasedVIPServer:FireClient(player)
	elseif not pcall(function()
		local teleportOptions = Instance.new("TeleportOptions")
		teleportOptions.VipServerId = vipServerId
		TeleportService:TeleportAsync(getRootPlaceId(), { player }, teleportOptions)
	end) then
		teleportToPurchasedVIPServer:FireClient(player)
	end
end)
