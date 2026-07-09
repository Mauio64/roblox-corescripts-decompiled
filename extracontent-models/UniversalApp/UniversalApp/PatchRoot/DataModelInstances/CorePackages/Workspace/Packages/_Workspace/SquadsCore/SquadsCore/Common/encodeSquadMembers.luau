local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Cryo = require(SquadsCoreParent.Cryo)
local encodeUserIds = require(SquadsCore.Common.encodeUserIds)

local function encodeSquadMembers(p1) -- line: 8
	-- upvalues: Cryo (copy), encodeUserIds (copy)
	local v7 = Cryo.List.map(p1 or {}, function(p2) -- line: 9
		return p2.userId
	end)

	return encodeUserIds(v7)
end

return encodeSquadMembers
