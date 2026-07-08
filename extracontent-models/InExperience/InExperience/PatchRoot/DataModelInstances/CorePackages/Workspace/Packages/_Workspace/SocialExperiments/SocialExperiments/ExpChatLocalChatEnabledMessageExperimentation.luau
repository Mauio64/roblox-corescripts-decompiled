local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("ExpChatLocalChatEnabledMessageExperimentLayer", "ExperienceChat.SystemMessages")
local v4 = game:DefineFastString("ExpChatLocalChatEnabledMessageVariable", "SystemMessageKey")
local v5 = game:DefineFastString("ExpChatLocalChatEnabledMessageForcedKey", "")
local v6 = game:DefineFastFlag("EnableExpChatLocalChatEnabledMessageExperimentation2", false)

return {
	getSystemMessageKey = function() -- line: 18
		-- upvalues: v5 (copy), ExperimentCacheManager (copy), v3 (copy), v4 (copy)
		if v5 ~= "" then
			return v5
		end

		local v7 = ExperimentCacheManager.default:getLayerVariables(v3)

		if v7 and v7[v4] ~= nil then
			return v7[v4]
		end

		return nil
	end,
	logExposure = function() -- line: 33
		-- upvalues: v6 (copy), ExperimentCacheManager (copy), v3 (copy)
		if v6 and ExperimentCacheManager.default:getLayerVariables(v3) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end,
	isExperimentEnabled = v6
}
