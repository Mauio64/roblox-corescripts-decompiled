local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/RoactUtils").Hooks.RoactRodux.useSelector
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/tutils")
local Players = game:GetService("Players")
local UserLib = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceInspectAndBuy/UserLib")

local function selectPlayer(p2)
	return { playerName = p2.playerName, playerId = p2.playerId }
end

return function()
	local v5 = useSelector(selectPlayer, tutils.deepEqual)
	local playerName = if v5 then v5.playerName else nil
	local playerId = if v5 then tonumber(v5.playerId) else nil
	local playerByUserId = playerId and Players:GetPlayerByUserId(playerId)
	local v6 = if playerByUserId then UserLib.Utils.isPlayerVerified(playerByUserId) else false

	return { playerName = playerName, playerId = playerId, hasVerifiedBadge = v6 }
end
