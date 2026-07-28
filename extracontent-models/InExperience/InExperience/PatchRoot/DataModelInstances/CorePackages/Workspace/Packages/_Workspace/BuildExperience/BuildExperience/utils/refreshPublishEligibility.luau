local Parent = script:FindFirstAncestor("BuildExperience").Parent
local ExperienceGuidelines = require(Parent.DataHydration.ExperienceGuidelines)
local ExperienceQuestionnaire = require(Parent.DataHydration.ExperienceQuestionnaire)
local UniverseActivation = require(Parent.DataHydration.UniverseActivation)

local function refreshPublishEligibility(n1: number) -- line: 8
	-- upvalues: ExperienceGuidelines (copy), ExperienceQuestionnaire (copy), UniverseActivation (copy)
	ExperienceGuidelines.getExperienceGuidelinesStore().fetchDetailedGuidelines(n1)
	ExperienceQuestionnaire.getExperienceQuestionnaireStore().fetchEligibility(n1)
	UniverseActivation.getUniverseActivationStore(false).fetchEligibility(n1)
end

return refreshPublishEligibility
