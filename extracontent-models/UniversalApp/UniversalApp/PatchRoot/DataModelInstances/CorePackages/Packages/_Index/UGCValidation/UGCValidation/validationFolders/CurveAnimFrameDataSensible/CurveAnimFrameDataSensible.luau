local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local CurveAnimFrameDataSensible = {}

CurveAnimFrameDataSensible.categories = {
	ValidationEnums.UploadCategory.EMOTE_ANIMATION,
	ValidationEnums.UploadCategory.ANIMATION
}
CurveAnimFrameDataSensible.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}

CurveAnimFrameDataSensible.expectedFailures = {}
CurveAnimFrameDataSensible.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function areNumbersGood(...): boolean
	local function isNaN(p: number): boolean -- 1 equivalent call inferred from this helper
		return p ~= p
	end

	local function isInfinite(p: number): boolean -- 1 equivalent call inferred from this helper
		return p == 1e999 or p == -1e999
	end

	for _, v in { ... } do
		if isNaN(v) or isInfinite(v) then -- inferred equivalent call
			return false
		end
	end

	return true
end

local function validateCurveAnimClip(object, curveAnimComputedFrame)
	local fullName = curveAnimComputedFrame.animation and curveAnimComputedFrame.animation:GetFullName()

	for _, animFrame in curveAnimComputedFrame.animFrames do
		for _, cframe in animFrame do
			if not areNumbersGood(cframe:GetComponents()) then
				object:fail(
					ErrorSourceStrings.Keys.CurveAnim_InvalidNumericalData,
					{ animationName = fullName },
					curveAnimComputedFrame.animation
				)

				return
			end
		end
	end

	for _, positionMagnitudeFrame in curveAnimComputedFrame.positionMagnitudeFrames do
		for _, v in positionMagnitudeFrame do
			if not areNumbersGood(v) then
				object:fail(
					ErrorSourceStrings.Keys.CurveAnim_InvalidNumericalData,
					{ animationName = fullName },
					curveAnimComputedFrame.animation
				)

				return
			end
		end
	end
end

function CurveAnimFrameDataSensible.run(p, p2)
	for _, curveAnimComputedFrame in p2.curveAnimComputedFrames do
		validateCurveAnimClip(p, curveAnimComputedFrame)
	end
end

return CurveAnimFrameDataSensible
