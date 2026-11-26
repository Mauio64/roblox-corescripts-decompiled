local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createGameMediaStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameMedia/createGameMediaStore")

return Signals.createComputed(createGameMediaStore)
