local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local SharedFlags = require(parent.SharedFlags)
local FFlagExpChatPresetChatBadgeExperimentCleanup = SharedFlags.FFlagExpChatPresetChatBadgeExperimentCleanup

local defineFastString = game:DefineFastString("ExpChatPresetChatBadgeFTUXExperimentLayer", "UniverseChat.PresetChat")

local defineFastString2 = game:DefineFastString("ExpChatPresetChatBadgeFTUXVariable", "ChatIconBadged")

local defineFastFlag = game:DefineFastFlag("ExpChatEnablePresetChatBadgeFTUXExperimentation", false)

local defineFastInt = game:DefineFastInt("ExpChatPresetChatIconBadgeOverride", 0)

local v = false

local function getChatIconBadged() -- 2 equivalent calls inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[defineFastString2] ~= nil then
		return layerVariables[defineFastString2]
	end

	return nil
end

local ExpChatPresetChatBadgeFTUXExperimentation = {}

function ExpChatPresetChatBadgeFTUXExperimentation.getShouldShowPresetChatIconBadge(): boolean
	if defineFastInt == 1 then
		return true
	elseif defineFastInt == 2 then
		return false
	end

	if defineFastFlag then
		local chatIconBadged = getChatIconBadged() -- inferred equivalent call

		if chatIconBadged == nil then
			return not FFlagExpChatPresetChatBadgeExperimentCleanup
		elseif FFlagExpChatPresetChatBadgeExperimentCleanup then
			return chatIconBadged == true or chatIconBadged == 1
		else
			return chatIconBadged == 1
		end
	else
		return not FFlagExpChatPresetChatBadgeExperimentCleanup
	end
end

function ExpChatPresetChatBadgeFTUXExperimentation.logExposure()
	if not defineFastFlag or v or getChatIconBadged() == nil then -- inferred equivalent call
		return
	end

	v = true
	pcall(function()
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end)
end

ExpChatPresetChatBadgeFTUXExperimentation.isExperimentEnabled = defineFastFlag
return ExpChatPresetChatBadgeFTUXExperimentation
