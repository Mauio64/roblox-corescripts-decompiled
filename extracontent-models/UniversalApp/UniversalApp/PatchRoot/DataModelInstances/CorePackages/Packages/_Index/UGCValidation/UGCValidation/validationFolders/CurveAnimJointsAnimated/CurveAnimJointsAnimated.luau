local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.curveAnimComputedFrames
	},
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		for _, track in p.curveAnimComputedFrames.tracks do
			if track.pos or track.rot then
				return
			end
		end

		object:fail(ErrorSourceStrings.Keys.CurveAnim_NoJointManipulation)
	end
}
