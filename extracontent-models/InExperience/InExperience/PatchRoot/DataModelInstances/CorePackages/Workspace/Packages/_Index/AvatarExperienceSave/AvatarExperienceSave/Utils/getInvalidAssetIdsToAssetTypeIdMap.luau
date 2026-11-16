local function getInvalidAssetIdsToAssetTypeIdMap(items, p)
	local invalidAssetIdsToAssetTypeIdMap = {}

	for k, item in items do
		if not p[k] then
			invalidAssetIdsToAssetTypeIdMap[k] = item
		end
	end

	return invalidAssetIdsToAssetTypeIdMap
end

return getInvalidAssetIdsToAssetTypeIdMap
