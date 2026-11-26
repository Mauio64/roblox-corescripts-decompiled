local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceCatalogSortStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceCatalogSort/createMarketplaceCatalogSortStore")

return Signals.createComputed(createMarketplaceCatalogSortStore)
