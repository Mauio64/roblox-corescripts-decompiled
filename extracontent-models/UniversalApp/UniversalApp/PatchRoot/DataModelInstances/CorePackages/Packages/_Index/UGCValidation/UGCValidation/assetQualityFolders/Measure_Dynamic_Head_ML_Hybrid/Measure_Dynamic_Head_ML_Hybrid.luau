local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local readAQSummaryNumber = require(parent.util.readAQSummaryNumber)

local getFFlagUGCValidateAQDynamicHeadMLHybrid = require(parent.flags.getFFlagUGCValidateAQDynamicHeadMLHybrid)

local getFFlagUGCValidateAQDynamicHeadMLHybridShadow = require(parent.flags.getFFlagUGCValidateAQDynamicHeadMLHybridShadow)

local getFFlagUGCValidateAQDynamicHeadMLHybridNewFacsMessages = require(parent.flags.getFFlagUGCValidateAQDynamicHeadMLHybridNewFacsMessages)

local getFIntUGCValidationDynamicHeadMLEyesMinScorePerMillion = require(parent.flags.getFIntUGCValidationDynamicHeadMLEyesMinScorePerMillion)

local getFIntUGCValidationDynamicHeadMLMouthMinScorePerMillion = require(parent.flags.getFIntUGCValidationDynamicHeadMLMouthMinScorePerMillion)

local getFIntUGCValidationDynamicHeadMLAnimationMinScorePerMillion = require(parent.flags.getFIntUGCValidationDynamicHeadMLAnimationMinScorePerMillion)

local getFIntUGCValidationDynamicHeadMinimumQualityPercent = require(parent.flags.getFIntUGCValidationDynamicHeadMinimumQualityPercent)

local v = {
	step2a_left_eye_landmark_valid = ErrorSourceStrings.Keys.DynamicHeadCageMisalignedLeftEye,
	step2a_right_eye_landmark_valid = ErrorSourceStrings.Keys.DynamicHeadCageMisalignedRightEye,
	step2a_mouth_landmark_valid = ErrorSourceStrings.Keys.DynamicHeadCageMisalignedMouth
}

local v2 = {
	step2b_deformation_left_eye_close = ErrorSourceStrings.Keys.DynamicHeadLeftEyeNotClose,
	step2b_deformation_right_eye_close = ErrorSourceStrings.Keys.DynamicHeadRightEyeNotClose,
	step2b_deformation_mouth_open = ErrorSourceStrings.Keys.DynamicHeadMouthNotOpen,
	step2b_deformation_happy = ErrorSourceStrings.Keys.DynamicHeadHappyNotShown,
	step2b_deformation_sad = ErrorSourceStrings.Keys.DynamicHeadSadNotShown
}

local v3 = {
	step2b_deformation_left_eye_close = ErrorSourceStrings.Keys.FacsDeformation_LeftEyeNotClose,
	step2b_deformation_right_eye_close = ErrorSourceStrings.Keys.FacsDeformation_RightEyeNotClose,
	step2b_deformation_mouth_open = ErrorSourceStrings.Keys.FacsDeformation_MouthNotOpen,
	step2b_deformation_happy = ErrorSourceStrings.Keys.FacsDeformation_HappyNotShown,
	step2b_deformation_sad = ErrorSourceStrings.Keys.FacsDeformation_SadNotShown
}

local MeasureDynamicHeadMLHybrid = {}

MeasureDynamicHeadMLHybrid.categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD }
MeasureDynamicHeadMLHybrid.fflag = getFFlagUGCValidateAQDynamicHeadMLHybrid
MeasureDynamicHeadMLHybrid.shadowFlag = getFFlagUGCValidateAQDynamicHeadMLHybridShadow
MeasureDynamicHeadMLHybrid.knownAqsUserErrors = {
	MISSING_CAGE_INFO = ErrorSourceStrings.Keys.DynamicHeadMISSINGCAGE,
	NO_FACS = ErrorSourceStrings.Keys.DynamicHeadNOFACS
}

local function requireStageCompleted(p, p2: string)
	local v4 = p[`{p2}_status`]

	if v4 ~= "completed" then
		error(`Measure_Dynamic_Head_ML_Hybrid: {p2} is {tostring(v4)}, expected completed. ` .. "A threshold here may be looser than the asset-quality cutoff.")
	end
end

local function meetsPerMillionCutoff(p: number, p2: number): boolean
	return p2 / 1000000 <= p
end

local function checkFacialFeatures(object, p)
	local step1_status = p.step1_status

	if step1_status ~= "completed" then
		error(`Measure_Dynamic_Head_ML_Hybrid: step1 is {tostring(step1_status)}, expected completed. ` .. "A threshold here may be looser than the asset-quality cutoff.")
	end

	local v4

	if readAQSummaryNumber(p, "step1_has_eyes_score", "Measure_Dynamic_Head_ML_Hybrid", 0, 1) >= getFIntUGCValidationDynamicHeadMLEyesMinScorePerMillion() / 1000000 then
		v4 = true
	else
		object:fail(ErrorSourceStrings.Keys.FacialFeaturePresence_EyesMissing)
		v4 = false
	end

	if not (readAQSummaryNumber(p, "step1_has_mouth_score", "Measure_Dynamic_Head_ML_Hybrid", 0, 1) >= getFIntUGCValidationDynamicHeadMLMouthMinScorePerMillion() / 1000000) then
		object:fail(ErrorSourceStrings.Keys.FacialFeaturePresence_MouthMissing)
		return false
	end

	return v4
end

local function checkCageLandmarks(object, p)
	local step2a_status = p.step2a_status

	if step2a_status ~= "completed" then
		error(`Measure_Dynamic_Head_ML_Hybrid: step2a is {tostring(step2a_status)}, expected completed. ` .. "A threshold here may be looser than the asset-quality cutoff.")
	end

	local v4 = true

	for k, v5 in v do
		local v6 = p[k]

		if v6 == "0" then
			object:fail(v5)
			v4 = false
		elseif v6 ~= "1" then
			error(`Measure_Dynamic_Head_ML_Hybrid: {k} is not "1" or "0": {tostring(v6)}`)
		end
	end

	return v4
end

local function checkFacsDeformation(object, p)
	local step2b_status = p.step2b_status

	if step2b_status ~= "completed" then
		error(`Measure_Dynamic_Head_ML_Hybrid: step2b is {tostring(step2b_status)}, expected completed. ` .. "A threshold here may be looser than the asset-quality cutoff.")
	end

	local v4 = true

	local v5 = getFIntUGCValidationDynamicHeadMinimumQualityPercent() / 100
	local v6

	if getFFlagUGCValidateAQDynamicHeadMLHybridNewFacsMessages() then
		v6 = v3
	else
		v6 = v2
	end

	for k, v7 in v6 do
		if not (readAQSummaryNumber(p, k, "Measure_Dynamic_Head_ML_Hybrid") <= v5) then
			continue
		end

		object:fail(v7)
		v4 = false
	end

	return v4
end

local function checkAnimationQuality(object, p): boolean
	local step3_status = p.step3_status

	if step3_status ~= "completed" then
		error(`Measure_Dynamic_Head_ML_Hybrid: step3 is {tostring(step3_status)}, expected completed. ` .. "A threshold here may be looser than the asset-quality cutoff.")
	end

	if readAQSummaryNumber(p, "step3_animation_pass_score", "Measure_Dynamic_Head_ML_Hybrid", 0, 1) >= getFIntUGCValidationDynamicHeadMLAnimationMinScorePerMillion() / 1000000 then
		return true
	end

	object:fail(ErrorSourceStrings.Keys.RenderedAnimation_RequiredExpressionsMissing)
	return false
end

local v4 = { checkFacialFeatures, checkCageLandmarks, checkFacsDeformation, checkAnimationQuality }

function MeasureDynamicHeadMLHybrid.run(p, p2)
	local measure_Dynamic_Head_ML_Hybrid = p2.aqsSummaryData.Measure_Dynamic_Head_ML_Hybrid

	if measure_Dynamic_Head_ML_Hybrid == nil then
		error("Measure_Dynamic_Head_ML_Hybrid: missing AQS summary data")
	end

	local count = 0

	for k, v5 in measure_Dynamic_Head_ML_Hybrid do
		if k == "measurement_score" then
			continue
		end

		count += 1

		for _, v6 in v4 do
			if not v6(p, v5) then
				break
			end
		end
	end

	if count == 0 then
		error("Measure_Dynamic_Head_ML_Hybrid: AQS summary has no head mesh")
	end
end

return MeasureDynamicHeadMLHybrid
