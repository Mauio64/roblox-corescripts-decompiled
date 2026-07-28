local HttpService = game:GetService("HttpService")
local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local Signals = require(SquadsCoreParent.Signals)
local getLuckyRecommendation = require(SquadsCore.NetworkRequests).getLuckyRecommendation
local SquadLuckyRecommendationError = require(SquadsCore.Enums.SquadLuckyRecommendationError)
local SquadLuckyRecommendationPhase = require(SquadsCore.Enums.SquadLuckyRecommendationPhase)

require(SquadsCore.Types)

return function() -- line: 26
	-- upvalues: Signals (copy), SquadLuckyRecommendationPhase (copy), getLuckyRecommendation (copy), HttpService (copy), SquadLuckyRecommendationError (copy)
	local v8, v9 = Signals.createSignal({
		phase = SquadLuckyRecommendationPhase.Idle
	})
	local u10 = nil
	local u11 = nil

	local function v12(s1: string) -- line: 41
		-- upvalues: u10 (ref), u11 (ref), v9 (copy), SquadLuckyRecommendationPhase (copy), getLuckyRecommendation (copy), HttpService (copy)
		if u10 then
			u10()
			u10 = nil
		end

		u11 = nil
		v9({
			phase = SquadLuckyRecommendationPhase.Rolling
		})
		u10 = getLuckyRecommendation(HttpService:GenerateGUID(false), function(p1) -- line: 48
			-- upvalues: u10 (ref), u11 (ref), SquadLuckyRecommendationPhase (copy), s1 (copy)
			u10 = nil
			u11 = {
				phase = SquadLuckyRecommendationPhase.Revealed,
				recommendation = p1,
				squadId = s1
			}
		end, function(p2) -- line: 56
			-- upvalues: u10 (ref), u11 (ref), SquadLuckyRecommendationPhase (copy)
			u10 = nil
			u11 = {
				phase = SquadLuckyRecommendationPhase.Errored,
				error = p2
			}
		end)
	end

	return {
		getState = v8,
		startRoll = function(s2: string, b1: boolean?) -- line: 66
			-- upvalues: v8 (copy), SquadLuckyRecommendationPhase (copy), u11 (ref), v12 (copy)
			if b1 then
				local v16 = v8(false)
				local v17 = if v16.phase ~= SquadLuckyRecommendationPhase.Revealed then if u11 == nil or u11.phase ~= SquadLuckyRecommendationPhase.Revealed then nil else u11 else v16

				if v17 ~= nil and s2 == v17.squadId then
					return
				end
			end

			v12(s2)
		end,
		endRoll = function() -- line: 82
			-- upvalues: v8 (copy), SquadLuckyRecommendationPhase (copy), u11 (ref), v9 (copy), u10 (ref), SquadLuckyRecommendationError (copy)
			if v8(false).phase ~= SquadLuckyRecommendationPhase.Rolling then
				return
			end

			if u11 ~= nil then
				v9(u11)
				u11 = nil

				return
			end

			if u10 then
				u10()
				u10 = nil
			end

			v9({
				phase = SquadLuckyRecommendationPhase.Errored,
				error = SquadLuckyRecommendationError.Failed
			})
		end,
		cancelFetch = function() -- line: 34
			-- upvalues: u10 (ref)
			if u10 then
				u10()
				u10 = nil
			end
		end
	}
end
