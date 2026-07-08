local AssetService = game:GetService("AssetService")
local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local u5 = nil
local t1 = {}
local RemoteEvent = Instance.new("RemoteEvent")

RemoteEvent.Name = "BuildExperiencePlaytestTeleport"
RemoteEvent.Parent = RobloxReplicatedStorage
Players.PlayerRemoving:Connect(function(player) -- line: 14
	-- upvalues: t1 (copy)
	t1[player.UserId] = nil
end)

local function getCurrentExperiencePlaceIds() -- line: 18
	-- upvalues: u5 (ref), AssetService (copy)
	if u5 ~= nil then
		return u5
	end

	local t2 = {}
	local GamePlacesAsync = AssetService:GetGamePlacesAsync()

	while true do
		for _, v13 in GamePlacesAsync:GetCurrentPage() do
			t2[v13.PlaceId] = true
		end

		if GamePlacesAsync.IsFinished then
			break
		end

		GamePlacesAsync:AdvanceToNextPageAsync()
	end

	u5 = t2

	return t2
end

RemoteEvent.OnServerEvent:Connect(function(player, p1) -- line: 41
	-- upvalues: t1 (copy), getCurrentExperiencePlaceIds (copy), TeleportService (copy)
	local v16 = t1[player.UserId]

	if v16 ~= nil and v16 > 5 then
		return
	end

	if v16 == nil then
		t1[player.UserId] = 1
	else
		t1[player.UserId] = v16 + 1
	end

	if not player:GetCanManageAsync() then
		return
	end

	if typeof(p1) ~= "number" or p1 <= 0 then
		return
	end

	if p1 ~= game.PlaceId and not getCurrentExperiencePlaceIds()[p1] then
		return
	end

	local TeleportOptions = Instance.new("TeleportOptions")

	TeleportOptions.ShouldReserveServer = true
	TeleportService:TeleportAsync(p1, { player }, TeleportOptions)
end)
