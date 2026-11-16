local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.outerCagesData },
	conditionalData = {},
	expectedFailures = {},
	run = function(object, p)
		for k, v in p.outerCagesData do
			if not UGCValidationService:ValidateEditableMeshCageUVTriangleArea(v.editable) then
				object:fail(ErrorSourceStrings.Keys.CageUV_ZeroAreaTriangle, { partName = k })
			end
		end
	end
}
