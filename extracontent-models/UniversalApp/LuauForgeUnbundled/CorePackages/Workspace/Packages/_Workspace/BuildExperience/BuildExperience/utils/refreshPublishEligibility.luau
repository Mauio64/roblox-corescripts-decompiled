local ExperienceGuidelines = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceGuidelines")
local ExperienceQuestionnaire = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/ExperienceQuestionnaire")
local UniverseActivation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/UniverseActivation")

local function refreshPublishEligibility(p2)
	local experienceGuidelinesStore = ExperienceGuidelines.getExperienceGuidelinesStore()
	local universeActivationStore = UniverseActivation.getUniverseActivationStore()
	experienceGuidelinesStore.refreshDetailedGuidelines(p2):catch(function() end)

	universeActivationStore.refreshEligibility(p2):catch(function() end)
	ExperienceQuestionnaire.getExperienceQuestionnaireStore().fetchEligibility(p2)
end

return refreshPublishEligibility
