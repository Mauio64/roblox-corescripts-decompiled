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

function CurveAnimFrameDataSensible.run(object, p)
	local curveAnimComputedFrames = p.curveAnimComputedFrames

	for _, animFrame in curveAnimComputedFrames.animFrames do
		for _, cframe in animFrame do
			if not areNumbersGood(cframe:GetComponents()) then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidNumericalData)
				return
			end
		end
	end

	for _, positionMagnitudeFrame in curveAnimComputedFrames.positionMagnitudeFrames do
		for _, v in positionMagnitudeFrame do
			if not areNumbersGood(v) then
				object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidNumericalData)
				return
			end
		end
	end
end

return CurveAnimFrameDataSensible
