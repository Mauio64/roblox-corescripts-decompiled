local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getAQEmotePartData = require(parent.util.getAQEmotePartData)

local getEngineFeatureEngineUGCValidateEmoteAnimationExport = require(parent.flags.getEngineFeatureEngineUGCValidateEmoteAnimationExport)
local getFFlagUGCValidateAQEmoteDuration = require(parent.flags.getFFlagUGCValidateAQEmoteDuration)
local GetFStringUGCValidateCurveAnimationMinLength = require(parent.flags.GetFStringUGCValidateCurveAnimationMinLength)
local GetFStringUGCValidationMaxAnimationLength = require(parent.flags.GetFStringUGCValidationMaxAnimationLength)
local MeasureAnimationDuration = {}
MeasureAnimationDuration.categories = { ValidationEnums.UploadCategory.EMOTE_ANIMATION }

function MeasureAnimationDuration.fflag()
	return getEngineFeatureEngineUGCValidateEmoteAnimationExport() and getFFlagUGCValidateAQEmoteDuration()
end

function MeasureAnimationDuration.run(object, p)
	local v = getAQEmotePartData(p.aqsSummaryData and p.aqsSummaryData.Measure_Animation_Duration)

	if not v or v.duration_seconds == nil then
		error("Can't find Measure_Animation_Duration.duration_seconds")
	end

	local duration_seconds = tonumber(v.duration_seconds) or 0
	local number = GetFStringUGCValidateCurveAnimationMinLength.asNumber()
	local number2 = GetFStringUGCValidationMaxAnimationLength.asNumber()

	if duration_seconds <= number then
		object:fail(ErrorSourceStrings.Keys.AQSFail_AnimationTooShort, {
			duration = tostring(duration_seconds),
			minLength = tostring(number)
		})
	elseif number2 < duration_seconds then
		object:fail(ErrorSourceStrings.Keys.AQSFail_AnimationTooLong, {
			duration = tostring(duration_seconds),
			maxLength = tostring(number2)
		})
	end
end

return MeasureAnimationDuration
