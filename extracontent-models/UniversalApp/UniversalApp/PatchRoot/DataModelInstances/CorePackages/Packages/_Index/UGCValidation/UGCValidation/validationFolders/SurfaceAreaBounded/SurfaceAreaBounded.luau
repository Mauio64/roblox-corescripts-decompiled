local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFIntMaxTotalSurfaceArea = require(ParentParent.flags.getFIntMaxTotalSurfaceArea)

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateMeshGeometry),
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 24
		-- upvalues: UGCValidationService (copy), getFIntMaxTotalSurfaceArea (copy), ErrorSourceStrings (copy)
		for v8, v9 in p2.renderMeshesData do
			local v10 = UGCValidationService:CalculateEditableMeshTotalSurfaceArea(v9.editable, v9.scale)

			if v10 > getFIntMaxTotalSurfaceArea() then
				p1:fail(ErrorSourceStrings.Keys.MeshGeometry_SurfaceAreaExceeded, {
					meshName = v8,
					surfaceArea = string.format("%.2f", v10),
					maxSurfaceArea = tostring(getFIntMaxTotalSurfaceArea())
				})
			end
		end
	end
}
