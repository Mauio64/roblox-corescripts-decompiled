local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("FStringQueueExpLayer", "Party.Coordination.ExperienceJoin")

local defineFastString2 = game:DefineFastString("QueueEnableAutoJoinNewServerVariant", "enableAutoJoinNewServer")

local defineFastString3 = game:DefineFastString("QueueEnableJoinNewServerVariant", "enableJoinNewServerButton")
local defineFastFlag = game:DefineFastFlag("ForceEnableQueueAutoJoinNewServer2", false)
local defineFastFlag2 = game:DefineFastFlag("ForceEnableQueueJoinNewServerButton2", false)
local engineFeature = game:DefineFastFlag("EnableQueueExperimentation2", false)
	and game:GetEngineFeature("PlaceJoinStateEnabled")

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local QueueExperimentation = {}

function QueueExperimentation.getIsJoinNewServerButtonEnabled()
	local v = defineFastFlag2

	if v then
		return v
	end

	v = engineFeature

	if not v then
		return v
	end

	local v2 = defineFastString3
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[v2] ~= nil then
		return layerVariables[v2]
	end

	v = false
	return false
end

function QueueExperimentation.getIsAutoJoinNewServerEnabled()
	local v = defineFastFlag

	if v then
		return v
	end

	v = engineFeature

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

function QueueExperimentation.isInExperiment(): boolean
	if engineFeature then
		return experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil
	end

	return false
end

function QueueExperimentation.logExposure()
	if engineFeature and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return QueueExperimentation
