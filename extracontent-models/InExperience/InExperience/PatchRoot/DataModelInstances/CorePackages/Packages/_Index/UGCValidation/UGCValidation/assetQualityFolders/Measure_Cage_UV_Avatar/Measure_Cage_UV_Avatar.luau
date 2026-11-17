local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local Constants = require(parent.Constants)
local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)
local getFFlagUGCValidateLCCageUVScoreCheck = require(parent.flags.getFFlagUGCValidateLCCageUVScoreCheck)

local defineFastInt = game:DefineFastInt("UGCValidateLCCagingIncorrectUVThresholdBodyPart", 7)
local defineFastInt2 = game:DefineFastInt("UGCValidateLCCageUVAvatarMinScore", 95)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	run = function(object, p)
		local measure_Cage_UV_Avatar = p.aqsSummaryData.Measure_Cage_UV_Avatar

		if measure_Cage_UV_Avatar == nil then
			error("Measure_Cage_UV_Avatar: AQS summary data is nil")
		end

		local fFlagUGCValidateLCCageUVScoreCheck = getFFlagUGCValidateLCCageUVScoreCheck()

		for _, cage_name in Constants.R15_CAGE_PARTS do
			if
				measure_Cage_UV_Avatar[cage_name] == nil
				or measure_Cage_UV_Avatar[cage_name].incorrect_uv_count == nil
			then
				error("Measure_Cage_UV_Avatar: AQS summary missing required fields for cage " .. cage_name)
			else
				local score = measure_Cage_UV_Avatar[cage_name].score
				local v

				if score ~= nil then
					v = tonumber(score)
				end

				local incorrect_uv_count = tonumber(measure_Cage_UV_Avatar[cage_name].incorrect_uv_count) or 0
				local unreferenced_vertex_count = measure_Cage_UV_Avatar[cage_name].unreferenced_vertex_count or "0"
				local non_template_uv_count = measure_Cage_UV_Avatar[cage_name].non_template_uv_count or "0"
				local unmatched_template_count = measure_Cage_UV_Avatar[cage_name].unmatched_template_count or "0"
				local duplicate_mapping_count = measure_Cage_UV_Avatar[cage_name].duplicate_mapping_count or "0"

				if fFlagUGCValidateLCCageUVScoreCheck then
					if v == nil then
						error("Measure_Cage_UV_Avatar: AQS summary missing score for cage " .. cage_name)
					elseif v < defineFastInt2 then
						object:fail(ErrorSourceStrings.Keys.AQSFail_CageUV, {
							cage_name = cage_name,
							incorrect_uv_count = tostring(incorrect_uv_count),
							unreferenced_vertex_count = unreferenced_vertex_count,
							non_template_uv_count = non_template_uv_count,
							unmatched_template_count = unmatched_template_count,
							duplicate_mapping_count = duplicate_mapping_count
						})
					elseif getFFlagUGCValidateAQScoreWarnings() and v ~= 100 then
						object:warn(ErrorSourceStrings.Keys.AQSWarn_CageUV, {
							cage_name = cage_name,
							incorrect_uv_count = tostring(incorrect_uv_count),
							unreferenced_vertex_count = unreferenced_vertex_count,
							non_template_uv_count = non_template_uv_count,
							unmatched_template_count = unmatched_template_count,
							duplicate_mapping_count = duplicate_mapping_count
						})
					end
				else
					if defineFastInt < incorrect_uv_count then
						object:fail(ErrorSourceStrings.Keys.MeasureCageUV, {
							cage_name = cage_name,
							incorrect_uv_count = incorrect_uv_count
						})
					end

					if getFFlagUGCValidateAQScoreWarnings() and v ~= nil and v ~= 100 then
						object:warn(ErrorSourceStrings.Keys.AQSWarn_CageUV, {
							cage_name = cage_name,
							incorrect_uv_count = tostring(incorrect_uv_count),
							unreferenced_vertex_count = unreferenced_vertex_count,
							non_template_uv_count = non_template_uv_count,
							unmatched_template_count = unmatched_template_count,
							duplicate_mapping_count = duplicate_mapping_count
						})
					end
				end
			end
		end
	end
}
