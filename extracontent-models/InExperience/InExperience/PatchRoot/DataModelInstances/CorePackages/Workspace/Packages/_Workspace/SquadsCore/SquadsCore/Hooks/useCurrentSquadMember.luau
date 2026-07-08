local Parent = script:FindFirstAncestor("SquadsCore").Parent
local React = require(Parent.React)
local Cryo = require(Parent.Cryo)
local useCurrentSquadSelector = require(Parent.RoduxSquads).Hooks.useCurrentSquadSelector

function useCurrentSquadMember(n1: number) -- line: 12
	-- upvalues: useCurrentSquadSelector (copy), React (copy), Cryo (copy)
	local v6 = useCurrentSquadSelector()
	local v7 = React.useMemo(function() -- line: 14
		-- upvalues: v6 (copy)
		if v6 then
			return v6.members
		end

		return {}
	end, { v6 })

	return (React.useMemo(function() -- line: 21
		-- upvalues: Cryo (copy), v7 (copy), n1 (copy)
		local v8 = Cryo.List.findWhere(v7, function(p1) -- line: 22
			-- upvalues: n1 (copy)
			return p1.userId == n1
		end)

		if v8 then
			return v7[v8]
		end

		return nil
	end, {
		v7,
		n1
	}))
end

return useCurrentSquadMember
