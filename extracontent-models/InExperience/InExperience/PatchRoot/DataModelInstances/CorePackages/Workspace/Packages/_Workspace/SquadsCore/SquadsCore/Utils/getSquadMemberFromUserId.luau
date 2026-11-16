local parent = script:FindFirstAncestor("SquadsCore").Parent

local Cryo = require(parent.Cryo)
require(parent.RoduxSquads)

local function getSquadMemberFromUserId(p, p2: string)
	local v = p and p.members and Cryo.List.findWhere(p.members, function(p3): boolean
		return p3.userId == p2
	end)

	if v then
		return p.members[v]
	end

	return nil
end

return getSquadMemberFromUserId
