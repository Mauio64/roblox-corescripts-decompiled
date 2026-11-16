local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)
local getFFlagUGCValidateLCCageUVScoreCheck = require(parent.flags.getFFlagUGCValidateLCCageUVScoreCheck)

local defineFastInt = game:DefineFastInt("UGCValidateLCCagingIncorrectUVThreshold", 100)
local defineFastInt2 = game:DefineFastInt("UGCValidateLCCageUVMinScore", 90)

local MeasureCageUV = {}

MeasureCageUV.categories = {
	ValidationEnums.UploadCategory.LAYERED_CLOTHING,
	ValidationEnums.UploadCategory.EYEBROW_EYELASH
}

MeasureCageUV.fflag = require(parent.flags.getFFlagUGCValidateAQCageQualityLC)

local v = { "Handle_InnerCage", "Handle_OuterCage" }

function MeasureCageUV.run(object, p)
	local measure_Cage_UV = p.aqsSummaryData.Measure_Cage_UV

	if measure_Cage_UV == nil then
		error("Measure_Cage_UV: AQS summary data is nil")
	end

	local v2 = p.uploadCategory == ValidationEnums.UploadCategory.EYEBROW_EYELASH
	local v3 = getFFlagUGCValidateLCCageUVScoreCheck() and not v2

	for _, cage_name in v do
		if measure_Cage_UV[cage_name] == nil or measure_Cage_UV[cage_name].incorrect_uv_count == nil then
			error("Measure_Cage_UV: AQS summary missing required fields for cage " .. cage_name)
		else
			local score = measure_Cage_UV[cage_name].score
			local v4

			if score ~= nil then
				v4 = tonumber(score)
			end

			local incorrect_uv_count = tonumber(measure_Cage_UV[cage_name].incorrect_uv_count) or 0
			local unreferenced_vertex_count = measure_Cage_UV[cage_name].unreferenced_vertex_count or "0"
			local non_template_uv_count = measure_Cage_UV[cage_name].non_template_uv_count or "0"
			local unmatched_template_count = measure_Cage_UV[cage_name].unmatched_template_count or "0"
			local duplicate_mapping_count = measure_Cage_UV[cage_name].duplicate_mapping_count or "0"

			if v3 then
				if v4 == nil then
					error("Measure_Cage_UV: AQS summary missing score for cage " .. cage_name)
				elseif v4 < defineFastInt2 then
					object:fail(ErrorSourceStrings.Keys.AQSFail_CageUV, {
						cage_name = cage_name,
						incorrect_uv_count = tostring(incorrect_uv_count),
						unreferenced_vertex_count = unreferenced_vertex_count,
						non_template_uv_count = non_template_uv_count,
						unmatched_template_count = unmatched_template_count,
						duplicate_mapping_count = duplicate_mapping_count
					})
				elseif getFFlagUGCValidateAQScoreWarnings() and v4 ~= 100 then
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

				if getFFlagUGCValidateAQScoreWarnings() and not v2 and v4 ~= nil and v4 ~= 100 then
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

return MeasureCageUV
