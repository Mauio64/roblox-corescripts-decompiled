local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local v4 = game:DefineFastInt("UGCValidationCageMeshDistanceHeadMaxCageMeshDistance", 60)
local v5 = game:DefineFastInt("UGCValidationCageMeshDistanceHeadMaxNegativeSDFThreshold", 30)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	fflag = require(ParentParent.flags.getFFlagUGCValidateCageMeshDistanceHead),
	run = function(p1, p2) -- line: 16
		-- upvalues: v4 (copy), ErrorSourceStrings (copy), v5 (copy), getFFlagUGCValidateAQScoreWarnings (copy)
		local Head_OuterCage = p2.aqsSummaryData.Measure_Cage_Distance_Head.Head_OuterCage

		if Head_OuterCage == nil or (Head_OuterCage.max_distance == nil or Head_OuterCage.negative_sdf_percent == nil) then
			error("Measure_Cage_Distance_Head: AQS summary missing required fields")

			return
		end

		if tonumber(Head_OuterCage.max_distance) > v4 / 100 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceHead_CageTooFar, {
				max_sdf = tonumber(Head_OuterCage.max_distance),
				max_sdf_threshold = v4 / 100
			})
		end

		if tonumber(Head_OuterCage.negative_sdf_percent) * 100 > v5 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceHead_CageInsideMesh, {
				negtiveSDFPercent = string.format("%.2f", tonumber(Head_OuterCage.negative_sdf_percent) * 100)
			})
		end

		if getFFlagUGCValidateAQScoreWarnings() and Head_OuterCage.score ~= nil and tonumber(Head_OuterCage.score) ~= 100 then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_CageMeshDistanceHead, {
				score = tostring((math.floor(tonumber(Head_OuterCage.score) or 0))),
				max_distance = Head_OuterCage.max_distance or "unknown",
				negative_sdf_percent = string.format("%.2f", (tonumber(Head_OuterCage.negative_sdf_percent) or 0) * 100)
			})
		end
	end
}
