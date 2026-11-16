local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local setDialogInUse = Instance.new("RemoteEvent")
setDialogInUse.Name = "SetDialogInUse"
setDialogInUse.Parent = RobloxReplicatedStorage

local v = {}

local function setDialogInUse2(player, dialog, p)
	if typeof(dialog) ~= "Instance" or not dialog:IsA("Dialog") or type(p) ~= "boolean" then
		return
	end

	if typeof(player) ~= "Instance" or not player:IsA("Player") then
		return
	end

	if dialog then
		dialog:SetPlayerIsUsing(player, p)
		v[player] = p and dialog or nil
	end
end

Players.PlayerRemoving:Connect(function(player)
	local v2 = v[player]

	if v2 then
		v2:SetPlayerIsUsing(player, false)
		v[player] = nil
	end
end)

setDialogInUse.OnServerEvent:Connect(setDialogInUse2)
