local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFIntUGCValidationDynamicHeadMinimumQualityPercent = require(parent.flags.getFIntUGCValidationDynamicHeadMinimumQualityPercent)

local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)

local MeasureDynamicHead = {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	["shadowFlag"] = require(parent.flags.getFFlagUGCValidationShadowIsDynamicHead),
	knownAqsUserErrors = {
		INVALID_LANDMARKS = ErrorSourceStrings.Keys.DynamicHeadCageMisaligned,
		NO_FACS = ErrorSourceStrings.Keys.DynamicHeadNOFACS,
		MISSING_CAGE_INFO = ErrorSourceStrings.Keys.DynamicHeadMISSINGCAGE
	}
}

local v = {
	left_eye_close = ErrorSourceStrings.Keys.DynamicHeadLeftEyeNotClose,
	right_eye_close = ErrorSourceStrings.Keys.DynamicHeadRightEyeNotClose,
	mouth_open = ErrorSourceStrings.Keys.DynamicHeadMouthNotOpen,
	is_happy = ErrorSourceStrings.Keys.DynamicHeadHappyNotShown,
	is_sad = ErrorSourceStrings.Keys.DynamicHeadSadNotShown
}

function MeasureDynamicHead.run(object, p)
	local head = p.aqsSummaryData.Measure_Dynamic_Head.Head or p.aqsSummaryData.Measure_Dynamic_Head.Head_Geo

	if head == nil then
		error("Measure_Dynamic_Head: AQS summary missing required fields")
		return
	end

	for k, v2 in v do
		if not (head[k] ~= nil and tonumber(head[k]) <= getFIntUGCValidationDynamicHeadMinimumQualityPercent() / 100) then
			continue
		end

		object:fail(v2)
	end

	if getFFlagUGCValidateAQScoreWarnings() and head.score ~= nil and tonumber(head.score) ~= 100 then
		object:warn(ErrorSourceStrings.Keys.AQSWarn_DynamicHead, {
			left_eye_close = string.format("%.2f", tonumber(head.left_eye_close) or 0),
			right_eye_close = string.format("%.2f", tonumber(head.right_eye_close) or 0),
			mouth_open = string.format("%.2f", tonumber(head.mouth_open) or 0),
			is_happy = string.format("%.2f", tonumber(head.is_happy) or 0),
			is_sad = string.format("%.2f", tonumber(head.is_sad) or 0)
		})
	end
end

return MeasureDynamicHead
