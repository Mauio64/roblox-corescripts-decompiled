local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(parent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.EYEBROW_EYELASH,
		ValidationEnums.UploadCategory.FULL_BODY,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQMeshQuality),
	run = function(object, p)
		local measure_UV_Bound = p.aqsSummaryData.Measure_UV_Bound

		if measure_UV_Bound == nil then
			if getFFlagUGCValidateAQMeshQualityBlockUpload() then
				error("Measure_UV_Bound: AQS summary data is nil")
			else
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_UV_Bound"
				})
			end
		else
			for k, v in measure_UV_Bound do
				if k == "measurement_score" then
					continue
				end

				if v == nil or v.score == nil then
					object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
						measureName = "Measure_UV_Bound"
					})

					return
				end

				if tonumber(v.score) == 100 then
					continue
				end

				local v2 = {
					partName = k,
					uv_outside_bound_vert_percent = string.format(
						"%.2f",
						(tonumber(v.uv_outside_bound_vert_percent) or 0) * 100
					)
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					object:fail(ErrorSourceStrings.Keys.AQSWarn_UVBound, v2)
				else
					object:warn(ErrorSourceStrings.Keys.AQSWarn_UVBound, v2)
				end
			end
		end
	end
}
