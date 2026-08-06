local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Signals = require(SquadsCoreParent.Signals)
local getLuckyRecommendation = require(SquadsCore.NetworkRequests).getLuckyRecommendation
local SquadLuckyRecommendationError = require(SquadsCore.Enums.SquadLuckyRecommendationError)
local SquadLuckyRecommendationPhase = require(SquadsCore.Enums.SquadLuckyRecommendationPhase)
local SquadLuckyRecommendationRevealType = require(SquadsCore.Enums.SquadLuckyRecommendationRevealType)

require(SquadsCore.Types)

return function() -- line: 46
	-- upvalues: Signals (copy), SquadLuckyRecommendationPhase (copy), SquadLuckyRecommendationRevealType (copy), getLuckyRecommendation (copy), HttpService (copy), SquadLuckyRecommendationError (copy)
	local v9, v10 = Signals.createSignal({
		phase = SquadLuckyRecommendationPhase.Idle
	})
	local u11 = nil
	local u12 = nil

	local function v13(s1: string, s2: string) -- line: 60
		-- upvalues: u11 (ref), SquadLuckyRecommendationRevealType (copy), u12 (ref), v10 (copy), SquadLuckyRecommendationPhase (copy), getLuckyRecommendation (copy)
		if u11 then
			u11()
			u11 = nil
		end

		local t1 = {
			result = nil,
			pickRequestId = s1,
			squadId = s2,
			revealType = SquadLuckyRecommendationRevealType.Default
		}

		u12 = t1
		v10({
			phase = SquadLuckyRecommendationPhase.Rolling
		})
		u11 = getLuckyRecommendation(s1, function(p1) -- line: 71
			-- upvalues: u11 (ref), t1 (copy)
			u11 = nil
			t1.result = {
				isSuccess = true,
				recommendation = p1
			}
		end, function(p2) -- line: 74
			-- upvalues: u11 (ref), t1 (copy)
			u11 = nil
			t1.result = {
				isSuccess = false,
				error = p2
			}
		end)
	end

	return {
		getState = v9,
		getAnalyticsContext = function() -- line: 119
			-- upvalues: u12 (ref)
			return {
				pickRequestId = if not u12 then nil else u12.pickRequestId,
				revealType = if not u12 then nil else u12.revealType
			}
		end,
		startRoll = function(s3: string, b1: boolean?) -- line: 80
			-- upvalues: u12 (ref), v9 (copy), SquadLuckyRecommendationPhase (copy), SquadLuckyRecommendationRevealType (copy), HttpService (copy), v13 (copy)
			if b1 and (u12 ~= nil and s3 == u12.squadId) then
				if v9(false).phase == SquadLuckyRecommendationPhase.Revealed then
					u12.revealType = SquadLuckyRecommendationRevealType.Restored

					return
				end

				if u12.result ~= nil and u12.result.isSuccess then
					u12.revealType = SquadLuckyRecommendationRevealType.Preloaded

					return
				end
			end

			local guid = HttpService:GenerateGUID(false)

			v13(guid, s3)
		end,
		endRoll = function() -- line: 95
			-- upvalues: v9 (copy), SquadLuckyRecommendationPhase (copy), u11 (ref), u12 (ref), v10 (copy), SquadLuckyRecommendationError (copy)
			if v9(false).phase ~= SquadLuckyRecommendationPhase.Rolling then
				return
			end

			if u11 then
				u11()
				u11 = nil
			end

			local v20 = if u12 == nil then nil else u12.result

			if v20 == nil then
				v10({
					phase = SquadLuckyRecommendationPhase.Errored,
					error = SquadLuckyRecommendationError.Timeout
				})

				return
			end

			if v20.isSuccess then
				v10({
					phase = SquadLuckyRecommendationPhase.Revealed,
					recommendation = v20.recommendation
				})

				return
			end

			v10({
				phase = SquadLuckyRecommendationPhase.Errored,
				error = v20.error
			})
		end,
		cancelFetch = function() -- line: 53
			-- upvalues: u11 (ref)
			if u11 then
				u11()
				u11 = nil
			end
		end
	}
end
