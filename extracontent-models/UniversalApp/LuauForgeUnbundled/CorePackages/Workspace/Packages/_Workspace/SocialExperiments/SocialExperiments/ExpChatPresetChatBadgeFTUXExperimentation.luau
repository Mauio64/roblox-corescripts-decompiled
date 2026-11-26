local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local fFlagExpChatPresetChatBadgeExperimentCleanup = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/SharedFlags").FFlagExpChatPresetChatBadgeExperimentCleanup

local defineFastString = game:DefineFastString(
	"ExpChatPresetChatBadgeFTUXExperimentLayer",
	"UniverseChat.PresetChat"
)

local defineFastString2 = game:DefineFastString("ExpChatPresetChatBadgeFTUXVariable", "ChatIconBadged")

local defineFastFlag = game:DefineFastFlag("ExpChatEnablePresetChatBadgeFTUXExperimentation", false)

local defineFastInt = game:DefineFastInt("ExpChatPresetChatIconBadgeOverride", 0)

local v5 = false

local function getChatIconBadged()
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[defineFastString2] ~= nil then
		return layerVariables[defineFastString2]
	end

	return nil
end

return {
	getShouldShowPresetChatIconBadge = function(): boolean
		if defineFastInt == 1 then
			return true
		elseif defineFastInt == 2 then
			return false
		end

		if defineFastFlag then
			local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)
			local v6

			if layerVariables and layerVariables[defineFastString2] ~= nil then
				v6 = layerVariables[defineFastString2]
			end

			if v6 == nil then
				if fFlagExpChatPresetChatBadgeExperimentCleanup then
					return false
				end

				return true
			elseif fFlagExpChatPresetChatBadgeExperimentCleanup then
				return v6 == true or v6 == 1
			else
				return v6 == 1
			end
		elseif fFlagExpChatPresetChatBadgeExperimentCleanup then
			return false
		else
			return true
		end
	end,
	logExposure = function()
		if not defineFastFlag or v5 then
			return
		end

		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)
		local v6

		if layerVariables and layerVariables[defineFastString2] ~= nil then
			v6 = layerVariables[defineFastString2]
		end

		if v6 == nil then
			return
		end

		v5 = true
		pcall(function()
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end)
	end,
	isExperimentEnabled = defineFastFlag
}
