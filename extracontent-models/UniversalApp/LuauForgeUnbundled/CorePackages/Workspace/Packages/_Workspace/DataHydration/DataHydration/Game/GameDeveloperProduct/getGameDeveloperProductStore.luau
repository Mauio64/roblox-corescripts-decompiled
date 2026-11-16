local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGameDeveloperProductStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameDeveloperProduct/createGameDeveloperProductStore")

return Signals.createComputed(createGameDeveloperProductStore)
