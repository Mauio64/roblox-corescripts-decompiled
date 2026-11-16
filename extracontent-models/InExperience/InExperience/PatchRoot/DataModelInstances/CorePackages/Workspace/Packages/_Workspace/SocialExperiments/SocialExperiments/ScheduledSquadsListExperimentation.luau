local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("ScheduledSquadsListExpLayer", "")

local defineFastString2 = game:DefineFastString(
	"ScheduledSquadsListChatLandingScreenEntrypointVariant",
	"enableTopBarEntrypoint"
)

local defineFastFlag = game:DefineFastFlag("EnableScheduledSquadsListExperimentation_dev", false)

local defineFastFlag2 = game:DefineFastFlag("EnableScheduledSquadsTopBarEntrypoint_dev", false)

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local ScheduledSquadsListExperimentation = {}

function ScheduledSquadsListExperimentation.getIsTopBarEntrypointEnabled()
	local v = defineFastFlag2

	if v then
		return v
	end

	v = defineFastFlag

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

function ScheduledSquadsListExperimentation.logExposure()
	if defineFastFlag and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return ScheduledSquadsListExperimentation
