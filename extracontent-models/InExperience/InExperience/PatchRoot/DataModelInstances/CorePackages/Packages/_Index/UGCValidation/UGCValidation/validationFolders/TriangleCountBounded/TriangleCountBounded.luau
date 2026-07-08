local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent
local Constants = require(ParentParent.Constants)

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFIntUGCValidateTriangleLimitTolerance = require(ParentParent.flags.getFIntUGCValidateTriangleLimitTolerance)
local t1 = {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry),
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function runAccessoryCheck(p1, p2) -- line: 25
	-- upvalues: Constants (copy), UGCValidationService (copy), ErrorSourceStrings (copy)
	local MAX_HAT_TRIANGLES = Constants.MAX_HAT_TRIANGLES

	for v13, v14 in p2.renderMeshesData do
		local EditableMeshTriCount = UGCValidationService:GetEditableMeshTriCount(v14.editable)

		if MAX_HAT_TRIANGLES < EditableMeshTriCount then
			p1:fail(ErrorSourceStrings.Keys.MeshGeometry_TriangleCountExceeded, {
				meshName = v13,
				triangleCount = tostring(EditableMeshTriCount),
				maxTriangles = tostring(MAX_HAT_TRIANGLES)
			})
		end
	end
end
local function runBodyPartCheck(p3, p4) -- line: 41
	-- upvalues: Constants (copy), UGCValidationService (copy), getFIntUGCValidateTriangleLimitTolerance (copy), ErrorSourceStrings (copy)
	local assetTypeName = p4.uploadEnum.assetType.Name
	local v19 = Constants.ASSET_RENDER_MESH_MAX_TRIANGLES[assetTypeName]

	if not v19 then
		return
	end

	local n1 = 0

	for _, v22 in p4.renderMeshesData do
		n1 += UGCValidationService:GetEditableMeshTriCount(v22.editable)
	end

	if n1 > v19 + v19 * (getFIntUGCValidateTriangleLimitTolerance() / 100) then
		p3:fail(ErrorSourceStrings.Keys.MeshGeometry_TotalTriangleCountExceeded, {
			triangleCount = tostring(n1),
			assetTypeName = assetTypeName,
			maxTriangles = tostring(v19)
		})
	end
end

function t1.run(p5, p6) -- line: 67
	-- upvalues: ValidationEnums (copy), runBodyPartCheck (copy), runAccessoryCheck (copy)
	if p6.uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS or p6.uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD then
		runBodyPartCheck(p5, p6)

		return
	end

	runAccessoryCheck(p5, p6)
end

return t1
