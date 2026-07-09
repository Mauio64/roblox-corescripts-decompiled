local GameTile = script:FindFirstAncestor("GameTile")

require(GameTile.GameTileTypes)

return {
	getWideImageAssetId = function(p1) -- line: 9
		if p1 and (p1.primaryMediaAsset and p1.primaryMediaAsset.wideImageAssetId and p1.primaryMediaAsset.wideImageAssetId ~= "") then
			return p1.primaryMediaAsset.wideImageAssetId
		end

		return nil
	end
}
