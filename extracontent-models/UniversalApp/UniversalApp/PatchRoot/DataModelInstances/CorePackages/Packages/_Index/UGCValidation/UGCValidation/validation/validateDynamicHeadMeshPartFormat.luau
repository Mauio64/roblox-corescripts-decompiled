local ParentParent = script.Parent.Parent
local validateSingleInstance = require(ParentParent.validation.validateSingleInstance)
local validateMeshPartBodyPart = require(ParentParent.validation.validateMeshPartBodyPart)
local validateDynamicHeadData = require(ParentParent.validation.validateDynamicHeadData)

require(ParentParent.util.Types)

local createDynamicHeadMeshPartSchema = require(ParentParent.util.createDynamicHeadMeshPartSchema)

local function validateDynamicHeadMeshPartFormat(p1) -- line: 10
	-- upvalues: validateSingleInstance (copy), validateMeshPartBodyPart (copy), createDynamicHeadMeshPartSchema (copy), validateDynamicHeadData (copy)
	assert(p1.instances ~= nil, "instances required in validationContext for validateDynamicHeadMeshPartFormat")

	local instances = p1.instances
	local v9, v10 = validateSingleInstance(instances, p1)

	if not v9 then
		return v9, v10
	end

	local v11 = instances[1]
	local v12, v13 = validateMeshPartBodyPart(v11, createDynamicHeadMeshPartSchema(p1), p1)

	if not v12 then
		return false, v13
	end

	return validateDynamicHeadData(v11, p1)
end

return validateDynamicHeadMeshPartFormat
