local Parent = script:FindFirstAncestor("AvatarExperienceInspectAndBuy").Parent
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector
local tutils = require(Parent.tutils)
local Players = game:GetService("Players")
local UserLib = require(Parent.UserLib)

local function selectPlayer(p1) -- line: 13
	return {
		playerName = p1.playerName,
		playerId = p1.playerId
	}
end

return function() -- line: 26
	-- upvalues: useSelector (copy), selectPlayer (copy), tutils (copy), Players (copy), UserLib (copy)
	local v8 = useSelector(selectPlayer, tutils.deepEqual)
	local v9 = if not v8 then nil else v8.playerName
	local v10 = if not v8 then nil else tonumber(v8.playerId)
	local v11 = v10 and Players:GetPlayerByUserId(v10)
	local v12 = not not v11 and UserLib.Utils.isPlayerVerified(v11)

	return {
		playerName = v9,
		playerId = v10,
		hasVerifiedBadge = v12
	}
end
