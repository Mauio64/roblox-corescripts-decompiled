local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local React = require(SquadsCoreParent.React)
local Cryo = require(SquadsCoreParent.Cryo)
local useLocalUserId = require(SquadsCoreParent.RobloxAppHooks).useLocalUserId
local SquadExternalContractContext = require(SquadsCore.Components.SquadExternalContractProvider.SquadExternalContractContext)
local GetLuckyRecommendationStore = require(SquadsCore.Stores.GetLuckyRecommendationStore)

local function useLuckyRecommendationAnalytics(s1: string) -- line: 12
	-- upvalues: GetLuckyRecommendationStore (copy), React (copy), SquadExternalContractContext (copy), useLocalUserId (copy), Cryo (copy)
	local v10 = GetLuckyRecommendationStore(false)
	local v11 = React.useContext(SquadExternalContractContext)
	local v12 = tonumber(useLocalUserId()) or 0

	return (React.useMemo(function() -- line: 18
		-- upvalues: v10 (copy), s1 (copy), v12 (copy), Cryo (copy), v11 (copy)
		return {
			fire = function(s2: string, t1: {[any]: any}?) -- line: 20
				-- upvalues: v10 (copy), s1 (copy), v12 (copy), Cryo (copy), v11 (copy)
				local v15 = v10.getAnalyticsContext()
				local t2 = {
					luckyRecommendationSessionId = s1,
					localUserId = v12,
					pickRequestId = v15.pickRequestId,
					revealType = v15.revealType,
					clientTimestamp = os.time()
				}

				if t1 then
					t2 = Cryo.Dictionary.join(t2, t1)
				end

				v11.fireSquadAnalytics(s2, t2)
			end,
			getContext = function() -- line: 34
				-- upvalues: v10 (copy)
				return v10.getAnalyticsContext()
			end
		}
	end, {
		s1,
		v12,
		v10.getAnalyticsContext,
		v11.fireSquadAnalytics
	}))
end

return useLuckyRecommendationAnalytics
