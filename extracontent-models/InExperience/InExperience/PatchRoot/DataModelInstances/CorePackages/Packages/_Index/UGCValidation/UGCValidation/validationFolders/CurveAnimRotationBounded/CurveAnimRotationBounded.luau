local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateCurveAnimRotationSpeed = require(parent.flags.getFFlagUGCValidateCurveAnimRotationSpeed)
local getFIntUGCValidateMaxAnimationFPS = require(parent.flags.getFIntUGCValidateMaxAnimationFPS)

local getFIntUGCValidationMaxAnimationRotationSpeedPerSecond = require(parent.flags.getFIntUGCValidationMaxAnimationRotationSpeedPerSecond)
return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.curveAnimComputedFrames
	},
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		if not getFFlagUGCValidateCurveAnimRotationSpeed() then
			return
		end

		local animFrames = p.curveAnimComputedFrames.animFrames
		local v = 1 / getFIntUGCValidateMaxAnimationFPS()

		local fIntUGCValidationMaxAnimationRotationSpeedPerSecond = getFIntUGCValidationMaxAnimationRotationSpeedPerSecond()
		local v2 = fIntUGCValidationMaxAnimationRotationSpeedPerSecond / getFIntUGCValidateMaxAnimationFPS()

		local v3 = {}

		for k, animFrame in animFrames do
			for k2, v4 in animFrame do
				local v5 = v3[k2]

				if not v5 then
					continue
				end

				local v6 = math.deg((math.abs((v4:AngleBetween(v5)))))

				if v2 < v6 then
					local v7 = (k - 1) * v
					local v8 = v6 * getFIntUGCValidateMaxAnimationFPS()

					object:fail(ErrorSourceStrings.Keys.CurveAnim_RotationTooFast, {
						time = string.format("%.2f", v7),
						bodyPart = k2,
						speed = string.format("%.2f", v8),
						maxSpeed = tostring(fIntUGCValidationMaxAnimationRotationSpeedPerSecond)
					})

					return
				end
			end

			v3 = animFrame
		end
	end
}
