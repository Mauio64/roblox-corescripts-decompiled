local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local v4 = game:DefineFastInt("UGCValidationCageMeshDistanceHeadMaxCageMeshDistance", 60)
local v5 = game:DefineFastInt("UGCValidationCageMeshDistanceHeadMaxNegativeSDFThreshold", 30)

return {
	categories = { ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	fflag = require(ParentParent.flags.getFFlagUGCValidateCageMeshDistanceHead),
	expectedAqsData = {
		Measure_Cage_Distance_Head = {}
	},
	run = function(p1, p2) -- line: 17
		-- upvalues: ErrorSourceStrings (copy), v4 (copy), v5 (copy)
		local Head_OuterCage = p2.aqsSummaryData.Measure_Cage_Distance_Head.Head_OuterCage

		if Head_OuterCage == nil or (Head_OuterCage.max_distance == nil or Head_OuterCage.negative_sdf_percent == nil) then
			p1:fail(ErrorSourceStrings.Keys.AQSInputDataError)

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
				negtiveSDFPercent = tonumber(Head_OuterCage.negative_sdf_percent) * 100
			})
		end
	end
}
