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

function CurveAnimLengthBounded.run(object, p)
	local animLength = p.curveAnimComputedFrames.animLength

	local number = GetFStringUGCValidateCurveAnimationMinLength.asNumber()

	if animLength <= number or GetFStringUGCValidationMaxAnimationLength.asNumber() < animLength then
		object:fail(ErrorSourceStrings.Keys.CurveAnim_InvalidLength, {
			minLength = tostring(number),
			maxLength = GetFStringUGCValidationMaxAnimationLength.asString()
		})
	end
end

return CurveAnimLengthBounded
