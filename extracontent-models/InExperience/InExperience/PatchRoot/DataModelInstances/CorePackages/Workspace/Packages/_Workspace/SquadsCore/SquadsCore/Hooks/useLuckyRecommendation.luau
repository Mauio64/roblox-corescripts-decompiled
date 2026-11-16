local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local React = require(parent.React)
local Signals = require(parent.Signals)

local GetLuckyRecommendationStore = require(SquadsCore.Stores.GetLuckyRecommendationStore)

local function useLuckyRecommendation()
	local luckyRecommendationStore = GetLuckyRecommendationStore(false)

	local state, setState = React.useState(function()
		return luckyRecommendationStore.getState(false)
	end)

	React.useLayoutEffect(function()
		return Signals.createEffect(function(p)
			setState(luckyRecommendationStore.getState(p))
		end)
	end, { luckyRecommendationStore.getState })

	return {
		state = state,
		actions = React.useMemo(function()
			return {
				startRoll = luckyRecommendationStore.startRoll,
				endRoll = luckyRecommendationStore.endRoll,
				cancelFetch = luckyRecommendationStore.cancelFetch
			}
		end, {
			luckyRecommendationStore.startRoll,
			luckyRecommendationStore.endRoll,
			luckyRecommendationStore.cancelFetch
		})
	}
end

return useLuckyRecommendation
