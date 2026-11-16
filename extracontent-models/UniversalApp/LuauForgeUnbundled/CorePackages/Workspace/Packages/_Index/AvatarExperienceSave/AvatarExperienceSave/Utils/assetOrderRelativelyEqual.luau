require("@game/CorePackages/Workspace/Packages/_Index/AvatarExperienceSave/AvatarExperienceSave/Context/AvatarSaveContext")

local function assetOrderRelativeEqual(p2, p3, p4): boolean
	local v5 = {}

	local equippedAssets = p2.equipped.EquippedAssets
	local equippedAssets2 = p3.equipped.EquippedAssets

	if equippedAssets == nil and equippedAssets2 == nil then
		return true
	end

	if equippedAssets == nil or equippedAssets2 == nil then
		return false
	end

	for k, equippedAsset in equippedAssets do
		if p4[k] == nil then
			continue
		end

		for k2, v6 in equippedAsset do
			if v6.order ~= nil then
				table.insert(v5, { itemId = k2, assetTypeId = k, order = v6.order })
			end
		end
	end

	for k, v6 in p2.tryOn.OutfitTryOn.TryOnItems or {} do
		if p4[v6.itemSubType] ~= nil and v6.order ~= nil then
			table.insert(v5, {
				itemId = v6.itemId,
				assetTypeId = v6.itemSubType,
				order = v6.order
			})
		end
	end

	table.sort(v5, function(a, b): boolean
		return a.order < b.order
	end)
	local order = nil

	for k, v6 in v5 do
		if order == nil then
			order = v6.order
		end

		if equippedAssets2[v6.assetTypeId] == nil or equippedAssets2[v6.assetTypeId][v6.itemId] == nil then
			local v7 = false

			for k2, v9 in p3.tryOn.OutfitTryOn.TryOnItems or {} do
				if v6.itemId == v9.itemId then
					if v9.order == nil or v9.order < order then
						return false
					end

					order = v9.order
					v7 = true
					break
				end
			end

			if not v7 then
				return false
			end
		elseif
			equippedAssets2[v6.assetTypeId][v6.itemId].order == nil
			or equippedAssets2[v6.assetTypeId][v6.itemId].order < order
		then
			return false
		else
			order = equippedAssets2[v6.assetTypeId][v6.itemId].order
		end
	end

	return true
end

return assetOrderRelativeEqual
