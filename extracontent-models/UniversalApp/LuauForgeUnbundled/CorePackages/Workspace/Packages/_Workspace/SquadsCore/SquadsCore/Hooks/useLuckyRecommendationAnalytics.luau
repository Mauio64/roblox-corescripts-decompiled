local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Cryo")

local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RobloxAppHooks").useLocalUserId

local SquadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Components/SquadExternalContractProvider/SquadExternalContractContext")
local GetLuckyRecommendationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Stores/GetLuckyRecommendationStore")

local function useLuckyRecommendationAnalytics(p2)
	local v5 = GetLuckyRecommendationStore(false)
	local v6 = React.useContext(SquadExternalContractContext)
	local v7 = tonumber(useLocalUserId()) or 0

	return (React.useMemo(function()
		return {
			fire = function(p3, p4)
				local analyticsContext = v5.getAnalyticsContext()
				local joined = {
					luckyRecommendationSessionId = p2,
					localUserId = v7,
					pickRequestId = analyticsContext.pickRequestId,
					revealType = analyticsContext.revealType,
					clientTimestamp = os.time()
				}

				if p4 then
					joined = Cryo.Dictionary.join(joined, p4)
				end

				v6.fireSquadAnalytics(p3, joined)
			end,
			getContext = function()
				return v5.getAnalyticsContext()
			end
		}
	end, { p2, v7, v5.getAnalyticsContext, v6.fireSquadAnalytics }))
end

return useLuckyRecommendationAnalytics
