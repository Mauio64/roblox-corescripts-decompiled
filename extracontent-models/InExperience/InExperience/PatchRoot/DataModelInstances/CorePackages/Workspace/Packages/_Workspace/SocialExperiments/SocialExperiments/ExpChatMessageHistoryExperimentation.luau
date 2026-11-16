local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("ExpChatMessageHistoryLayer", "ExperienceChat.MessageHistory")

local defineFastString2 = game:DefineFastString("ExpChatHistoryMessageCountVariable", "historyMessageCount")

local defineFastString3 = game:DefineFastString("ExpChatHistoryMaxAgeSecondsVariable", "historyMaxAgeSeconds")

local defineFastFlag = game:DefineFastFlag("ForceEnableExpChatMessageHistory", false)
local defineFastInt = game:DefineFastInt("DebugExpChatHistoryMessageCount", 10)
local defineFastInt2 = game:DefineFastInt("DebugExpChatHistoryMaxAgeSeconds", 0)

local v = nil
local v2 = false
local ExpChatMessageHistoryExperimentation = {}

function ExpChatMessageHistoryExperimentation.getHistoryArm(flag: boolean)
	if not flag then
		return nil
	end

	if v then
		return v
	end

	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables ~= nil and layerVariables[defineFastString2] ~= nil then
		v = {
			maxCount = layerVariables[defineFastString2] or 0,
			maxAgeSeconds = layerVariables[defineFastString3] or 0
		}

		return v
	end

	if defineFastFlag then
		return { maxCount = defineFastInt, maxAgeSeconds = defineFastInt2 }
	end

	return nil
end

function ExpChatMessageHistoryExperimentation.logExposure(flag: boolean)
	if v2 or not flag then
		return
	end

	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables == nil or layerVariables[defineFastString2] == nil then
		return
	end

	v2 = true
	pcall(function()
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end)
end

return ExpChatMessageHistoryExperimentation
