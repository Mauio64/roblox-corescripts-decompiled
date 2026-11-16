return function(p)
	local assetId = p.detailsInformation.assetId

	if assetId == nil then
		return nil
	end

	local asset = p.assets[assetId]

	return asset and asset.parentBundleId ~= nil
end
