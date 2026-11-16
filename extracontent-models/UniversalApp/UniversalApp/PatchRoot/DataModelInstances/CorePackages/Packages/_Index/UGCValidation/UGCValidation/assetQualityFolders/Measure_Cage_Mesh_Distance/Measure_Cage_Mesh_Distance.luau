local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local defineFastInt = game:DefineFastInt("UGCValidationCageMeshDistanceMaxCageMeshDistanceLC", 60)
local defineFastInt2 = game:DefineFastInt("UGCValidationCageMeshDistanceMaxNegativeSDFThresholdLC", 30)

local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQCageQualityLC),
	run = function(object, p)
		local handle_OuterCage = p.aqsSummaryData.Measure_Cage_Mesh_Distance.Handle_OuterCage

		if
			handle_OuterCage == nil
			or handle_OuterCage.max_distance == nil
			or handle_OuterCage.negative_sdf_percent == nil
		then
			error("Measure_Cage_Mesh_Distance: AQS summary missing required fields")
			return
		end

		local max_distance = tonumber(handle_OuterCage.max_distance)

		if defineFastInt / 100 < max_distance then
			object:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistance_CageTooFar, {
				max_sdf = tonumber(handle_OuterCage.max_distance),
				max_sdf_threshold = defineFastInt / 100
			})
		end

		if defineFastInt2 < tonumber(handle_OuterCage.negative_sdf_percent) * 100 then
			object:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistance_CageInsideMesh, {
				negtiveSDFPercent = string.format("%.2f", tonumber(handle_OuterCage.negative_sdf_percent) * 100)
			})
		end

		if
			getFFlagUGCValidateAQScoreWarnings()
			and handle_OuterCage.score ~= nil
			and tonumber(handle_OuterCage.score) ~= 100
		then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_CageMeshDistance, {
				max_distance = handle_OuterCage.max_distance or "unknown",
				negative_sdf_percent = string.format(
					"%.2f",
					(tonumber(handle_OuterCage.negative_sdf_percent) or 0) * 100
				)
			})
		end
	end
}
