local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local SharedFlags = require(Parent.SharedFlags)
local v4 = game:DefineFastString("FStringLuckyRecommendationExpLayer", "Party.Coordination.ExperienceJoin3")
local v5 = game:DefineFastString("LuckyRecommendationEnableVariant", "enableLuckyRecommendation")
local FFlagForceEnableLuckyRecommendation = SharedFlags.FFlagForceEnableLuckyRecommendation
local FFlagEnableLuckyRecommendationExperimentation = SharedFlags.FFlagEnableLuckyRecommendationExperimentation

local function getIsUserInTreatment(s1: string) -- line: 15
	-- upvalues: ExperimentCacheManager (copy), v4 (copy)
	local v10 = ExperimentCacheManager.default:getLayerVariables(v4)

	if v10 and v10[s1] ~= nil then
		return v10[s1]
	end

	return false
end

return {
	getLuckyRecommendationEnabled = function() -- line: 25
		-- upvalues: FFlagForceEnableLuckyRecommendation (copy), FFlagEnableLuckyRecommendationExperimentation (copy), v5 (copy), ExperimentCacheManager (copy), v4 (copy)
		local v11 = FFlagForceEnableLuckyRecommendation

		if not v11 then
			v11 = FFlagEnableLuckyRecommendationExperimentation

			if v11 then
				local v12 = v5
				local v13 = ExperimentCacheManager.default:getLayerVariables(v4)

				if v13 and v13[v12] ~= nil then
					return v13[v12]
				end

				v11 = false
			end
		end

		return v11
	end,
	logExposure = function() -- line: 30
		-- upvalues: FFlagForceEnableLuckyRecommendation (copy), FFlagEnableLuckyRecommendationExperimentation (copy), ExperimentCacheManager (copy), v4 (copy)
		if not FFlagForceEnableLuckyRecommendation and (FFlagEnableLuckyRecommendationExperimentation and ExperimentCacheManager.default:getLayerVariables(v4) ~= nil) then
			ExperimentCacheManager.default:logLayerExposure(v4)
		end
	end
}
