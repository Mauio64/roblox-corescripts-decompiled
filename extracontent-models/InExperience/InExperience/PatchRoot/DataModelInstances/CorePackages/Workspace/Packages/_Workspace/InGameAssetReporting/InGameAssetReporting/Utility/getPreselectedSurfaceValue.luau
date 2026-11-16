local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.Analysis.SceneAnalysis)

function getPreselectedSurfaceValue(p): nil | string
	if p == nil then
		return nil
	end

	local extractedAssets = p.extractedAssets

	if #p.extractedPlayers > 0 then
		return "avatar"
	end

	if
		#extractedAssets.Image > 0
		or #extractedAssets.Mesh > 0
		or #extractedAssets.Model > 0
		or #extractedAssets.Package > 0
		or #extractedAssets.Video > 0
	then
		return "item"
	end

	return if #extractedAssets.Text > 0 then "text" else nil
end

return getPreselectedSurfaceValue
