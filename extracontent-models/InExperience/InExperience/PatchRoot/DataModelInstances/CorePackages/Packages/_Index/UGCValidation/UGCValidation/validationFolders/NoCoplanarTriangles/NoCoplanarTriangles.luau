local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local floatEquals = require(parent.util.floatEquals)

local getFIntMaxCoplanarIntersectionsPercentage = require(parent.flags.getFIntMaxCoplanarIntersectionsPercentage)
local getFFlagUGCValidateCoplanarTriTestBody = require(parent.flags.getFFlagUGCValidateCoplanarTriTestBody)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(object, p)
		local uploadCategory = p.uploadCategory

		if
			(uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD)
			and not getFFlagUGCValidateCoplanarTriTestBody()
		then
			return
		end

		for k, v in p.renderMeshesData do
			local editable = v.editable
			local scale = v.scale

			local originalSize = v.originalSize

			if floatEquals(originalSize.X, 0) or floatEquals(originalSize.Y, 0) or floatEquals(originalSize.Z, 0) then
				continue
			end

			local editableMeshTriCount = UGCValidationService:GetEditableMeshTriCount(editable)
			local v2 = math.floor(getFIntMaxCoplanarIntersectionsPercentage() / 100 * editableMeshTriCount)

			if UGCValidationService:IsEditableMeshNumCoplanarIntersectionsOverLimit(editable, v2, scale, true) then
				object:fail(ErrorSourceStrings.Keys.CoplanarTri_TooMany, {
					MeshName = k,
					MaxIntersections = tostring(v2),
					TriangleCount = tostring(editableMeshTriCount)
				})
			end
		end
	end
}
