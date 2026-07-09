local function getEquippedAssetIdsByAssetTypeId(p1, s1: string) -- line: 1
	local t1 = {}

	if not p1 then
		return t1
	end

	local v5 = p1[s1]

	if v5 then
		for v6, _ in v5 do
			table.insert(t1, v6)
		end
	end

	return t1
end

return getEquippedAssetIdsByAssetTypeId
