local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/Signals")
local createPlaytestLoadingStore = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperiencePlaytestLaunch/BuildExperiencePlaytestLaunch/GetPlaytestLoadingStore/createPlaytestLoadingStore")

return Signals.createComputed(createPlaytestLoadingStore)
