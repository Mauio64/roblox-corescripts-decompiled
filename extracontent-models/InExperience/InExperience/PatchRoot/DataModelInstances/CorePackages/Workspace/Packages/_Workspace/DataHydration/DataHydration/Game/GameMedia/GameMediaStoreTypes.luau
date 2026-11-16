local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local t = require(parent.t)

require(DataHydration.DataHydrationTypes)
local MediaAssetStoreTypes = require(DataHydration.MediaAsset.MediaAssetStoreTypes)

return {
	gameMediaResponseValidator = t.interface({
		data = t.array(MediaAssetStoreTypes.mediaAssetResponseItemValidator)
	})
}
