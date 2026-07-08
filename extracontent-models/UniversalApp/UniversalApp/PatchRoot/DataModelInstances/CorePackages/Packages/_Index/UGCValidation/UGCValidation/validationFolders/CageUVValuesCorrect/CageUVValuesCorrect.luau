local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local WrapTargetCageUVReferenceValues = require(ParentParent.WrapTargetCageUVReferenceValues)
local getFFlagUGCValidateMigrateCageUV = require(ParentParent.flags.getFFlagUGCValidateMigrateCageUV)

return {
	categories = {
		ValidationEnums.UploadCategory.TORSO_AND_LIMBS,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	requiredData = { ValidationEnums.SharedDataMember.outerCagesData },
	conditionalData = {},
	fflag = getFFlagUGCValidateMigrateCageUV,
	expectedFailures = {},
	run = function(p1, p2) -- line: 38
		-- upvalues: WrapTargetCageUVReferenceValues (copy), UGCValidationService (copy), ErrorSourceStrings (copy)
		for v9, v10 in p2.outerCagesData do
			local v11 = WrapTargetCageUVReferenceValues[v9]

			if v11 and not UGCValidationService:ValidateEditableMeshUVValuesInReference(v11, v10.editable) then
				p1:fail(ErrorSourceStrings.Keys.CageUV_InvalidUVValue, {
					partName = v9
				})
			end
		end
	end
}
