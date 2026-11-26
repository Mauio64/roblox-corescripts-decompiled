local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createExperienceGuidelinesStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceGuidelines/createExperienceGuidelinesStore")

return Signals.createComputed(function()
	return createExperienceGuidelinesStore()
end)
