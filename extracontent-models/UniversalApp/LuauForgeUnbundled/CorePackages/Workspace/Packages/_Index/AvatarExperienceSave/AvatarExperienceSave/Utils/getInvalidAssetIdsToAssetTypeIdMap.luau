local function getInvalidAssetIdsToAssetTypeIdMap(items, p2)
	local invalidAssetIdsToAssetTypeIdMap = {}

	for k, item in items do
		if not p2[k] then
			invalidAssetIdsToAssetTypeIdMap[k] = item
		end
	end

	return invalidAssetIdsToAssetTypeIdMap
end

return getInvalidAssetIdsToAssetTypeIdMap
