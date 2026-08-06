local Parent = script:FindFirstAncestor("BuildExperience").Parent
local ExperienceQuestionnaire = require(Parent.DataHydration.ExperienceQuestionnaire)
local Game = require(Parent.DataHydration).Game
local refreshPublishEligibility = require(script.Parent.refreshPublishEligibility)

local function rehydrateGameMetadata(n1: number) -- line: 7
	-- upvalues: Game (copy), refreshPublishEligibility (copy), ExperienceQuestionnaire (copy)
	local str = tostring(n1)

	Game.getGameInfoStore().fetchGameInfo(str)
	Game.getGameMediaStore().fetchGameMedia(str)
	refreshPublishEligibility(n1)
	ExperienceQuestionnaire.getExperienceQuestionnaireStore().fetchLatestSubmission(n1)
end

return rehydrateGameMetadata
