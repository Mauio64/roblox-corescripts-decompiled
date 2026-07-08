local UGCValidationService = game:GetService("UGCValidationService")
local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
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
	run = function(p1, p2) -- line: 36
		-- upvalues: UGCValidationService (copy), ErrorSourceStrings (copy)
		for v8, v9 in p2.outerCagesData do
			if not UGCValidationService:ValidateEditableMeshCageUVTriangleArea(v9.editable) then
				p1:fail(ErrorSourceStrings.Keys.CageUV_ZeroAreaTriangle, {
					partName = v8
				})
			end
		end
	end
}
