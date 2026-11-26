local module = require("@luauforge/bundled/fCh")
local module2 = require("@luauforge/bundled/fCi")
local module3 = require("@luauforge/bundled/fCe")
local module4 = require("@luauforge/bundled/dPN")

local v5 = {}

function v5.sliderInfoToVector3s(p2)
	return
		Vector3.new(p2[module2.PositionX], p2[module2.PositionY], p2[module2.PositionZ]),
		Vector3.new(p2[module2.RotationX], p2[module2.RotationY], p2[module2.RotationZ]),
		(Vector3.new(p2[module2.Scale], p2[module2.Scale], p2[module2.Scale]))
end

function v5.vector3sToSliderInfo(data, data2, p2)
	return {
		[module2.PositionX] = data.X,
		[module2.PositionY] = data.Y,
		[module2.PositionZ] = data.Z,
		[module2.RotationX] = data2.X,
		[module2.RotationY] = data2.Y,
		[module2.RotationZ] = data2.Z,
		[module2.Scale] = p2.X
	}
end

function v5.getEquippedSliderValues(items, p2)
	for k, item in items do
		for k2, v6 in item do
			if k2 == p2 then
				local v7 = if v6.position then v6.position else Vector3.new()
				local v8 = if v6.rotation then v6.rotation else Vector3.new()
				local v9 = not v6.scale and Vector3.new(1, 1, 1) or v6.scale
				return v5.vector3sToSliderInfo(v7, v8, v9)
			end
		end
	end

	return nil
end

function v5.getTryOnAdjustments(data)
	local v6 = if data.position then data.position else Vector3.new()
	local v7 = if data.rotation then data.rotation else Vector3.new()
	local v8 = not data.scale and Vector3.new(1, 1, 1) or data.scale
	return v5.vector3sToSliderInfo(v6, v7, v8)
end

function v5.getTryOnSliderValues(items, p2)
	for k, item in items do
		local v6 = item.itemType == "Asset" and item.itemId == p2

		if v6 then
			return v5.getTryOnAdjustments(item)
		end

		if item.itemType ~= "Bundle" then
			continue
		end

		for k2, item2 in items do
			if item2.bundleInfo and item2.bundleInfo[p2] then
				local v7 = item2.bundleInfo[p2]
				return v5.getTryOnAdjustments(v7)
			end
		end
	end

	return module.DefaultSliderValues
end

local function checkTryOnItemForAdjustment(data)
	return data.position and data.position ~= Vector3.new() and true
		or data.rotation and data.rotation ~= Vector3.new() and true
		or data.scale and data.scale ~= Vector3.new(1, 1, 1) and true
		or false
end

function v5.checkTryOnHasAdjustments(items, p2)
	for k, item in items do
		local v6 = item.itemType == "Asset" and item.itemId == p2

		if v6 then
			return item.position and item.position ~= Vector3.new() and true
				or item.rotation and item.rotation ~= Vector3.new() and true
				or item.scale and item.scale ~= Vector3.new(1, 1, 1) and true
				or false
		end

		if item.itemType ~= "Bundle" then
			continue
		end

		for k2, item2 in items do
			if item2.bundleInfo and item2.bundleInfo[p2] then
				local v7 = item2.bundleInfo[p2]
				return v7.position and v7.position ~= Vector3.new() and true
					or v7.rotation and v7.rotation ~= Vector3.new() and true
					or v7.scale and v7.scale ~= Vector3.new(1, 1, 1) and true
					or false
			end
		end
	end

	return false
end

function v5.getSliderValuesWithDefault(p2, p3, p4)
	return v5.getEquippedSliderValues(p2, p4)
		or v5.getTryOnSliderValues(p3, p4)
		or module.DefaultSliderValues
end

function v5.checkSliderValuesChanged(p2, items)
	local v6 = false

	for k, item in items do
		if not module3.fuzzyEq(p2[k], item) then
			v6 = true
		end
	end

	return v6
end

function v5.getAdjustableAccessories(object, items)
	local accessories = object:GetAccessories(true)

	local set = {}
	local assetIds = {}

	for k, item in items do
		set[tostring(item)] = true
	end

	for k, accessory in accessories do
		if
			not set[module4.AccessoryTypeEnumToAssetTypeId[accessory.AccessoryType]]
			or accessory.IsLayered
		then
			continue
		end

		local selectedAccessoryDescription = module3.getSelectedAccessoryDescription(
			object,
			accessory.AssetId
		)

		if selectedAccessoryDescription then
			local success, result = pcall(function()
				return selectedAccessoryDescription:GetAppliedInstance()
			end)

			if success then
				local handle = result:FindFirstChild("Handle")

				if handle and handle:IsA("MeshPart") and handle.HasSkinnedMesh then
					continue
				end
			end
		end

		table.insert(assetIds, (tostring(accessory.AssetId)))
	end

	return assetIds
end

return v5
