local InGameAssetReporting = script:FindFirstAncestor("InGameAssetReporting")

require(InGameAssetReporting.Analysis.SceneAnalysis)

function getPreselectedSurfaceValue(p1) -- line: 14
	if p1 == nil then
		return nil
	end

	local extractedAssets = p1.extractedAssets

	if #p1.extractedPlayers > 0 then
		return "avatar"
	end

	if #extractedAssets.Image > 0 or #extractedAssets.Mesh > 0 or #extractedAssets.Model > 0 or #extractedAssets.Package > 0 or #extractedAssets.Video > 0 then
		return "item"
	end

	if #extractedAssets.Text > 0 then
		return "text"
	end

	return nil
end

return getPreselectedSurfaceValue
