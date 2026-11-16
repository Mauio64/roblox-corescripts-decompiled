require("@game/CorePackages/Workspace/Packages/_Index/GameTile/GameTile/GameTileTypes")

return {
	getWideImageAssetId = function(p2)
		if
			p2
			and p2.primaryMediaAsset
			and p2.primaryMediaAsset.wideImageAssetId
			and p2.primaryMediaAsset.wideImageAssetId ~= ""
		then
			return p2.primaryMediaAsset.wideImageAssetId
		end

		return nil
	end
}
