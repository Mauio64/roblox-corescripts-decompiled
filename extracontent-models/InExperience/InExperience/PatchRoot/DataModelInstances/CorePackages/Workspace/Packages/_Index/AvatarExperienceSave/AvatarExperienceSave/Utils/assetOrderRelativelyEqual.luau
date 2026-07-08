local AvatarExperienceSave = script:FindFirstAncestor("AvatarExperienceSave")

require(AvatarExperienceSave.Context.AvatarSaveContext)

local function assetOrderRelativeEqual(p1, p2, t1: {[any]: any}) -- line: 17
	local t2 = {}
	local EquippedAssets = p1.equipped.EquippedAssets
	local EquippedAssets2 = p2.equipped.EquippedAssets

	if EquippedAssets == nil and EquippedAssets2 == nil then
		return true
	end

	if EquippedAssets == nil or EquippedAssets2 == nil then
		return false
	end

	for v9, v10 in EquippedAssets do
		if t1[v9] ~= nil then
			for v11, v12 in v10 do
				if v12.order ~= nil then
					table.insert(t2, {
						itemId = v11,
						assetTypeId = v9,
						order = v12.order
					})
				end
			end
		end
	end

	for _, v14 in p1.tryOn.OutfitTryOn.TryOnItems or {} do
		if t1[v14.itemSubType] ~= nil and v14.order ~= nil then
			table.insert(t2, {
				itemId = v14.itemId,
				assetTypeId = v14.itemSubType,
				order = v14.order
			})
		end
	end

	table.sort(t2, function(p3, p4) -- line: 61
		return p3.order < p4.order
	end)

	local order = nil

	for _, v17 in t2 do
		if order == nil then
			order = v17.order
		end

		if EquippedAssets2[v17.assetTypeId] == nil or EquippedAssets2[v17.assetTypeId][v17.itemId] == nil then
			local v18 = false

			for _, v20 in p2.tryOn.OutfitTryOn.TryOnItems or {} do
				if v17.itemId == v20.itemId then
					if v20.order == nil or order > v20.order then
						return false
					end

					v18 = true
					order = v20.order

					break
				end
			end

			if v18 then
				continue
			end

			return false
		end

		if EquippedAssets2[v17.assetTypeId][v17.itemId].order == nil or order > EquippedAssets2[v17.assetTypeId][v17.itemId].order then
			return false
		end

		order = EquippedAssets2[v17.assetTypeId][v17.itemId].order
	end

	return true
end

return assetOrderRelativeEqual
