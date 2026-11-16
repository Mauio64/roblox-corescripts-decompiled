local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatPresetChatEmojiTabExperimentLayer",
	"UniverseChat.PresetChat.Emojis"
)

local defineFastString2 = game:DefineFastString("ExpChatPresetChatEmojiTabEmojiIconVariable", "emojiIcon")

local defineFastString3 = game:DefineFastString(
	"ExpChatPresetChatEmojiTabEmphasizedRenderingVariable",
	"emphasizedRendering"
)

local defineFastFlag = game:DefineFastFlag("ExpChatPresetChatEmojiTabExperimentEnabled", false)

local v5 = false

local function getAssignment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return nil
end

local function getIsTreatment(p2): boolean
	if not defineFastFlag then
		return false
	end

	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	local v6 = if layerVariables and layerVariables[p2] ~= nil then layerVariables[p2] else nil

	return v6 == true or v6 == 1
end

return {
	getIsEmojiIconEnabled = function(): boolean
		local v6 = defineFastString2

		if not defineFastFlag then
			return false
		end

		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		local v7 = if layerVariables and layerVariables[v6] ~= nil then layerVariables[v6] else nil

		return v7 == true or v7 == 1
	end,
	getIsEmphasizedRenderingEnabled = function(): boolean
		local v6 = defineFastString3

		if not defineFastFlag then
			return false
		end

		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		local v7 = if layerVariables and layerVariables[v6] ~= nil then layerVariables[v6] else nil

		return v7 == true or v7 == 1
	end,
	logExposure = function()
		if not defineFastFlag or v5 then
			return
		end

		local v6 = defineFastString2
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		local v7 = if layerVariables and layerVariables[v6] ~= nil then layerVariables[v6] else nil

		if v7 == nil then
			local v8 = defineFastString3
			local layerVariables2 = experimentCacheManager.default:getLayerVariables(defineFastString)

			local v9 = if layerVariables2 and layerVariables2[v8] ~= nil then layerVariables2[v8] else nil

			if v9 == nil then
				return
			end
		end

		v5 = true

		pcall(function()
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end)
	end,
	isExperimentEnabled = defineFastFlag
}
