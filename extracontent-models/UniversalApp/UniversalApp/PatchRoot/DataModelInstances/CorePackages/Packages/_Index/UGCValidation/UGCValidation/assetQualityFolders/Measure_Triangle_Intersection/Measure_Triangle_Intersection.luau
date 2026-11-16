local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(parent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)

local set = {
	[ValidationEnums.UploadCategory.FULL_BODY] = true,
	[ValidationEnums.UploadCategory.DYNAMIC_HEAD] = true
}

local defineFastInt = game:DefineFastInt("UGCValidationTriangleIntersectionMaxPercent", 20)

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
		local measure_Triangle_Intersection = p.aqsSummaryData.Measure_Triangle_Intersection
		local v = getFFlagUGCValidateAQMeshQualityBlockUpload() and set[p.uploadCategory]

		if measure_Triangle_Intersection == nil then
			if v then
				error("Measure_Triangle_Intersection: AQS summary data is nil")
			else
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Triangle_Intersection"
				})
			end
		else
			local v2 = defineFastInt / 100

			for k, v3 in measure_Triangle_Intersection do
				if k == "measurement_score" then
					continue
				end

				if v3 == nil or v3.intersecting_tri_face_percent == nil then
					object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
						measureName = "Measure_Triangle_Intersection"
					})

					return
				end

				local intersecting_tri_face_percent = tonumber(v3.intersecting_tri_face_percent) or 0

				if not (v2 < intersecting_tri_face_percent) then
					continue
				end

				local v4 = {
					partName = k,
					intersecting_tri_face_percent = string.format("%.2f", intersecting_tri_face_percent * 100),
					threshold = tostring(defineFastInt)
				}

				if v then
					object:fail(ErrorSourceStrings.Keys.AQSWarn_TriangleIntersection, v4)
				else
					object:warn(ErrorSourceStrings.Keys.AQSWarn_TriangleIntersection, v4)
				end
			end
		end
	end
}
