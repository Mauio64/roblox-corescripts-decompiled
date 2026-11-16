local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local floatEquals = require(parent.util.floatEquals)

local BodyBlockingTestsPass = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.FULL_BODY
	},
	requiredData = { ValidationEnums.SharedDataMember.rootInstance, ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function validateMeshMin(object, originalSize: Vector3, k: string)
	local v = {}

	for _, v2 in { "X", "Y", "Z" } do
		if floatEquals(originalSize[v2], 0, 0.0001) then
			table.insert(v, "Size on " .. v2 .. " axis is zero")
		end
	end

	if #v > 0 then
		object:fail(ErrorSourceStrings.Keys.BodyBlocking_ZeroMeshSize, {
			meshName = k,
			details = table.concat(v, ". ")
		})
	end
end

function BodyBlockingTestsPass.run(p, p2)
	for k, v in p2.renderMeshesData do
		validateMeshMin(p, v.originalSize, k)
	end
end

return BodyBlockingTestsPass
