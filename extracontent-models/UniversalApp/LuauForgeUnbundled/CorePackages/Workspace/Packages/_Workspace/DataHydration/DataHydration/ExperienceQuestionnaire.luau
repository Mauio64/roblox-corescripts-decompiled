local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/ExperienceQuestionnaireStoreTypes")

return {
	createExperienceQuestionnaireStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/createExperienceQuestionnaireStore"),
	getExperienceQuestionnaireStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceQuestionnaire/getExperienceQuestionnaireStore"),
	ExperienceQuestionnaireStoreTypes = module
}
