local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("AppChatPerfExperimentLayer", "Party.Chat.Perf")

local function getIsUserInTreatment(p: string) -- 4 equivalent calls inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local AppChatPerfExperimentation = {}

function AppChatPerfExperimentation.getChatLandingPaginationEnabled()
	return getIsUserInTreatment("IsChatLandingPaginationEnabled") -- inferred equivalent call
end

function AppChatPerfExperimentation.getChatConversationPaginationEnabled()
	return getIsUserInTreatment("IsChatConversationPaginationEnabled") -- inferred equivalent call
end

function AppChatPerfExperimentation.getChatMembersPaginationEnabled()
	return getIsUserInTreatment("IsChatMembersPaginationEnabled") -- inferred equivalent call
end

function AppChatPerfExperimentation.getChatConversationRenderingFixEnabled()
	return getIsUserInTreatment("IsChatConversationRenderingFixEnabled") -- inferred equivalent call
end

function AppChatPerfExperimentation.logExposure()
	if experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return AppChatPerfExperimentation
