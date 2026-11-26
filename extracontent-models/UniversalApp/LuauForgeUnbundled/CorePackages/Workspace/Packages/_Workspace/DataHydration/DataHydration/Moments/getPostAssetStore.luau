local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createPostAssetStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/createPostAssetStore")

return Signals.createComputed(function(p2)
	return createPostAssetStore()
end)
