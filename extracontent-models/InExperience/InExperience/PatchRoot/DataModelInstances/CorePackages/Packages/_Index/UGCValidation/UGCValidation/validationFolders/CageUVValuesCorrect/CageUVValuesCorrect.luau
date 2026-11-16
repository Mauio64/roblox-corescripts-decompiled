local UGCValidationService = game:GetService("UGCValidationService")

local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local WrapTargetCageUVReferenceValues = require(parent.WrapTargetCageUVReferenceValues)

return {
	categories = { ValidationEnums.UploadCategory.TORSO_AND_LIMBS, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.outerCagesData },
	conditionalData = {},
	expectedFailures = {},
	run = function(object, p)
		for k, v in p.outerCagesData do
			local wrapTargetCageUVReferenceValue = WrapTargetCageUVReferenceValues[k]

			if
				not wrapTargetCageUVReferenceValue
				or UGCValidationService:ValidateEditableMeshUVValuesInReference(
					wrapTargetCageUVReferenceValue,
					v.editable
				)
			then
				continue
			end

			object:fail(ErrorSourceStrings.Keys.CageUV_InvalidUVValue, { partName = k })
		end
	end
}
