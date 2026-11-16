local parent = script:FindFirstAncestor("SocialExperiments").Parent

local ExperimentCacheManager = require(parent.ExperimentCacheManager)
local experimentCacheManager = ExperimentCacheManager.ExperimentCacheManager

local defineFastString = game:DefineFastString(
	"SquadCoordinationExperienceJoinExperimentLayer",
	"Party.Coordination.ExperienceJoin"
)

local defineFastFlag = game:DefineFastFlag("IsSquadCoordinationExperienceJoinExperimentExposureEnabled", false)
local isSquadLobbySessionEnabled = game:DefineFastFlag("IsSquadLobbySessionEnabled", false)

local function getIsUserInTreatment(p: string) -- 4 equivalent calls inferred from this helper
	local layerVariables = experimentCacheManager.default:getLayerVariables(defineFastString)

	if layerVariables and layerVariables[p] ~= nil then
		return layerVariables[p]
	end

	return false
end

local SquadCoordinationExperienceJoinExperimentation = {}

function SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled()
	return isSquadLobbySessionEnabled
end

function SquadCoordinationExperienceJoinExperimentation.getShouldOpenSLPFromExpPickerEnabled()
	return getIsUserInTreatment("ShouldOpenSLPFromExpPickerEnabled") -- inferred equivalent call
end

function SquadCoordinationExperienceJoinExperimentation.getShouldShowFTUXOnExpPickerEnabled()
	return getIsUserInTreatment("ShouldShowFTUXOnExpPickerEnabled") -- inferred equivalent call
end

function SquadCoordinationExperienceJoinExperimentation.getIsSearchIconOnExpPickerEnabled()
	return getIsUserInTreatment("IsSearchIconOnExpPickerEnabled") -- inferred equivalent call
end

function SquadCoordinationExperienceJoinExperimentation.getIsNewTooltipCopyEnabled()
	return getIsUserInTreatment("IsNewTooltipCopyEnabled") -- inferred equivalent call
end

function SquadCoordinationExperienceJoinExperimentation.logExposure()
	if defineFastFlag and experimentCacheManager.default:getLayerVariables(defineFastString) ~= nil then
		experimentCacheManager.default:logLayerExposure(defineFastString)
	end
end

return SquadCoordinationExperienceJoinExperimentation
