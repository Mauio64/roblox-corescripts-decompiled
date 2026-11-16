local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMarketplaceAssetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MarketplaceAsset/createMarketplaceAssetStore")

return Signals.createComputed(createMarketplaceAssetStore)
