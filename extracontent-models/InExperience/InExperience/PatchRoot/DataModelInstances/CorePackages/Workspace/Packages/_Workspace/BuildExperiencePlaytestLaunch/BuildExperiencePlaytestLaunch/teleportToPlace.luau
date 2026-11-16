local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local playtestTeleportRemote = require(script.Parent.playtestTeleportRemote)

local v = nil

local function getRemote() -- 1 equivalent call inferred from this helper
	if v ~= nil then
		return v
	end

	local child = RobloxReplicatedStorage:WaitForChild(playtestTeleportRemote.REMOTE_NAME, 1e999)
	v = child
	return child
end

local function teleportToPlace(p: number)
	getRemote():FireServer(p) -- inferred equivalent call
end

return teleportToPlace
