local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFIntUGCValidationDynamicHeadMinimumQualityPercent = require(ParentParent.flags.getFIntUGCValidationDynamicHeadMinimumQualityPercent)
local getFFlagUGCValidationAddGeometryToExports = require(ParentParent.flags.getFFlagUGCValidationAddGeometryToExports)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)
local t1 = {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	fflag = require(ParentParent.flags.getFFlagUGCValidateIsDynamicHead),
	shadowFlag = require(ParentParent.flags.getFFlagUGCValidationShadowIsDynamicHead),
	knownAqsUserErrors = {
		INVALID_LANDMARKS = ErrorSourceStrings.Keys.DynamicHeadCageMisaligned,
		NO_FACS = ErrorSourceStrings.Keys.DynamicHeadNOFACS,
		MISSING_CAGE_INFO = ErrorSourceStrings.Keys.DynamicHeadMISSINGCAGE
	}
}
local t2 = {
	left_eye_close = ErrorSourceStrings.Keys.DynamicHeadLeftEyeNotClose,
	right_eye_close = ErrorSourceStrings.Keys.DynamicHeadRightEyeNotClose,
	mouth_open = ErrorSourceStrings.Keys.DynamicHeadMouthNotOpen,
	is_happy = ErrorSourceStrings.Keys.DynamicHeadHappyNotShown,
	is_sad = ErrorSourceStrings.Keys.DynamicHeadSadNotShown
}

function t1.run(p1, p2) -- line: 31
	-- upvalues: getFFlagUGCValidationAddGeometryToExports (copy), t2 (copy), getFIntUGCValidationDynamicHeadMinimumQualityPercent (copy), getFFlagUGCValidateAQScoreWarnings (copy), ErrorSourceStrings (copy)
	local v11 = if not getFFlagUGCValidationAddGeometryToExports() then p2.aqsSummaryData.Measure_Dynamic_Head.Head else p2.aqsSummaryData.Measure_Dynamic_Head.Head or p2.aqsSummaryData.Measure_Dynamic_Head.Head_Geo

	if v11 == nil then
		error("Measure_Dynamic_Head: AQS summary missing required fields")

		return
	end

	for v12, v13 in t2 do
		if v11[v12] ~= nil and tonumber(v11[v12]) <= getFIntUGCValidationDynamicHeadMinimumQualityPercent() / 100 then
			p1:fail(v13)
		end
	end

	if getFFlagUGCValidateAQScoreWarnings() and v11.score ~= nil and tonumber(v11.score) ~= 100 then
		p1:warn(ErrorSourceStrings.Keys.AQSWarn_DynamicHead, {
			score = tostring((math.floor(tonumber(v11.score) or 0)))
		})
	end
end

return t1
