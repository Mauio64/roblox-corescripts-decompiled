local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local createBuildPillMenuPortalStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPillMenuPortalStore/createBuildPillMenuPortalStore")

return Signals.createComputed(createBuildPillMenuPortalStore)
