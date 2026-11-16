local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"ExpChatPresetChatAutocompleteExperimentLayer",
	"UniverseChat.PresetChatAutocomplete"
)

local defineFastString2 = game:DefineFastString("ExpChatPresetChatAutocompleteVariable", "AutocompleteEnabled")

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

local v = false

local function getAutocompleteAssignment() -- 2 equivalent calls inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[defineFastString2] ~= nil then
		return layerVariables[defineFastString2]
	end

	return nil
end

local ExpChatPresetChatAutocompleteExperimentation = {}

function ExpChatPresetChatAutocompleteExperimentation.isEnabled(): boolean
	if defineFastInt == 1 then
		return true
	elseif defineFastInt == 2 then
		return false
	end

	local autocompleteAssignment = getAutocompleteAssignment() -- inferred equivalent call
	return autocompleteAssignment == true or autocompleteAssignment == 1
end

function ExpChatPresetChatAutocompleteExperimentation.getSearchVariant()
	local v2 = experimentCacheManager.default:getLayerVariables(defineFastString) or {}
	local mode

	if defineFastInt2 >= 0 then
		mode = defineFastInt2
	else
		mode = tonumber(v2[defineFastString3])
	end

	local minQueryLength

	if defineFastInt3 > 0 then
		minQueryLength = defineFastInt3
	else
		minQueryLength = tonumber(v2[defineFastString4])
	end

	if minQueryLength ~= nil and minQueryLength < 1 then
		minQueryLength = nil
	end

	return { mode = mode, minQueryLength = minQueryLength }
end

function ExpChatPresetChatAutocompleteExperimentation.logExposure()
	if not v and getAutocompleteAssignment() ~= nil then -- inferred equivalent call
		v = true

		pcall(function()
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end)
	end
end

return ExpChatPresetChatAutocompleteExperimentation
