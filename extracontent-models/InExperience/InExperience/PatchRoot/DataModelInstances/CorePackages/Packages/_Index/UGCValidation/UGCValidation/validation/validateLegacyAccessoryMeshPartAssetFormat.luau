local parent = script.Parent.Parent

require(parent.util.Types)

local createLegacyAccessoryMeshPartAssetFormatSchema = require(parent.util.createLegacyAccessoryMeshPartAssetFormatSchema)

local validateSingleInstance = require(parent.validation.validateSingleInstance)
local validateInstanceTree = require(parent.validation.validateInstanceTree)

local validateLegacyAccessoryMeshPartAssetFormatMatch = require(parent.validation.validateLegacyAccessoryMeshPartAssetFormatMatch)
local ValidatePropertiesSensible = require(parent.validation.ValidatePropertiesSensible)

local getEngineFeatureEngineUGCValidatePropertiesSensible = require(parent.flags.getEngineFeatureEngineUGCValidatePropertiesSensible)

local function validateLegacyAccessoryMeshPartAssetFormat(instance, p)
	assert(p.instances ~= nil, "instances required in validationContext for validateLegacyAccessoryMeshPartAssetFormat")

	local instances = p.instances

	local v, v2 = validateSingleInstance(instances, p)

	if not v then
		return false, v2
	end

	local instance2 = instances[1]

	local v3, v4 = validateInstanceTree(
		createLegacyAccessoryMeshPartAssetFormatSchema(instance:FindFirstChild("Handle"):FindFirstChildOfClass("Attachment").Name),
		instance2,
		p
	)

	if not v3 then
		return false, v4
	end

	if getEngineFeatureEngineUGCValidatePropertiesSensible() then
		local v5, v6 = ValidatePropertiesSensible.validate(instance2, p)

		if not v5 then
			return false, v6
		end
	end

	local v5, v6 = validateLegacyAccessoryMeshPartAssetFormatMatch(instance2, instance, p)

	if v5 then
		return true
	end

	return false, v6
end

return validateLegacyAccessoryMeshPartAssetFormat
