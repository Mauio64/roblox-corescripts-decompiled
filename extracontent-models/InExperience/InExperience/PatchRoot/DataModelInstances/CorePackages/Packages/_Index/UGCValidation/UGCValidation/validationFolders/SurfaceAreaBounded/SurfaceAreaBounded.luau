local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntMaxTotalSurfaceArea = require(parent.flags.getFIntMaxTotalSurfaceArea)
return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(object, p)
		for k, v in p.renderMeshesData do
			local editableMeshTotalSurfaceArea = UGCValidationService:CalculateEditableMeshTotalSurfaceArea(
				v.editable,
				v.scale
			)

			if getFIntMaxTotalSurfaceArea() < editableMeshTotalSurfaceArea then
				object:fail(ErrorSourceStrings.Keys.MeshGeometry_SurfaceAreaExceeded, {
					meshName = k,
					surfaceArea = string.format("%.2f", editableMeshTotalSurfaceArea),
					maxSurfaceArea = tostring(getFIntMaxTotalSurfaceArea())
				})
			end
		end
	end
}
