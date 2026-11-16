local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createExperienceQuestionnaireStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/createExperienceQuestionnaireStore")

return Signals.createComputed(function()
	return createExperienceQuestionnaireStore()
end)
