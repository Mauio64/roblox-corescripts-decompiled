local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatNewSystemMessagesExperimentLayer",
	"ExperienceChat.SystemMessages"
)

local defineFastString2 = game:DefineFastString("ExpChatNewSystemMessagesVariant", "enableNewSystemMessages")
local defineFastFlag = game:DefineFastFlag("ForceEnableExpChatNewSystemMessages", false)

local defineFastFlag2 = game:DefineFastFlag("EnableExpChatNewSystemMessagesExperimentation", false)

local function getIsUserInTreatment(p: string)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local ExpChatNewSystemMessagesExperimentation = {}

function ExpChatNewSystemMessagesExperimentation.getNewSystemMessagesEnabled()
	local v = defineFastFlag

	if v then
		return v
	end

	v = defineFastFlag2

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

function ExpChatNewSystemMessagesExperimentation.logExposure()
	if defineFastFlag2 and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

ExpChatNewSystemMessagesExperimentation.isExperimentEnabled = defineFastFlag2
return ExpChatNewSystemMessagesExperimentation
