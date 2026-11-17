local parent = script.Parent.Parent.Parent

local Constants = require(parent.Constants)
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidateMaxAnimationMovementPerPart = require(parent.flags.GetFStringUGCValidateMaxAnimationMovementPerPart)
local CurveAnimPositionBounded = {}

CurveAnimPositionBounded.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimPositionBounded.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}

CurveAnimPositionBounded.expectedFailures = {}
CurveAnimPositionBounded.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function validateCurveAnimClip(object, curveAnimComputedFrame)
	local fullName = curveAnimComputedFrame.animation and curveAnimComputedFrame.animation:GetFullName()
	local v = {}

	for _, positionMagnitudeFrame in curveAnimComputedFrame.positionMagnitudeFrames do
		for k, v2 in positionMagnitudeFrame do
			if k == Constants.NAMED_R15_BODY_PARTS.LowerTorso then
				continue
			end

			if not v[k] then
				v[k] = GetFStringUGCValidateMaxAnimationMovementPerPart.asNumber(k)
			end

			if v[k] < v2 then
				local v3 = { bodyPart = k, maxMovement = tostring(v[k]) }

				if fullName then
					v3.animationName = fullName
				end

				object:fail(ErrorSourceStrings.Keys.CurveAnim_PositionSeparation, v3, curveAnimComputedFrame.animation)
				return
			end
		end
	end
end

function CurveAnimPositionBounded.run(p, p2)
	for _, curveAnimComputedFrame in p2.curveAnimComputedFrames do
		validateCurveAnimClip(p, curveAnimComputedFrame)
	end
end

return CurveAnimPositionBounded
