local module = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/ExperienceGuidelinesStoreTypes")

return {
	createExperienceGuidelinesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/createExperienceGuidelinesStore"),
	getExperienceGuidelinesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/getExperienceGuidelinesStore"),
	ExperienceGuidelinesStoreTypes = module
}
