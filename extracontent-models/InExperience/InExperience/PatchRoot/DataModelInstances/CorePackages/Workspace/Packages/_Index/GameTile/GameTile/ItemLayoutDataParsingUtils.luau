local GameTile = script:FindFirstAncestor("GameTile")

require(GameTile.GameTileTypes)

return {
	getWideImageAssetId = function(p)
		if
			p
			and p.primaryMediaAsset
			and p.primaryMediaAsset.wideImageAssetId
			and p.primaryMediaAsset.wideImageAssetId ~= ""
		then
			return p.primaryMediaAsset.wideImageAssetId
		end

		return nil
	end
}
