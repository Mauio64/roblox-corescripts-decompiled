local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createBuildExperienceRefreshStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildExperienceRefreshStore/createBuildExperienceRefreshStore")

return Signals.createComputed(createBuildExperienceRefreshStore)
