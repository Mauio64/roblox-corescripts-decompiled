local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")

local createVersionInformationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetVersionInformationStore/createVersionInformationStore")

return Signals.createComputed(createVersionInformationStore)
