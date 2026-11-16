local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

require(AvatarExperienceSave.Context.AvatarSaveContext)

local function assetOrderRelativeEqual(p, p2, p3): boolean
	local v = {}

	local equippedAssets = p.equipped.EquippedAssets
	local equippedAssets2 = p2.equipped.EquippedAssets

	if equippedAssets == nil and equippedAssets2 == nil then
		return true
	end

	if equippedAssets == nil or equippedAssets2 == nil then
		return false
	end

	for k, equippedAsset in equippedAssets do
		if p3[k] == nil then
			continue
		end

		for k2, v2 in equippedAsset do
			if v2.order ~= nil then
				table.insert(v, { itemId = k2, assetTypeId = k, order = v2.order })
			end
		end
	end

	for _, v2 in p.tryOn.OutfitTryOn.TryOnItems or {} do
		if p3[v2.itemSubType] ~= nil and v2.order ~= nil then
			table.insert(v, { itemId = v2.itemId, assetTypeId = v2.itemSubType, order = v2.order })
		end
	end

	table.sort(v, function(a, b): boolean
		return a.order < b.order
	end)
	local order = nil

	for _, v2 in v do
		if order == nil then
			order = v2.order
		end

		if equippedAssets2[v2.assetTypeId] == nil or equippedAssets2[v2.assetTypeId][v2.itemId] == nil then
			local v3 = false

			for _, v4 in p2.tryOn.OutfitTryOn.TryOnItems or {} do
				if v2.itemId == v4.itemId then
					if v4.order == nil or v4.order < order then
						return false
					end

					order = v4.order
					v3 = true
					break
				end
			end

			if not v3 then
				return false
			end
		elseif
			equippedAssets2[v2.assetTypeId][v2.itemId].order == nil
			or equippedAssets2[v2.assetTypeId][v2.itemId].order < order
		then
			return false
		else
			order = equippedAssets2[v2.assetTypeId][v2.itemId].order
		end
	end

	return true
end

return assetOrderRelativeEqual
