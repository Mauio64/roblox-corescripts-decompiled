local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceCatalogCategoryStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceCatalogCategory/createMarketplaceCatalogCategoryStore")

return Signals.createComputed(createMarketplaceCatalogCategoryStore)
