local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatPresetChatAutocompleteExperimentLayer",
	"UniverseChat.PresetChatAutocomplete"
)

local defineFastString2 = game:DefineFastString(
	"ExpChatPresetChatAutocompleteVariable",
	"AutocompleteEnabled"
)

local defineFastString3 = game:DefineFastString(
	"ExpChatPresetChatAutocompleteSearchModeVariable",
	"AutocompleteSearchMode"
)

local defineFastString4 = game:DefineFastString(
	"ExpChatPresetChatAutocompleteMinQueryLengthVariable",
	"AutocompleteMinQueryLength"
)

local defineFastInt = game:DefineFastInt("ExpChatPresetAutocompleteRegularIxpOverride", 0)

local defineFastInt2 = game:DefineFastInt("ExpChatPresetAutocompleteSearchModeOverride", -1)

local defineFastInt3 = game:DefineFastInt("ExpChatPresetAutocompleteMinQueryLengthOverride", 0)

local v5 = false

local function getAutocompleteAssignment()
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[defineFastString2] ~= nil then
		return layerVariables[defineFastString2]
	end

	return nil
end

return {
	isEnabled = function(): boolean
		if defineFastInt == 1 then
			return true
		elseif defineFastInt == 2 then
			return false
		end

		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)
		local v6

		if layerVariables and layerVariables[defineFastString2] ~= nil then
			v6 = layerVariables[defineFastString2]
		end

		return v6 == true or v6 == 1
	end,
	getSearchVariant = function()
		local v6 = experimentCacheManager.default:getLayerVariables(defineFastString) or {}

		local v7 = if defineFastInt2 >= 0 then defineFastInt2 else tonumber(v6[defineFastString3])

		local v8 = if defineFastInt3 > 0 then defineFastInt3 else tonumber(v6[defineFastString4])

		if v8 ~= nil and v8 < 1 then
			v8 = nil
		end

		return { mode = v7, minQueryLength = v8 }
	end,
	logExposure = function()
		if not v5 then
			local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)
			local v6

			if layerVariables and layerVariables[defineFastString2] ~= nil then
				v6 = layerVariables[defineFastString2]
			end

			if v6 ~= nil then
				v5 = true

				pcall(function()
					experimentCacheManager.default:logLayerExposure(defineFastString)
				end)
			end
		end
	end
}
