local parent = script:FindFirstAncestor("BuildExperience").Parent

local ExperienceGuidelines = require(parent.DataHydration.ExperienceGuidelines)
local ExperienceQuestionnaire = require(parent.DataHydration.ExperienceQuestionnaire)
local UniverseActivation = require(parent.DataHydration.UniverseActivation)

local function refreshPublishEligibility(p: number)
	local experienceGuidelinesStore = ExperienceGuidelines.getExperienceGuidelinesStore()
	local universeActivationStore = UniverseActivation.getUniverseActivationStore()
	experienceGuidelinesStore.refreshDetailedGuidelines(p):catch(function() end)

	universeActivationStore.refreshEligibility(p):catch(function() end)
	ExperienceQuestionnaire.getExperienceQuestionnaireStore().fetchEligibility(p)
end

return refreshPublishEligibility
