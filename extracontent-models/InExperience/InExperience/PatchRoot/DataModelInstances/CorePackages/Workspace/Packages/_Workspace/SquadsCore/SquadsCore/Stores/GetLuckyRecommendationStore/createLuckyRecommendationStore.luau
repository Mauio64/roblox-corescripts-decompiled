local HttpService = game:GetService("HttpService")

local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local Signals = require(parent.Signals)

local NetworkRequests = require(SquadsCore.NetworkRequests)
local getLuckyRecommendation = NetworkRequests.getLuckyRecommendation
local SquadLuckyRecommendationError = require(SquadsCore.Enums.SquadLuckyRecommendationError)
local SquadLuckyRecommendationPhase = require(SquadsCore.Enums.SquadLuckyRecommendationPhase)
local SquadLuckyRecommendationRevealType = require(SquadsCore.Enums.SquadLuckyRecommendationRevealType)
require(SquadsCore.Types)

return function()
	local signal, v = Signals.createSignal({ phase = SquadLuckyRecommendationPhase.Idle })

	local v2 = nil
	local v3 = nil

	local function fn(guid: string, squadId: string)
		if v2 then
			v2()
			v2 = nil
		end

		local v4 = {
			pickRequestId = guid,
			squadId = squadId,
			revealType = SquadLuckyRecommendationRevealType.Default,
			result = nil
		}

		v3 = v4
		v({ phase = SquadLuckyRecommendationPhase.Rolling })

		v2 = getLuckyRecommendation(guid, function(recommendation)
			v2 = nil
			v4.result = { isSuccess = true, recommendation = recommendation }
		end, function(err)
			v2 = nil
			v4.result = { isSuccess = false, error = err }
		end)
	end

	return {
		getState = signal,
		getAnalyticsContext = function()
			local pickRequestId

			if v3 then
				pickRequestId = v3.pickRequestId
			end

			local revealType

			if v3 then
				revealType = v3.revealType
			end

			return { pickRequestId = pickRequestId, revealType = revealType }
		end,
		startRoll = function(squadId: string, flag: boolean?)
			if flag and v3 ~= nil and v3.squadId == squadId then
				if signal(false).phase == SquadLuckyRecommendationPhase.Revealed then
					v3.revealType = SquadLuckyRecommendationRevealType.Restored
					return
				end

				if v3.result ~= nil and v3.result.isSuccess then
					v3.revealType = SquadLuckyRecommendationRevealType.Preloaded
					return
				end
			end

			fn(HttpService:GenerateGUID(false), squadId)
		end,
		endRoll = function()
			if signal(false).phase ~= SquadLuckyRecommendationPhase.Rolling then
				return
			end

			if v2 then
				v2()
				v2 = nil
			end

			local result

			if v3 ~= nil then
				result = v3.result
			end

			if result == nil then
				v({
					phase = SquadLuckyRecommendationPhase.Errored,
					error = SquadLuckyRecommendationError.Timeout
				})
			elseif result.isSuccess then
				v({
					phase = SquadLuckyRecommendationPhase.Revealed,
					recommendation = result.recommendation
				})
			else
				v({ phase = SquadLuckyRecommendationPhase.Errored, error = result.error })
			end
		end,
		cancelFetch = function()
			if v2 then
				v2()
				v2 = nil
			end
		end
	}
end
