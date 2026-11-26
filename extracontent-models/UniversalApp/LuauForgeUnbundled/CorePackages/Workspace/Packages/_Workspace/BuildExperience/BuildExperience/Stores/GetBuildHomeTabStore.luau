local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local createBuildHomeTabStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildHomeTabStore/createBuildHomeTabStore")

return Signals.createComputed(createBuildHomeTabStore.createBuildHomeTabStore)
