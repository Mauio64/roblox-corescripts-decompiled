local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local floatEquals = require(ParentParent.util.floatEquals)
local getFFlagUGCValidateMigratePoseBlocking = require(ParentParent.flags.getFFlagUGCValidateMigratePoseBlocking)
local t1 = {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.FULL_BODY
	},
	requiredData = {
		ValidationEnums.SharedDataMember.rootInstance,
		ValidationEnums.SharedDataMember.renderMeshesData
	},
	fflag = getFFlagUGCValidateMigratePoseBlocking,
	expectedFailures = {}
}

local function validateMeshMin(p1, vector3: Vector3, s1: string) -- line: 35
	-- upvalues: floatEquals (copy), ErrorSourceStrings (copy)
	local t2 = {}

	for _, v13 in {
		"X",
		"Y",
		"Z"
	} do
		local v14 = vector3[v13]

		if floatEquals(v14, 0, 0.0001) then
			table.insert(t2, "Size on " .. v13 .. " axis is zero")
		end
	end

	if #t2 > 0 then
		p1:fail(ErrorSourceStrings.Keys.BodyBlocking_ZeroMeshSize, {
			meshName = s1,
			details = table.concat(t2, ". ")
		})
	end
end

function t1.run(p2, p3) -- line: 53
	-- upvalues: validateMeshMin (copy)
	for v17, v18 in p3.renderMeshesData do
		validateMeshMin(p2, v18.originalSize, v17)
	end
end

return t1
