local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	fflag = require(ParentParent.flags.getFFlagUGCValidateMigrateSurfaceAppearanceMeshQuality),
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD,
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY
	},
	requiredData = { ValidationEnums.SharedDataMember.renderMeshesData },
	expectedFailures = {},
	run = function(p1, p2) -- line: 35
		-- upvalues: ValidationEnums (copy), UGCValidationService (copy), ErrorSourceStrings (copy)
		local uploadCategory = p2.uploadCategory
		local v8 = uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD

		for v9, v10 in p2.renderMeshesData do
			local editable = v10.editable

			if not UGCValidationService:ValidateEditableMeshVertColors(editable, v8) then
				p1:fail(ErrorSourceStrings.Keys.VertexColors_NotOpaque, {
					MeshName = v9,
					TransparencyNote = not v8 and "" or "with no transparency"
				})
			end
		end
	end
}
