require("@luauforge/bundled/dHL")
require("@luauforge/bundled/dHK")

local function fn(equippedAssets, selectedAccessory)
	for k, item in equippedAssets do
		for k2, v5 in item do
			if selectedAccessory == k2 then
				return k
			end
		end
	end

	return nil
end

local function fn2(tryOnItems, bundleInfos, assetInfos, selectedAccessory)
	for k, item in tryOnItems do
		if item.itemType == "Asset" and item.itemId == selectedAccessory then
			return item.itemSubType
		end

		if item.itemType ~= "Bundle" then
			continue
		end

		local v5 = bundleInfos[item.itemId]

		if not v5 then
			continue
		end

		local items = v5.items

		if items == nil then
			continue
		end

		for k2, item2 in items do
			if not (item2.type == "Asset" and item2.id == selectedAccessory) then
				continue
			end

			local v6 = assetInfos[item2.id]

			if v6 and v6.assetType then
				return v6.assetType
			end
		end
	end

	return nil
end

return function(p2)
	local tryOnItems = p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems
	local bundleInfos = p2.AvatarExperience.Common.BundleInfos
	local assetInfos = p2.AvatarExperience.Common.AssetInfos
	local equippedAssets = p2.AvatarExperience.AvatarEditor.Character.EquippedAssets
	local selectedAccessory = p2.AvatarExperience.AccessoryAdjustment.SelectedAccessory

	local v5 = fn2(tryOnItems, bundleInfos, assetInfos, selectedAccessory)

	if v5 then
		return v5
	end

	local v6 = fn(equippedAssets, selectedAccessory)

	if v6 then
		return v6
	end

	return nil
end
