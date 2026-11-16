local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createPlayButtonStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetPlayButtonStore/createPlayButtonStore")

return Signals.createComputed(createPlayButtonStore)
