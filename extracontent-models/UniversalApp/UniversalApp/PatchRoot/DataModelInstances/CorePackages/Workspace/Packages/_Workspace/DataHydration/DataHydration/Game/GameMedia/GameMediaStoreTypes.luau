local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local t = require(DataHydrationParent.t)

require(DataHydration.DataHydrationTypes)

local MediaAssetStoreTypes = require(DataHydration.MediaAsset.MediaAssetStoreTypes)

return {
	gameMediaResponseValidator = t.interface({
		data = t.array(MediaAssetStoreTypes.mediaAssetResponseItemValidator)
	})
}
