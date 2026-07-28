local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)
local v5 = game:DefineFastInt("UGCMinCageRelevancyThreshold", 40)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQCageQualityLC),
	run = function(p1, p2) -- line: 15
		-- upvalues: v5 (copy), ErrorSourceStrings (copy), getFFlagUGCValidateAQScoreWarnings (copy)
		local Handle_OuterCage = p2.aqsSummaryData.Measure_Cage_Relevancy.Handle_OuterCage
		local v9 = Handle_OuterCage and tonumber(Handle_OuterCage.outer_cage_face_relevant_percent)

		if v9 == nil then
			error("Measure_Cage_Relevancy: AQS summary missing required fields")

			return
		end

		if v9 * 100 < v5 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageRelevancy, {
				outer_cage_face_irrelevant_percent = string.format("%.2f", 100 - v9 * 100)
			})
		end

		if getFFlagUGCValidateAQScoreWarnings() and Handle_OuterCage.score ~= nil and tonumber(Handle_OuterCage.score) ~= 100 then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_CageRelevancy, {
				score = tostring((math.floor(tonumber(Handle_OuterCage.score) or 0))),
				irrelevant_percent = string.format("%.2f", 100 - (tonumber(Handle_OuterCage.outer_cage_face_relevant_percent) or 0) * 100)
			})
		end
	end
}
