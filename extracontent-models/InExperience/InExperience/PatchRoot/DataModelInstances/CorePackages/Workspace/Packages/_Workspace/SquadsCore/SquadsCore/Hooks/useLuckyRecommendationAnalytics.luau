local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local React = require(parent.React)
local Cryo = require(parent.Cryo)

local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId

local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local GetLuckyRecommendationStore = require(SquadsCore.Stores.GetLuckyRecommendationStore)

local function useLuckyRecommendationAnalytics(luckyRecommendationSessionId: string)
	local luckyRecommendationStore = GetLuckyRecommendationStore(false)
	local v = React.useContext(SquadExternalContractContext)
	local localUserId = tonumber(useLocalUserId()) or 0

	return (React.useMemo(function()
		return {
			fire = function(p: string, p2)
				local analyticsContext = luckyRecommendationStore.getAnalyticsContext()
				local joined = {
					luckyRecommendationSessionId = luckyRecommendationSessionId,
					localUserId = localUserId,
					pickRequestId = analyticsContext.pickRequestId,
					revealType = analyticsContext.revealType,
					clientTimestamp = os.time()
				}

				if p2 then
					joined = Cryo.Dictionary.join(joined, p2)
				end

				v.fireSquadAnalytics(p, joined)
			end,
			getContext = function()
				return luckyRecommendationStore.getAnalyticsContext()
			end
		}
	end, {
		luckyRecommendationSessionId,
		localUserId,
		luckyRecommendationStore.getAnalyticsContext,
		v.fireSquadAnalytics
	}))
end

return useLuckyRecommendationAnalytics
