local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGamePassStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GamePass/createGamePassStore")

return Signals.createComputed(createGamePassStore)
