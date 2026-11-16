local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceLookStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceLook/createMarketplaceLookStore")

return Signals.createComputed(createMarketplaceLookStore)
