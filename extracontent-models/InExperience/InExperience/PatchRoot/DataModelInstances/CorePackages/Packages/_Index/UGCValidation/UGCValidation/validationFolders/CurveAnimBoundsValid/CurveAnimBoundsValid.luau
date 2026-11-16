local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidateAnimationHeightTol = require(parent.flags.GetFStringUGCValidateAnimationHeightTol)
local GetFStringUGCValidationMaxAnimationBounds = require(parent.flags.GetFStringUGCValidationMaxAnimationBounds)
local getFIntUGCValidateMaxAnimationFPS = require(parent.flags.getFIntUGCValidateMaxAnimationFPS)
return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.curveAnimComputedFrames
	},
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		local curveAnimComputedFrames = p.curveAnimComputedFrames
		local animFrames = curveAnimComputedFrames.animFrames
		local animLength = curveAnimComputedFrames.animLength
		local v = 1 / getFIntUGCValidateMaxAnimationFPS()

		local number = GetFStringUGCValidateAnimationHeightTol.asNumber()
		local number2 = GetFStringUGCValidationMaxAnimationBounds.asNumber()

		for k, animFrame in animFrames do
			for k2, v2 in animFrame do
				if v2.Position.Y < number then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_PartTooLow, {
						time = string.format("%.2f", (math.min(animLength, (k - 1) * v))),
						bodyPart = k2,
						height = string.format("%.2f", v2.Position.Y),
						minHeight = GetFStringUGCValidateAnimationHeightTol.asString()
					})

					return
				end

				if number2 < v2.Position.Magnitude then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_PartTooFar, {
						time = string.format("%.2f", (math.min(animLength, (k - 1) * v))),
						bodyPart = k2,
						distance = string.format("%.2f", v2.Position.Magnitude),
						maxDistance = GetFStringUGCValidationMaxAnimationBounds.asString()
					})

					return
				end
			end
		end
	end
}
