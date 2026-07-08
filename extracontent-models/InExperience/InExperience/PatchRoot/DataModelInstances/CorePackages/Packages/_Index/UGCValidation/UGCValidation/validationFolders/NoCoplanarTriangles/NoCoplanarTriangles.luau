local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local floatEquals = require(ParentParent.util.floatEquals)
local getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality)
local getFIntMaxCoplanarIntersectionsPercentage = require(ParentParent.flags.getFIntMaxCoplanarIntersectionsPercentage)
local getFFlagUGCValidateCoplanarTriTestBody = require(ParentParent.flags.getFFlagUGCValidateCoplanarTriTestBody)

return {
	fflag = getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality,
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 38
		-- upvalues: ValidationEnums (copy), getFFlagUGCValidateCoplanarTriTestBody (copy), floatEquals (copy), UGCValidationService (copy), getFIntMaxCoplanarIntersectionsPercentage (copy), ErrorSourceStrings (copy)
		local uploadCategory = p2.uploadCategory

		if (uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD) and not getFFlagUGCValidateCoplanarTriTestBody() then
			return
		end

		for v12, v13 in p2.renderMeshesData do
			local editable = v13.editable
			local scale = v13.scale
			local originalSize = v13.originalSize

			if not floatEquals(originalSize.X, 0) and not floatEquals(originalSize.Y, 0) and not floatEquals(originalSize.Z, 0) then
				local EditableMeshTriCount = UGCValidationService:GetEditableMeshTriCount(editable)
				local v18 = math.floor(getFIntMaxCoplanarIntersectionsPercentage() / 100 * EditableMeshTriCount)

				if UGCValidationService:IsEditableMeshNumCoplanarIntersectionsOverLimit(editable, v18, scale, true) then
					p1:fail(ErrorSourceStrings.Keys.CoplanarTri_TooMany, {
						MeshName = v12,
						MaxIntersections = tostring(v18),
						TriangleCount = tostring(EditableMeshTriCount)
					})
				end
			end
		end
	end
}
