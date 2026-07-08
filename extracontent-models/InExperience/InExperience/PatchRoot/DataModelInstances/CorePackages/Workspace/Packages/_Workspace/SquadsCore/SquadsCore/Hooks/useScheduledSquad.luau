local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local React = require(SquadsCoreParent.React)
local Signals = require(SquadsCoreParent.Signals)
local GetScheduledSquadsStore = require(SquadsCore.Stores.GetScheduledSquadsStore)

require(SquadsCore.Types)

local function useScheduledSquad(n1: number) -- line: 12
	-- upvalues: GetScheduledSquadsStore (copy), React (copy), Signals (copy)
	local v8 = GetScheduledSquadsStore(false)
	local v9 = React.useMemo(function() -- line: 15
		-- upvalues: Signals (copy), v8 (copy), n1 (copy)
		return Signals.createComputed(function(p1) -- line: 16
			-- upvalues: v8 (copy), n1 (copy)
			return v8.getScheduledSquadsStatus(p1)[n1]
		end)
	end, {
		v8,
		n1
	})
	local v10, v11 = React.useState(function() -- line: 21
		-- upvalues: v9 (copy)
		return v9(false)
	end)

	React.useLayoutEffect(function() -- line: 25
		-- upvalues: v11 (copy), v9 (copy), Signals (copy)
		v11(v9(false))

		return Signals.createEffect(function(p2) -- line: 27
			-- upvalues: v11 (copy), v9 (copy)
			v11(v9(p2))
		end)
	end, { v9 })

	return v10
end

return useScheduledSquad
