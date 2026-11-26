local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/t")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local MediaAssetStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/MediaAsset/MediaAssetStoreTypes")

return {
	gameMediaResponseValidator = t.interface({
		data = t.array(MediaAssetStoreTypes.mediaAssetResponseItemValidator)
	})
}
