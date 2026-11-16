local parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local tutils = require(parent.tutils)
local Players = game:GetService("Players")
local UserLib = require(parent.UserLib)

local function selectPlayer(p)
	return { playerName = p.playerName, playerId = p.playerId }
end

return function()
	local v = useSelector(selectPlayer, tutils.deepEqual)
	local playerName

	if v then
		playerName = v.playerName
	end

	local playerId

	if v then
		playerId = tonumber(v.playerId)
	end

	local playerByUserId = playerId and Players:GetPlayerByUserId(playerId)
	local hasVerifiedBadge

	if playerByUserId then
		hasVerifiedBadge = UserLib.Utils.isPlayerVerified(playerByUserId)
	else
		hasVerifiedBadge = false
	end

	return { playerName = playerName, playerId = playerId, hasVerifiedBadge = hasVerifiedBadge }
end
