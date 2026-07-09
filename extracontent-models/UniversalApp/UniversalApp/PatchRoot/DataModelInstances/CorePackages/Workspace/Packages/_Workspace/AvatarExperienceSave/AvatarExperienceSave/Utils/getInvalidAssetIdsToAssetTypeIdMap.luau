local function getInvalidAssetIdsToAssetTypeIdMap(t1: {[any]: any}, t2: {[any]: any}) -- line: 1
	local t3 = {}

	for v5, v6 in t1 do
		if not t2[v5] then
			t3[v5] = v6
		end
	end

	return t3
end

return getInvalidAssetIdsToAssetTypeIdMap
