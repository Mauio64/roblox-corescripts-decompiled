local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createLibraryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetLibraryStore/createLibraryStore")

return Signals.createComputed(createLibraryStore)
