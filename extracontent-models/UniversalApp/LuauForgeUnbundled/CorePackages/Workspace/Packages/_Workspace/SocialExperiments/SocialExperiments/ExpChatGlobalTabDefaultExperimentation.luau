local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatGlobalTabDefaultExperimentLayer",
	"ExperienceChat.TabOrder"
)

local defineFastString2 = game:DefineFastString("ExpChatGlobalTabDefaultVariant", "globalTabDefault")

local defineFastString3 = game:DefineFastString("ExpChatGlobalTabBubbleChatVariant", "globalTabBubbleChat")

local defineFastString4 = game:DefineFastString(
	"ExpChatGlobalTabMessagePrefixVariant",
	"globalTabMessagePrefix"
)

local defineFastString5 = game:DefineFastString(
	"ExpChatGlobalTabShortWelcomeVariant",
	"globalTabShortWelcomeMessage"
)

local defineFastFlag = game:DefineFastFlag("ForceEnableExpChatGlobalTabDefault", false)
local defineFastFlag2 = game:DefineFastFlag("ForceEnableExpChatGlobalTabBubbleChat", false)

local defineFastFlag3 = game:DefineFastFlag("ForceEnableExpChatGlobalTabMessagePrefix", false)

local defineFastFlag4 = game:DefineFastFlag("ForceEnableExpChatGlobalTabShortWelcome", false)

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getIsGlobalTabDefault = function()
		local v5 = defineFastFlag

		if v5 then
			return v5
		end

		local v6 = defineFastString2
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables[v6] ~= nil then
			return layerVariables[v6]
		end

		v5 = false
		return false
	end,
	getIsGlobalBubbleChatEnabled = function()
		local v5 = defineFastFlag2

		if v5 then
			return v5
		end

		local v6 = defineFastString3
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables[v6] ~= nil then
			return layerVariables[v6]
		end

		v5 = false
		return false
	end,
	getIsGlobalMessagePrefixEnabled = function()
		local v5 = defineFastFlag3

		if v5 then
			return v5
		end

		local v6 = defineFastString4
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables[v6] ~= nil then
			return layerVariables[v6]
		end

		v5 = false
		return false
	end,
	getGlobalWelcomeMessageKey = function(): string
		local v5 = defineFastFlag4

		if not v5 then
			local v6 = defineFastString5
			local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

			v5 = if layerVariables and layerVariables[v6] ~= nil then layerVariables[v6] else false
		end

		if v5 then
			return "CoreScripts.TextChat.ChatWindow.ChatEnabled.Global3"
		end

		return "CoreScripts.TextChat.ChatWindow.ChatEnabled.Global2"
	end,
	logExposure = function()
		if experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
