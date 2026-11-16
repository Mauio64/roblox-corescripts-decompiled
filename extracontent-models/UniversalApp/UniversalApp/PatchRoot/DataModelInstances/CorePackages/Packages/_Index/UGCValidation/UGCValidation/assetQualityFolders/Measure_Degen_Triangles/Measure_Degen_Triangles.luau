local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(parent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)

local set = {
	[ValidationEnums.UploadCategory.FULL_BODY] = true,
	[ValidationEnums.UploadCategory.DYNAMIC_HEAD] = true
}

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
		local measure_Degen_Triangles = p.aqsSummaryData.Measure_Degen_Triangles
		local v = getFFlagUGCValidateAQMeshQualityBlockUpload() and set[p.uploadCategory]

		if measure_Degen_Triangles == nil then
			if v then
				error("Measure_Degen_Triangles: AQS summary data is nil")
			else
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Degen_Triangles"
				})
			end
		else
			for k, measure_Degen_Triangle in measure_Degen_Triangles do
				if k == "measurement_score" then
					continue
				end

				if measure_Degen_Triangle == nil or measure_Degen_Triangle.score == nil then
					object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
						measureName = "Measure_Degen_Triangles"
					})

					return
				end

				if tonumber(measure_Degen_Triangle.score) == 100 then
					continue
				end

				local v2 = {
					partName = k,
					degenerate_triangle_percent = string.format(
						"%.2f",
						(tonumber(measure_Degen_Triangle.degenerate_triangle_percent) or 0) * 100
					)
				}

				if v then
					object:fail(ErrorSourceStrings.Keys.AQSWarn_DegenTriangles, v2)
				else
					object:warn(ErrorSourceStrings.Keys.AQSWarn_DegenTriangles, v2)
				end
			end
		end
	end
}
