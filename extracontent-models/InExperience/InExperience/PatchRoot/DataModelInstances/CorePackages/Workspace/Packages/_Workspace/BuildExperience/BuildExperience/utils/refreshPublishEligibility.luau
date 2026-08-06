local BuildExperience = script:FindFirstAncestor("BuildExperience")
local BuildExperienceParent = BuildExperience.Parent
local ExperienceGuidelines = require(BuildExperienceParent.DataHydration.ExperienceGuidelines)
local ExperienceQuestionnaire = require(BuildExperienceParent.DataHydration.ExperienceQuestionnaire)
local UniverseActivation = require(BuildExperienceParent.DataHydration.UniverseActivation)
local FFlagBuildRehydrateOnPublish = require(BuildExperience.Flags.FFlagBuildRehydrateOnPublish)

local function refreshPublishEligibility(n1: number) -- line: 10
	-- upvalues: ExperienceGuidelines (copy), UniverseActivation (copy), FFlagBuildRehydrateOnPublish (copy), ExperienceQuestionnaire (copy)
	local v9 = ExperienceGuidelines.getExperienceGuidelinesStore()
	local v10 = UniverseActivation.getUniverseActivationStore()

	if FFlagBuildRehydrateOnPublish then
		v9.refreshDetailedGuidelines(n1):catch(function() -- line: 14
		end)
		v10.refreshEligibility(n1):catch(function() -- line: 17
		end)
	else
		v9.fetchDetailedGuidelines(n1)
		v10.fetchEligibility(n1)
	end

	ExperienceQuestionnaire.getExperienceQuestionnaireStore().fetchEligibility(n1)
end

return refreshPublishEligibility
