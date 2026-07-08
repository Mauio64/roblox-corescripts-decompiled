local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getEngineFeatureEngineUGCValidationExpandReturnSchema = require(ParentParent.flags.getEngineFeatureEngineUGCValidationExpandReturnSchema)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	fflag = require(ParentParent.flags.getEngineFeatureUGCValidateCheckFacsDisableOverride),
	run = function(p1, p2) -- line: 14
		-- upvalues: ErrorSourceStrings (copy), getEngineFeatureEngineUGCValidationExpandReturnSchema (copy)
		local FaceControls = p2.rootInstance:FindFirstChildOfClass("FaceControls")

		if FaceControls and FaceControls:HasOverrideFACSData() then
			p1:fail(ErrorSourceStrings.Keys.FaceControlsOverrideFACSNotEmpty, nil, if not getEngineFeatureEngineUGCValidationExpandReturnSchema() then nil else FaceControls)
		end
	end
}
