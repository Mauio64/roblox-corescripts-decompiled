local ParentParent = script.Parent.Parent

require(ParentParent.util.Types)

local validateLayeredClothingAccessory = require(ParentParent.validation.validateLayeredClothingAccessory)
local validateLayeredClothingAccessoryMeshPartAssetFormatMatch = require(ParentParent.validation.validateLayeredClothingAccessoryMeshPartAssetFormatMatch)

local function validateLayeredClothingAccessoryMeshPartAssetFormat(p1, p2) -- line: 9
	-- upvalues: validateLayeredClothingAccessory (copy), validateLayeredClothingAccessoryMeshPartAssetFormatMatch (copy)
	assert(p2.instances ~= nil, "instances required in validationContext for validateLayeredClothingAccessoryMeshPartAssetFormat")

	local instances = p2.instances
	local v8, v9 = validateLayeredClothingAccessory(p2)

	if not v8 then
		return false, v9
	end

	local v10 = instances[1]
	local v11, v12 = validateLayeredClothingAccessoryMeshPartAssetFormatMatch(v10, p1, p2)

	if not v11 then
		return false, v12
	end

	return true
end

return validateLayeredClothingAccessoryMeshPartAssetFormat
