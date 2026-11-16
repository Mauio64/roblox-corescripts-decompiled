local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local defineFastInt = game:DefineFastInt("UGCValidationCageMeshDistanceHeadMaxCageMeshDistance", 60)
local defineFastInt2 = game:DefineFastInt("UGCValidationCageMeshDistanceHeadMaxNegativeSDFThreshold", 30)

local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	["fflag"] = require(parent.flags.getFFlagUGCValidateCageMeshDistanceHead),
	run = function(object, p)
		local head_OuterCage = p.aqsSummaryData.Measure_Cage_Distance_Head.Head_OuterCage

		if
			head_OuterCage == nil
			or head_OuterCage.max_distance == nil
			or head_OuterCage.negative_sdf_percent == nil
		then
			error("Measure_Cage_Distance_Head: AQS summary missing required fields")
			return
		end

		local max_distance = tonumber(head_OuterCage.max_distance)

		if defineFastInt / 100 < max_distance then
			object:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceHead_CageTooFar, {
				max_sdf = tonumber(head_OuterCage.max_distance),
				max_sdf_threshold = defineFastInt / 100
			})
		end

		if defineFastInt2 < tonumber(head_OuterCage.negative_sdf_percent) * 100 then
			object:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceHead_CageInsideMesh, {
				negtiveSDFPercent = string.format("%.2f", tonumber(head_OuterCage.negative_sdf_percent) * 100)
			})
		end

		if
			getFFlagUGCValidateAQScoreWarnings()
			and head_OuterCage.score ~= nil
			and tonumber(head_OuterCage.score) ~= 100
		then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_CageMeshDistanceHead, {
				max_distance = head_OuterCage.max_distance or "unknown",
				negative_sdf_percent = string.format("%.2f", (tonumber(head_OuterCage.negative_sdf_percent) or 0) * 100)
			})
		end
	end
}
