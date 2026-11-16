local RobloxReplicatedStorage = game:GetService("RobloxReplicatedStorage")

local playtestTeleportRemote = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/playtestTeleportRemote")

local v5 = nil

local function getRemote()
	if v5 ~= nil then
		return v5
	end

	local child = RobloxReplicatedStorage:WaitForChild(playtestTeleportRemote.REMOTE_NAME, 1e999)
	v5 = child
	return child
end

local function teleportToPlace(p2)
	local v6

	if v5 == nil then
		v6 = RobloxReplicatedStorage:WaitForChild(playtestTeleportRemote.REMOTE_NAME, 1e999)
		v5 = v6
	else
		v6 = v5
	end

	v6:FireServer(p2)
end

return teleportToPlace
