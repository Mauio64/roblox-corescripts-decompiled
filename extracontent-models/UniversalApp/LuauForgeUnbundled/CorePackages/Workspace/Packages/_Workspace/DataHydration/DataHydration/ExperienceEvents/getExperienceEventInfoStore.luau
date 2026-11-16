local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createExperienceEventInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ExperienceEvents/createExperienceEventInfoStore")

return Signals.createComputed(createExperienceEventInfoStore)
