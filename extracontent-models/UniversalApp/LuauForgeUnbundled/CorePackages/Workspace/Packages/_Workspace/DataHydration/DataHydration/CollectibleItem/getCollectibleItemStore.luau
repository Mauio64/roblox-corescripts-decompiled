local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createCollectibleItemStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CollectibleItem/createCollectibleItemStore")

return Signals.createComputed(createCollectibleItemStore)
