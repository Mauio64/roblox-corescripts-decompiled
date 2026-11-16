local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createAssistantBuildStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetAssistantBuildStore/createAssistantBuildStore")

return Signals.createComputed(createAssistantBuildStore)
