local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = { ValidationEnums.SharedDataMember.curveAnimations },
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		for _, folder in p.curveAnimations do
			for _, Script in folder:GetDescendants() do
				if Script:IsA("Script") or Script:IsA("ModuleScript") then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_ContainsScripts)
					return
				end
			end
		end
	end
}
