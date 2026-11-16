local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString("FStringQueueExpLayer", "Party.Coordination.ExperienceJoin")

local defineFastString2 = game:DefineFastString(
	"QueueEnableAutoJoinNewServerVariant",
	"enableAutoJoinNewServer"
)

local defineFastString3 = game:DefineFastString(
	"QueueEnableJoinNewServerVariant",
	"enableJoinNewServerButton"
)
local defineFastFlag = game:DefineFastFlag("ForceEnableQueueAutoJoinNewServer2", false)
local defineFastFlag2 = game:DefineFastFlag("ForceEnableQueueJoinNewServerButton2", false)
local engineFeature = game:DefineFastFlag("EnableQueueExperimentation2", false)
	and game:GetEngineFeature("PlaceJoinStateEnabled")

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getIsJoinNewServerButtonEnabled = function()
		local v5 = defineFastFlag2

		if v5 then
			return v5
		end

		v5 = engineFeature

		if not v5 then
			return v5
		end

		local v6 = defineFastString3
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables[v6] ~= nil then
			return layerVariables[v6]
		end

		v5 = false
		return false
	end,
	getIsAutoJoinNewServerEnabled = function()
		local v5 = defineFastFlag

		if v5 then
			return v5
		end

		v5 = engineFeature

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
	isInExperiment = function(): boolean
		if engineFeature then
			return experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
		end

		return false
	end,
	logExposure = function()
		if engineFeature and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
