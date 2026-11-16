local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local GetLuckyRecommendationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetLuckyRecommendationStore")

local function useLuckyRecommendation()
	local v5 = GetLuckyRecommendationStore(false)

	local state, setState = React.useState(function()
		return v5.getState(false)
	end)

	React.useLayoutEffect(function()
		return Signals.createEffect(function(p2)
			setState(v5.getState(p2))
		end)
	end, { v5.getState })

	return {
		state = state,
		actions = React.useMemo(function()
			return {
				startRoll = v5.startRoll,
				endRoll = v5.endRoll,
				cancelFetch = v5.cancelFetch
			}
		end, { v5.startRoll, v5.endRoll, v5.cancelFetch })
	}
end

return useLuckyRecommendation
