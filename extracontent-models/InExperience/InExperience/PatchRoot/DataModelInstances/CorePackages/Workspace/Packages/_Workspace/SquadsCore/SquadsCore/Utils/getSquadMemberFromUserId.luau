local Parent = script:FindFirstAncestor("SquadsCore").Parent
local Cryo = require(Parent.Cryo)

require(Parent.RoduxSquads)

local function getSquadMemberFromUserId(p1, s1: string) -- line: 18
	-- upvalues: Cryo (copy)
	if p1 and p1.members then
		local v6 = Cryo.List.findWhere(p1.members, function(p2) -- line: 20
			-- upvalues: s1 (copy)
			return p2.userId == s1
		end)

		if v6 then
			return p1.members[v6]
		end
	end

	return nil
end

return getSquadMemberFromUserId
