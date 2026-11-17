local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)

local defineFastInt = game:DefineFastInt("UGCMinCageRelevancyThreshold", 10)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	run = function(object, p)
		local handle_OuterCage = p.aqsSummaryData.Measure_Cage_Relevancy.Handle_OuterCage
		local outer_cage_face_relevant_percent = handle_OuterCage
			and tonumber(handle_OuterCage.outer_cage_face_relevant_percent)

		if outer_cage_face_relevant_percent == nil then
			error("Measure_Cage_Relevancy: AQS summary missing required fields")
			return
		end

		if outer_cage_face_relevant_percent * 100 < defineFastInt then
			object:fail(ErrorSourceStrings.Keys.MeasureCageRelevancy, {
				outer_cage_face_irrelevant_percent = string.format("%.2f", 100 - outer_cage_face_relevant_percent * 100)
			})
		end

		if
			getFFlagUGCValidateAQScoreWarnings()
			and handle_OuterCage.score ~= nil
			and tonumber(handle_OuterCage.score) ~= 100
		then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_CageRelevancy, {
				irrelevant_percent = string.format(
					"%.2f",
					100 - (tonumber(handle_OuterCage.outer_cage_face_relevant_percent) or 0) * 100
				)
			})
		end
	end
}
