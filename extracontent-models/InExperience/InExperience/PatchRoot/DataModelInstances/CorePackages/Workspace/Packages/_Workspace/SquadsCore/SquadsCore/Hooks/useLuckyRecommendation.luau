local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local React = require(SquadsCoreParent.React)
local Signals = require(SquadsCoreParent.Signals)
local GetLuckyRecommendationStore = require(SquadsCore.Stores.GetLuckyRecommendationStore)

local function useLuckyRecommendation() -- line: 9
	-- upvalues: GetLuckyRecommendationStore (copy), React (copy), Signals (copy)
	local v7 = GetLuckyRecommendationStore(false)
	local v8, v9 = React.useState(function() -- line: 12
		-- upvalues: v7 (copy)
		return v7.getState(false)
	end)

	React.useLayoutEffect(function() -- line: 16
		-- upvalues: Signals (copy), v9 (copy), v7 (copy)
		return Signals.createEffect(function(p1) -- line: 17
			-- upvalues: v9 (copy), v7 (copy)
			v9(v7.getState(p1))
		end)
	end, { v7.getState })

	local v10 = React.useMemo(function() -- line: 22
		-- upvalues: v7 (copy)
		return {
			startRoll = v7.startRoll,
			endRoll = v7.endRoll,
			cancelFetch = v7.cancelFetch
		}
	end, {
		v7.startRoll,
		v7.endRoll,
		v7.cancelFetch
	})

	return {
		state = v8,
		actions = v10
	}
end

return useLuckyRecommendation
