local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

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

		local v = uploadCategory == ValidationEnums.UploadCategory.TORSO_AND_LIMBS
			or uploadCategory == ValidationEnums.UploadCategory.DYNAMIC_HEAD

		for k, v2 in p.renderMeshesData do
			if not UGCValidationService:ValidateEditableMeshVertColors(v2.editable, v) then
				object:fail(ErrorSourceStrings.Keys.VertexColors_NotOpaque, {
					MeshName = k,
					TransparencyNote = v and "with no transparency" or ""
				})
			end
		end
	end
}
