local HttpService = game:GetService("HttpService")

local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/Signals")

local getLuckyRecommendation = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/NetworkRequests").getLuckyRecommendation
local SquadLuckyRecommendationError = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLuckyRecommendationError")
local SquadLuckyRecommendationPhase = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLuckyRecommendationPhase")
local SquadLuckyRecommendationRevealType = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadLuckyRecommendationRevealType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Types")

return function()
	local signal, v5 = Signals.createSignal({ phase = SquadLuckyRecommendationPhase.Idle })

	local v6 = nil
	local v7 = nil

	local function fn(guid, p2)
		if v6 then
			v6()
			v6 = nil
		end

		local v8 = {
			pickRequestId = guid,
			squadId = p2,
			revealType = SquadLuckyRecommendationRevealType.Default,
			result = nil
		}

		v7 = v8
		v5({ phase = SquadLuckyRecommendationPhase.Rolling })

		v6 = getLuckyRecommendation(guid, function(p3)
			v6 = nil
			v8.result = { isSuccess = true, recommendation = p3 }
		end, function(p3)
			v6 = nil
			v8.result = { isSuccess = false, error = p3 }
		end)
	end

	return {
		getState = signal,
		getAnalyticsContext = function()
			local v9 = if v7 then v7.pickRequestId else nil
			local v10 = if v7 then v7.revealType else nil
			return { pickRequestId = v9, revealType = v10 }
		end,
		startRoll = function(p2, p3)
			if p3 and v7 ~= nil and v7.squadId == p2 then
				if signal(false).phase == SquadLuckyRecommendationPhase.Revealed then
					v7.revealType = SquadLuckyRecommendationRevealType.Restored
					return
				end

				if v7.result ~= nil and v7.result.isSuccess then
					v7.revealType = SquadLuckyRecommendationRevealType.Preloaded
					return
				end
			end

			fn(HttpService:GenerateGUID(false), p2)
		end,
		endRoll = function()
			if signal(false).phase ~= SquadLuckyRecommendationPhase.Rolling then
				return
			end

			if v6 then
				v6()
				v6 = nil
			end

			local result = if v7 ~= nil then v7.result else nil

			if result == nil then
				v5({ phase = SquadLuckyRecommendationPhase.Errored, error = SquadLuckyRecommendationError.Timeout })
			elseif result.isSuccess then
				v5({ phase = SquadLuckyRecommendationPhase.Revealed, recommendation = result.recommendation })
			else
				v5({ phase = SquadLuckyRecommendationPhase.Errored, error = result.error })
			end
		end,
		cancelFetch = function()
			if v6 then
				v6()
				v6 = nil
			end
		end
	}
end
