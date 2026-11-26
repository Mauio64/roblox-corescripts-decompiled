local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SharedFlags")

local defineFastString = game:DefineFastString(
	"FStringLuckyRecommendationExpLayer",
	"Party.Coordination.ExperienceJoin3"
)

local defineFastString2 = game:DefineFastString(
	"LuckyRecommendationEnableVariant",
	"enableLuckyRecommendation"
)

local fFlagForceEnableLuckyRecommendation = SharedFlags.FFlagForceEnableLuckyRecommendation
local fFlagEnableLuckyRecommendationExperimentation = SharedFlags.FFlagEnableLuckyRecommendationExperimentation

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getLuckyRecommendationEnabled = function()
		local v5 = fFlagForceEnableLuckyRecommendation

		if v5 then
			return v5
		end

		v5 = fFlagEnableLuckyRecommendationExperimentation

		if not v5 then
			return v5
		end

		local v6 = defineFastString2
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables[v6] ~= nil then
			return layerVariables[v6]
		end

		v5 = false
		return false
	end,
	logExposure = function()
		if
			not fFlagForceEnableLuckyRecommendation
			and fFlagEnableLuckyRecommendationExperimentation
			and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
		then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
