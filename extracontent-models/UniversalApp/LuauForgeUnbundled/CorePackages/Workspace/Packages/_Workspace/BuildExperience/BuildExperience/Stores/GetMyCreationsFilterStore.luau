local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createMyCreationsFilterStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetMyCreationsFilterStore/createMyCreationsFilterStore")

return Signals.createComputed(createMyCreationsFilterStore)
