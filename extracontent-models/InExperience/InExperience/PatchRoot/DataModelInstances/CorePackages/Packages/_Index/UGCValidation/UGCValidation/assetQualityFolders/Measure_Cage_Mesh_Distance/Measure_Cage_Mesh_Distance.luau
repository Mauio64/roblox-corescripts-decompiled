local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local v4 = game:DefineFastInt("UGCValidationCageMeshDistanceMaxCageMeshDistanceLC", 60)
local v5 = game:DefineFastInt("UGCValidationCageMeshDistanceMaxNegativeSDFThresholdLC", 30)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQCageQualityLC),
	run = function(p1, p2) -- line: 16
		-- upvalues: v4 (copy), ErrorSourceStrings (copy), v5 (copy), getFFlagUGCValidateAQScoreWarnings (copy)
		local Handle_OuterCage = p2.aqsSummaryData.Measure_Cage_Mesh_Distance.Handle_OuterCage

		if Handle_OuterCage == nil or (Handle_OuterCage.max_distance == nil or Handle_OuterCage.negative_sdf_percent == nil) then
			error("Measure_Cage_Mesh_Distance: AQS summary missing required fields")

			return
		end

		if tonumber(Handle_OuterCage.max_distance) > v4 / 100 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistance_CageTooFar, {
				max_sdf = tonumber(Handle_OuterCage.max_distance),
				max_sdf_threshold = v4 / 100
			})
		end

		if tonumber(Handle_OuterCage.negative_sdf_percent) * 100 > v5 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistance_CageInsideMesh, {
				negtiveSDFPercent = string.format("%.2f", tonumber(Handle_OuterCage.negative_sdf_percent) * 100)
			})
		end

		if getFFlagUGCValidateAQScoreWarnings() and Handle_OuterCage.score ~= nil and tonumber(Handle_OuterCage.score) ~= 100 then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_CageMeshDistance, {
				score = tostring((math.floor(tonumber(Handle_OuterCage.score) or 0))),
				max_distance = Handle_OuterCage.max_distance or "unknown",
				negative_sdf_percent = string.format("%.2f", (tonumber(Handle_OuterCage.negative_sdf_percent) or 0) * 100)
			})
		end
	end
}
