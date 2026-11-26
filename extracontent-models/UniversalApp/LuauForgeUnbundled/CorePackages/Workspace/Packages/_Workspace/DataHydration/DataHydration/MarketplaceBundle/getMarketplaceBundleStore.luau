local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceBundleStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceBundle/createMarketplaceBundleStore")

return Signals.createComputed(createMarketplaceBundleStore)
