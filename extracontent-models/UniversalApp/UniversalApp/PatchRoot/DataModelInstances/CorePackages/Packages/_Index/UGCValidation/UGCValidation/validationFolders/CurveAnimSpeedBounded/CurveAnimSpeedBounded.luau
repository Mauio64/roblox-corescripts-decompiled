local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidationMaxAnimationDeltas = require(parent.flags.GetFStringUGCValidationMaxAnimationDeltas)
local getFIntUGCValidateMaxAnimationFPS = require(parent.flags.getFIntUGCValidateMaxAnimationFPS)
local CurveAnimSpeedBounded = {}

CurveAnimSpeedBounded.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimSpeedBounded.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}

CurveAnimSpeedBounded.expectedFailures = {}
CurveAnimSpeedBounded.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function validateCurveAnimClip(object, curveAnimComputedFrame)
	local fullName = curveAnimComputedFrame.animation and curveAnimComputedFrame.animation:GetFullName()
	local animFrames = curveAnimComputedFrame.animFrames
	local v = 1 / getFIntUGCValidateMaxAnimationFPS()

	local v2 = v / (1 / 30)
	local v3 = GetFStringUGCValidationMaxAnimationDeltas.asNumber() * v2

	local v4 = GetFStringUGCValidationMaxAnimationDeltas.asNumber() * 30

	local v5 = {}

	for k, animFrame in animFrames do
		for k2, v6 in animFrame do
			local v7 = v5[k2]

			if not v7 then
				continue
			end

			local magnitude = (v6.Position - v7.Position).Magnitude

			if v3 < magnitude then
				local v8 = (k - 1) * v
				local v9 = magnitude / v2 * 30

				local v10 = {
					time = string.format("%.2f", v8),
					bodyPart = k2,
					speed = string.format("%.2f", v9),
					maxSpeed = string.format("%.2f", v4)
				}

				if fullName then
					v10.animationName = fullName
				end

				object:fail(ErrorSourceStrings.Keys.CurveAnim_SpeedTooFast, v10, curveAnimComputedFrame.animation)
				return
			end
		end

		v5 = animFrame
	end
end

function CurveAnimSpeedBounded.run(p, p2)
	for _, curveAnimComputedFrame in p2.curveAnimComputedFrames do
		validateCurveAnimClip(p, curveAnimComputedFrame)
	end
end

return CurveAnimSpeedBounded
