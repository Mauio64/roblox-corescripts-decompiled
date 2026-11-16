local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidateMaxAnimationMovementPerPart = require(parent.flags.GetFStringUGCValidateMaxAnimationMovementPerPart)
return {
	categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION, ValidationEnums.UploadCategory.ANIMATION },
	requiredData = {
		ValidationEnums.SharedDataMember.curveAnimations,
		ValidationEnums.SharedDataMember.curveAnimComputedFrames
	},
	expectedFailures = {},
	prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable },
	run = function(object, p)
		local v = {}

		for _, positionMagnitudeFrame in p.curveAnimComputedFrames.positionMagnitudeFrames do
			for k, v2 in positionMagnitudeFrame do
				if k == Constants.NAMED_R15_BODY_PARTS.LowerTorso then
					continue
				end

				if not v[k] then
					v[k] = GetFStringUGCValidateMaxAnimationMovementPerPart.asNumber(k)
				end

				if v[k] < v2 then
					object:fail(ErrorSourceStrings.Keys.CurveAnim_PositionSeparation, {
						bodyPart = k,
						maxMovement = tostring(v[k])
					})

					return
				end
			end
		end
	end
}
