local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createMediaAssetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MediaAsset/createMediaAssetStore")

return Signals.createComputed(createMediaAssetStore)
