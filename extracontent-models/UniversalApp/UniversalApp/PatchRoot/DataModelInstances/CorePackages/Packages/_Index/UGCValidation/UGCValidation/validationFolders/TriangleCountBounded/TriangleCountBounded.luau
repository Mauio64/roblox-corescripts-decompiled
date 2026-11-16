local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCValidateTriangleLimitTolerance = require(parent.flags.getFIntUGCValidateTriangleLimitTolerance)
local TriangleCountBounded = {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {}
}

local function runAccessoryCheck(object, p)
	local MAX_HAT_TRIANGLES = Constants.MAX_HAT_TRIANGLES

	for k, v in p.renderMeshesData do
		local editableMeshTriCount = UGCValidationService:GetEditableMeshTriCount(v.editable)

		if MAX_HAT_TRIANGLES < editableMeshTriCount then
			object:fail(ErrorSourceStrings.Keys.MeshGeometry_TriangleCountExceeded, {
				meshName = k,
				triangleCount = tostring(editableMeshTriCount),
				maxTriangles = tostring(MAX_HAT_TRIANGLES)
			})
		end
	end
end

local function runBodyPartCheck(object, p)
	local name = p.uploadEnum.assetType.Name
	local v = Constants.ASSET_RENDER_MESH_MAX_TRIANGLES[name]

	if not v then
		return
	end

	local total = 0

	for _, v2 in p.renderMeshesData do
		total += UGCValidationService:GetEditableMeshTriCount(v2.editable)
	end

	if v + v * (getFIntUGCValidateTriangleLimitTolerance() / 100) < total then
		object:fail(ErrorSourceStrings.Keys.MeshGeometry_TotalTriangleCountExceeded, {
			triangleCount = tostring(total),
			assetTypeName = name,
			maxTriangles = tostring(v)
		})
	end
end

function TriangleCountBounded.run(p, p2)
	if
		p2.uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS
		or p2.uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD
	then
		runBodyPartCheck(p, p2)
	else
		runAccessoryCheck(p, p2)
	end
end

return TriangleCountBounded
