local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString("AppChatPerfExperimentLayer", "Party.Chat.Perf")

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getChatLandingPaginationEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.IsChatLandingPaginationEnabled ~= nil then
			return layerVariables.IsChatLandingPaginationEnabled
		end

		return false
	end,
	getChatConversationPaginationEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.IsChatConversationPaginationEnabled ~= nil then
			return layerVariables.IsChatConversationPaginationEnabled
		end

		return false
	end,
	getChatMembersPaginationEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.IsChatMembersPaginationEnabled ~= nil then
			return layerVariables.IsChatMembersPaginationEnabled
		end

		return false
	end,
	getChatConversationRenderingFixEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.IsChatConversationRenderingFixEnabled ~= nil then
			return layerVariables.IsChatConversationRenderingFixEnabled
		end

		return false
	end,
	logExposure = function()
		if experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
