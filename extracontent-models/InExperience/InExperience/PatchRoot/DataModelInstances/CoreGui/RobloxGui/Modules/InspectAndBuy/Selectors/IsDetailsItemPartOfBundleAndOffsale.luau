return function(p1) -- line: 4
	local assetId = p1.detailsInformation.assetId

	if assetId == nil then
		return nil
	end

	local v3 = p1.assets[assetId]

	return v3 and v3.parentBundleId ~= nil
end
