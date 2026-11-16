local parent = script:FindFirstAncestor("SquadsCore").Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)
local RoduxSquads = require(parent.RoduxSquads)

local useCurrentSquadSelector = RoduxSquads.Hooks.useCurrentSquadSelector

function useCurrentSquadMember(p: number)
	local v = useCurrentSquadSelector()
	local v2 = React.useMemo(function()
		if v then
			return v.members
		end

		return {}
	end, { v })

	return (React.useMemo(function()
		local where = Cryo.List.findWhere(v2, function(p2): boolean
			return p2.userId == p
		end)

		if where then
			return v2[where]
		end

		return nil
	end, { v2, p }))
end

return useCurrentSquadMember
