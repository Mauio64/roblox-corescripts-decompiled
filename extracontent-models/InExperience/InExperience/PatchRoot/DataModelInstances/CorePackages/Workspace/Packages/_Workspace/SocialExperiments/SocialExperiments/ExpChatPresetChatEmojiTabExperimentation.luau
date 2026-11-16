local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

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

local v = false

local function getAssignment(p: string) -- 3 equivalent calls inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return nil
end

local function getIsTreatment(defineFastString4: string): boolean -- 2 equivalent calls inferred from this helper
	if not defineFastFlag then
		return false
	end

	local assignment = getAssignment(defineFastString4) -- inferred equivalent call
	return assignment == true or assignment == 1
end

local ExpChatPresetChatEmojiTabExperimentation = {}

function ExpChatPresetChatEmojiTabExperimentation.getIsEmojiIconEnabled()
	return getIsTreatment(defineFastString2) -- inferred equivalent call
end

function ExpChatPresetChatEmojiTabExperimentation.getIsEmphasizedRenderingEnabled()
	return getIsTreatment(defineFastString3) -- inferred equivalent call
end

function ExpChatPresetChatEmojiTabExperimentation.logExposure()
	if
		not defineFastFlag
		or v
		or getAssignment(defineFastString2) == nil and getAssignment(defineFastString3) == nil -- inferred equivalent call
	then
		return
	end

	v = true

	pcall(function()
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end)
end

ExpChatPresetChatEmojiTabExperimentation.isExperimentEnabled = defineFastFlag
return ExpChatPresetChatEmojiTabExperimentation
