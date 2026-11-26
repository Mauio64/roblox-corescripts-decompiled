local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCreatorInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Creator/createCreatorInfoStore")

return Signals.createComputed(createCreatorInfoStore)
