local experimentCacheManager = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialExperiments/ExperimentCacheManager").ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"SquadCoordinationExperienceJoinExperimentLayer",
	"Party.Coordination.ExperienceJoin"
)

local defineFastFlag = game:DefineFastFlag(
	"IsSquadCoordinationExperienceJoinExperimentExposureEnabled",
	false
)
local isSquadLobbySessionEnabled = game:DefineFastFlag("IsSquadLobbySessionEnabled", false)

local function getIsUserInTreatment(p2)
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p2] ~= nil then
		return layerVariables[p2]
	end

	return false
end

return {
	getIsSquadLobbySessionEnabled = function()
		return isSquadLobbySessionEnabled
	end,
	getShouldOpenSLPFromExpPickerEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.ShouldOpenSLPFromExpPickerEnabled ~= nil then
			return layerVariables.ShouldOpenSLPFromExpPickerEnabled
		end

		return false
	end,
	getShouldShowFTUXOnExpPickerEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.ShouldShowFTUXOnExpPickerEnabled ~= nil then
			return layerVariables.ShouldShowFTUXOnExpPickerEnabled
		end

		return false
	end,
	getIsSearchIconOnExpPickerEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.IsSearchIconOnExpPickerEnabled ~= nil then
			return layerVariables.IsSearchIconOnExpPickerEnabled
		end

		return false
	end,
	getIsNewTooltipCopyEnabled = function()
		local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

		if layerVariables and layerVariables.IsNewTooltipCopyEnabled ~= nil then
			return layerVariables.IsNewTooltipCopyEnabled
		end

		return false
	end,
	logExposure = function()
		if defineFastFlag and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
			experimentCacheManager.default:logLayerExposure(defineFastString)
		end
	end
}
