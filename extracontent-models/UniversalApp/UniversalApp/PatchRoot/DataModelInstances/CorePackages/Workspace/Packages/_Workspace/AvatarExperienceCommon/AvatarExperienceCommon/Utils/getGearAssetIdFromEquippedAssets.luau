local function getGearAssetIdFromEquippedAssets(t1: {[any]: any}) -- line: 1
	local num = nil
	local v4 = t1[tostring(Enum.AssetType.Gear.Value)]

	if v4 then
		local v5, _ = next(v4)

		if v5 then
			num = tonumber(v5)
		end
	end

	return num
end

return getGearAssetIdFromEquippedAssets
