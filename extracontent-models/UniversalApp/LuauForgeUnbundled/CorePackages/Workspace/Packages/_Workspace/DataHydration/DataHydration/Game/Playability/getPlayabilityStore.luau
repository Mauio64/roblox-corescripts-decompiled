local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPlayabilityStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Playability/createPlayabilityStore")

return Signals.createComputed(createPlayabilityStore)
