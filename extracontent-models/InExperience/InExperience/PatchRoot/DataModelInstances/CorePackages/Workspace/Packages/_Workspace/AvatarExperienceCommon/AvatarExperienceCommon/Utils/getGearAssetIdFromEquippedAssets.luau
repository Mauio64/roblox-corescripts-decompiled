local function getGearAssetIdFromEquippedAssets(p)
	local gearAssetId = nil
	local v = p[tostring(Enum.AssetType.Gear.Value)]

	if v then
		local v2, _ = next(v)

		if v2 then
			gearAssetId = tonumber(v2)
		end
	end

	return gearAssetId
end

return getGearAssetIdFromEquippedAssets
