local parent = script.Parent.Parent

require(parent.util.Types)

local validateLayeredClothingAccessory = require(parent.validation.validateLayeredClothingAccessory)

local validateLayeredClothingAccessoryMeshPartAssetFormatMatch = require(parent.validation.validateLayeredClothingAccessoryMeshPartAssetFormatMatch)

local function validateLayeredClothingAccessoryMeshPartAssetFormat(p, p2)
	assert(
		p2.instances ~= nil,
		"instances required in validationContext for validateLayeredClothingAccessoryMeshPartAssetFormat"
	)

	local instances = p2.instances

	local v, v2 = validateLayeredClothingAccessory(p2)

	if not v then
		return false, v2
	end

	local v3, v4 = validateLayeredClothingAccessoryMeshPartAssetFormatMatch(instances[1], p, p2)

	if v3 then
		return true
	end

	return false, v4
end

return validateLayeredClothingAccessoryMeshPartAssetFormat
