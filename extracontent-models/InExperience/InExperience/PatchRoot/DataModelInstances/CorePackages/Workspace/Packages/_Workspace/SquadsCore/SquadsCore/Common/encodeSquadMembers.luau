local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Cryo = require(parent.Cryo)

local encodeUserIds = require(SquadsCore.Common.encodeUserIds)

local function encodeSquadMembers(options)
	return encodeUserIds((Cryo.List.map(options or {}, function(p)
		return p.userId
	end)))
end

return encodeSquadMembers
