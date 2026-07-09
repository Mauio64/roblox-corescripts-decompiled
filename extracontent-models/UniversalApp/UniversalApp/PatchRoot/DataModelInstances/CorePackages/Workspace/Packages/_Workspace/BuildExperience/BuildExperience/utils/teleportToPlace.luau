local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")
local playtestTeleportRemote = require(script.Parent.playtestTeleportRemote)
local u3 = nil

local function getRemote() -- line: 11
	-- upvalues: u3 (ref), RobloxReplicatedStorage (copy), playtestTeleportRemote (copy)
	if u3 ~= nil then
		return u3
	end

	local playtestTeleportRemoteREMOTE_NAME = RobloxReplicatedStorage:WaitForChild(playtestTeleportRemote.REMOTE_NAME, 1e999)

	u3 = playtestTeleportRemoteREMOTE_NAME

	return playtestTeleportRemoteREMOTE_NAME
end
local function teleportToPlace(n1: number) -- line: 21
	-- upvalues: u3 (ref), RobloxReplicatedStorage (copy), playtestTeleportRemote (copy)
	local v8

	if u3 ~= nil then
		v8 = u3
	else
		v8 = RobloxReplicatedStorage:WaitForChild(playtestTeleportRemote.REMOTE_NAME, 1e999)
		u3 = v8
	end

	v8:FireServer(n1)
end

return teleportToPlace
