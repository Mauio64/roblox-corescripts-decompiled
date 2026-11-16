local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatMessageHistoryLayer",
	"ExperienceChat.MessageHistory"
)

local defineFastString2 = game:DefineFastString("ExpChatHistoryMessageCountVariable", "historyMessageCount")

local defineFastString3 = game:DefineFastString(
	"ExpChatHistoryMaxAgeSecondsVariable",
	"historyMaxAgeSeconds"
)

local defineFastFlag = game:DefineFastFlag("ForceEnableExpChatMessageHistory", false)
local defineFastInt = game:DefineFastInt("DebugExpChatHistoryMessageCount", 10)
local defineFastInt2 = game:DefineFastInt("DebugExpChatHistoryMaxAgeSeconds", 0)

local v5 = nil
local v6 = false

return {
	getHistoryArm = function(p2)
		if not p2 then
			return nil
		end

		if v5 then
			return v5
		end

		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables ~= nil and layerVariables[defineFastString2] ~= nil then
			v5 = {
				maxCount = layerVariables[defineFastString2] or 0,
				maxAgeSeconds = layerVariables[defineFastString3] or 0
			}

			return v5
		end

		if defineFastFlag then
			return { maxCount = defineFastInt, maxAgeSeconds = defineFastInt2 }
		end

		return nil
	end,
	logExposure = function(p2)
		if v6 or not p2 then
			return
		end

		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables == nil or layerVariables[defineFastString2] == nil then
			return
		end

		v6 = true
		pcall(function()
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end)
	end
}
