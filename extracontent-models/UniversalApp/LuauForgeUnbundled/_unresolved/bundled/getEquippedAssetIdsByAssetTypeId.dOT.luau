local function getEquippedAssetIdsByAssetTypeId(p2, p3)
	local equippedAssetIds = {}

	if not p2 then
		return equippedAssetIds
	end

	local v5 = p2[p3]

	if v5 then
		for k, v6 in v5 do
			table.insert(equippedAssetIds, k)
		end
	end

	return equippedAssetIds
end

return getEquippedAssetIdsByAssetTypeId
