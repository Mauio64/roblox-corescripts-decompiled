local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString("ExpChatGlobalTabDefaultExperimentLayer", "ExperienceChat.TabOrder")

local defineFastString2 = game:DefineFastString("ExpChatGlobalTabDefaultVariant", "globalTabDefault")

local defineFastString3 = game:DefineFastString("ExpChatGlobalTabBubbleChatVariant", "globalTabBubbleChat")

local defineFastString4 = game:DefineFastString("ExpChatGlobalTabMessagePrefixVariant", "globalTabMessagePrefix")

local defineFastString5 = game:DefineFastString("ExpChatGlobalTabShortWelcomeVariant", "globalTabShortWelcomeMessage")

local defineFastFlag = game:DefineFastFlag("ForceEnableExpChatGlobalTabDefault", false)
local defineFastFlag2 = game:DefineFastFlag("ForceEnableExpChatGlobalTabBubbleChat", false)

local defineFastFlag3 = game:DefineFastFlag("ForceEnableExpChatGlobalTabMessagePrefix", false)

local defineFastFlag4 = game:DefineFastFlag("ForceEnableExpChatGlobalTabShortWelcome", false)

local function getIsUserInTreatment(defineFastString6: string) -- 1 equivalent call inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[defineFastString6] ~= nil then
		return layerVariables[defineFastString6]
	end

	return false
end

local ExpChatGlobalTabDefaultExperimentation = {}

function ExpChatGlobalTabDefaultExperimentation.getIsGlobalTabDefault()
	local v = defineFastFlag

	if v then
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

function ExpChatGlobalTabDefaultExperimentation.getIsGlobalBubbleChatEnabled()
	local v = defineFastFlag2

	if v then
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

function ExpChatGlobalTabDefaultExperimentation.getIsGlobalMessagePrefixEnabled()
	local v = defineFastFlag3

	if v then
		return v
	end

	local v2 = defineFastString4
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[v2] ~= nil then
		return layerVariables[v2]
	end

	v = false
	return false
end

function ExpChatGlobalTabDefaultExperimentation.getGlobalWelcomeMessageKey(): string
	if defineFastFlag4 or getIsUserInTreatment(defineFastString5) then -- inferred equivalent call
		return "CoreScripts.TextChat.ChatWindow.ChatEnabled.Global3"
	end

	return "CoreScripts.TextChat.ChatWindow.ChatEnabled.Global2"
end

function ExpChatGlobalTabDefaultExperimentation.logExposure()
	if experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return ExpChatGlobalTabDefaultExperimentation
