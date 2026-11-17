local parent = script.Parent.Parent.Parent

require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local GetFStringUGCValidateCurveAnimationMinLength = require(parent.flags.GetFStringUGCValidateCurveAnimationMinLength)
local GetFStringUGCValidationMaxAnimationLength = require(parent.flags.GetFStringUGCValidationMaxAnimationLength)

local getEngineFeatureEngineUGCValidateEmoteAnimationExport = require(parent.flags.getEngineFeatureEngineUGCValidateEmoteAnimationExport)
local getFFlagUGCValidateAQEmoteDuration = require(parent.flags.getFFlagUGCValidateAQEmoteDuration)

local CurveAnimLengthBounded = {}

CurveAnimLengthBounded.categories = {}

if not (getEngineFeatureEngineUGCValidateEmoteAnimationExport() and getFFlagUGCValidateAQEmoteDuration()) then
	table.insert(CurveAnimLengthBounded.categories, ValidationEnums.UploadCategory.EMOTE_ANIMATION)
end

table.insert(CurveAnimLengthBounded.categories, ValidationEnums.UploadCategory.ANIMATION)
CurveAnimLengthBounded.requiredData = {
	ValidationEnums.SharedDataMember.curveAnimations,
	ValidationEnums.SharedDataMember.curveAnimComputedFrames
}

CurveAnimLengthBounded.expectedFailures = {}
CurveAnimLengthBounded.prereqTests = { ValidationEnums.ValidationModule.CurveAnimDataAvailable }

local function validateCurveAnimClip(object, curveAnimComputedFrame)
	local fullName = curveAnimComputedFrame.animation and curveAnimComputedFrame.animation:GetFullName()
	local animLength = curveAnimComputedFrame.animLength

	local number = GetFStringUGCValidateCurveAnimationMinLength.asNumber()

	if animLength <= number or GetFStringUGCValidationMaxAnimationLength.asNumber() < animLength then
		local v = {
			minLength = tostring(number),
			maxLength = GetFStringUGCValidationMaxAnimationLength.asString()
		}

		if fullName then
			v.animationName = fullName
		end

		object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidLength, v, curveAnimComputedFrame.animation)
	end
end

function CurveAnimLengthBounded.run(p, p2)
	for _, curveAnimComputedFrame in p2.curveAnimComputedFrames do
		validateCurveAnimClip(p, curveAnimComputedFrame)
	end
end

return CurveAnimLengthBounded
