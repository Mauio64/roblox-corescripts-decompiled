local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Signals")
local createBuildPromptDraftStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Stores/GetBuildPromptDraftStore/createBuildPromptDraftStore")

return Signals.createComputed(createBuildPromptDraftStore)
