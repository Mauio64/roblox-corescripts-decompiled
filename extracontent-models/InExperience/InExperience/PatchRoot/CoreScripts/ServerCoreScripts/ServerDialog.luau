local Players = game:GetService("Players")
local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local RemoteEvent = Instance.new("RemoteEvent")

RemoteEvent.Name = "SetDialogInUse"
RemoteEvent.Parent = RobloxReplicatedStorage

local t1 = {}

local function setDialogInUse(p1, p2, p3) -- line: 10
	-- upvalues: t1 (copy)
	if typeof(p2) ~= "Instance" or not p2:IsA("Dialog") then
		return
	end

	if type(p3) ~= "boolean" then
		return
	end

	if typeof(p1) ~= "Instance" or not p1:IsA("Player") then
		return
	end

	if p2 then
		p2:SetPlayerIsUsing(p1, p3)
		t1[p1] = p3 and p2 or nil
	end
end

Players.PlayerRemoving:Connect(function(player) -- line: 29
	-- upvalues: t1 (copy)
	local v10 = t1[player]

	if v10 then
		v10:SetPlayerIsUsing(player, false)
		t1[player] = nil
	end
end)
RemoteEvent.OnServerEvent:Connect(setDialogInUse)
