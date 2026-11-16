local parent = script.Parent.Parent

local validateSingleInstance = require(parent.validation.validateSingleInstance)
local validateMeshPartBodyPart = require(parent.validation.validateMeshPartBodyPart)
local validateDynamicHeadData = require(parent.validation.validateDynamicHeadData)

require(parent.util.Types)
local createDynamicHeadMeshPartSchema = require(parent.util.createDynamicHeadMeshPartSchema)

local function validateDynamicHeadMeshPartFormat(p)
	assert(p.instances ~= nil, "instances required in validationContext for validateDynamicHeadMeshPartFormat")

	local instances = p.instances

	local v, v2 = validateSingleInstance(instances, p)

	if not v then
		return v, v2
	end

	local instance = instances[1]

	local v3, v4 = validateMeshPartBodyPart(instance, createDynamicHeadMeshPartSchema(p), p)

	if v3 then
		return validateDynamicHeadData(instance, p)
	end

	return false, v4
end

return validateDynamicHeadMeshPartFormat
