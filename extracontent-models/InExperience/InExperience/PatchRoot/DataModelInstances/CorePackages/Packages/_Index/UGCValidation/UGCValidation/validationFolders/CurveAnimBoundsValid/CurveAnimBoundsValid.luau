local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidateAnimationHeightTol = require(parent.flags.GetFStringUGCValidateAnimationHeightTol)
local GetFStringUGCValidationMaxAnimationBounds = require(parent.flags.GetFStringUGCValidationMaxAnimationBounds)
local getFIntUGCValidateMaxAnimationFPS = require(parent.flags.getFIntUGCValidateMaxAnimationFPS)
local CurveAnimBoundsValid = {}

CurveAnimBoundsValid.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimBoundsValid.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}

CurveAnimBoundsValid.expectedFailures = {}
CurveAnimBoundsValid.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function validateCurveAnimClip(object, curveAnimComputedFrame)
	local fullName = curveAnimComputedFrame.animation and curveAnimComputedFrame.animation:GetFullName()
	local animFrames = curveAnimComputedFrame.animFrames
	local animLength = curveAnimComputedFrame.animLength
	local v = 1 / getFIntUGCValidateMaxAnimationFPS()

	local number = GetFStringUGCValidateAnimationHeightTol.asNumber()
	local number2 = GetFStringUGCValidationMaxAnimationBounds.asNumber()

	for k, animFrame in animFrames do
		for k2, v2 in animFrame do
			if v2.Position.Y < number then
				local v3 = {
					time = string.format("%.2f", (math.min(animLength, (k - 1) * v))),
					bodyPart = k2,
					height = string.format("%.2f", v2.Position.Y),
					minHeight = GetFStringUGCValidateAnimationHeightTol.asString()
				}

				if fullName then
					v3.animationName = fullName
				end

				object:fail(ErrorSourceStrings.Keys.CurveAnim_PartTooLow, v3, curveAnimComputedFrame.animation)
				return
			elseif number2 < v2.Position.Magnitude then
				local v3 = {
					time = string.format("%.2f", (math.min(animLength, (k - 1) * v))),
					bodyPart = k2,
					distance = string.format("%.2f", v2.Position.Magnitude),
					maxDistance = GetFStringUGCValidationMaxAnimationBounds.asString()
				}

				if fullName then
					v3.animationName = fullName
				end

				object:fail(ErrorSourceStrings.Keys.CurveAnim_PartTooFar, v3, curveAnimComputedFrame.animation)
				return
			end
		end
	end
end

function CurveAnimBoundsValid.run(p, p2)
	for _, curveAnimComputedFrame in p2.curveAnimComputedFrames do
		validateCurveAnimClip(p, curveAnimComputedFrame)
	end
end

return CurveAnimBoundsValid
