local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	requiredData = { ValidationEnums.SharedDataMember.rootInstance },
	["fflag"] = require(parent.flags.getEngineFeatureUGCValidateCheckFacsDisableOverride),
	run = function(object, p)
		local faceControls = p.rootInstance:FindFirstChildOfClass("FaceControls")

		if faceControls and faceControls:HasOverrideFACSData() then
			object:fail(ErrorSourceStrings.Keys.FaceControlsOverrideFACSNotEmpty, nil, faceControls)
		end
	end
}
