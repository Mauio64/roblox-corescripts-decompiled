local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager
local SharedFlags = require(parent.SharedFlags)

local defineFastString = game:DefineFastString(
	"FStringLuckyRecommendationExpLayer",
	"Party.Coordination.ExperienceJoin3"
)

local defineFastString2 = game:DefineFastString("LuckyRecommendationEnableVariant", "enableLuckyRecommendation")

local FFlagForceEnableLuckyRecommendation = SharedFlags.FFlagForceEnableLuckyRecommendation
local FFlagEnableLuckyRecommendationExperimentation = SharedFlags.FFlagEnableLuckyRecommendationExperimentation

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local LuckyRecommendationExperimentation = {}

function LuckyRecommendationExperimentation.getLuckyRecommendationEnabled()
	local v = FFlagForceEnableLuckyRecommendation

	if v then
		return v
	end

	v = FFlagEnableLuckyRecommendationExperimentation

	if not v then
		return v
	end

	local v2 = defineFastString2
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[v2] ~= nil then
		return layerVariables[v2]
	end

	v = false
	return false
end

function LuckyRecommendationExperimentation.logExposure()
	if
		not FFlagForceEnableLuckyRecommendation
		and FFlagEnableLuckyRecommendationExperimentation
		and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
	then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return LuckyRecommendationExperimentation
