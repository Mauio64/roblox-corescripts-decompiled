local function getGearAssetIdFromEquippedAssets(p2)
	local gearAssetId = nil
	local v5 = p2[tostring(Enum.AssetType.Gear.Value)]

	if v5 then
		local v6, v7 = next(v5)

		if v6 then
			gearAssetId = tonumber(v6)
		end
	end

	return gearAssetId
end

return getGearAssetIdFromEquippedAssets
