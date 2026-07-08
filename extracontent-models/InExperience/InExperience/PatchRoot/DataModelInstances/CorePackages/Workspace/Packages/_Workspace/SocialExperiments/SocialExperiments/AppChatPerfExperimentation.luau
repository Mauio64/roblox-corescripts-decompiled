local Parent = script:FindFirstAncestor("SocialExperiments").Parent
local ExperimentCacheManager = require(Parent.ExperimentCacheManager).ExperimentCacheManager
local v3 = game:DefineFastString("AppChatPerfExperimentLayer", "Party.Chat.Perf")

local function getIsUserInTreatment(s1: string) -- line: 8
	-- upvalues: v3 (copy), ExperimentCacheManager (copy)
	local v6 = v3
	local v7 = ExperimentCacheManager.default:getLayerVariables(v6)

	if v7 and v7[s1] ~= nil then
		return v7[s1]
	end

	return false
end

return {
	getChatLandingPaginationEnabled = function() -- line: 19
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v8 = v3
		local v9 = ExperimentCacheManager.default:getLayerVariables(v8)

		if v9 and v9.IsChatLandingPaginationEnabled ~= nil then
			return v9.IsChatLandingPaginationEnabled
		end

		return false
	end,
	getChatConversationPaginationEnabled = function() -- line: 23
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v10 = v3
		local v11 = ExperimentCacheManager.default:getLayerVariables(v10)

		if v11 and v11.IsChatConversationPaginationEnabled ~= nil then
			return v11.IsChatConversationPaginationEnabled
		end

		return false
	end,
	getChatMembersPaginationEnabled = function() -- line: 27
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v12 = v3
		local v13 = ExperimentCacheManager.default:getLayerVariables(v12)

		if v13 and v13.IsChatMembersPaginationEnabled ~= nil then
			return v13.IsChatMembersPaginationEnabled
		end

		return false
	end,
	getChatConversationRenderingFixEnabled = function() -- line: 31
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v14 = v3
		local v15 = ExperimentCacheManager.default:getLayerVariables(v14)

		if v15 and v15.IsChatConversationRenderingFixEnabled ~= nil then
			return v15.IsChatConversationRenderingFixEnabled
		end

		return false
	end,
	logExposure = function() -- line: 35
		-- upvalues: v3 (copy), ExperimentCacheManager (copy)
		local v16 = v3

		if ExperimentCacheManager.default:getLayerVariables(v16) ~= nil then
			ExperimentCacheManager.default:logLayerExposure(v3)
		end
	end
}
