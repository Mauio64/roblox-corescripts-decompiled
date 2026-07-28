local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(ParentParent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.FULL_BODY,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQMeshQuality),
	run = function(p1, p2) -- line: 17
		-- upvalues: getFFlagUGCValidateAQMeshQualityBlockUpload (copy), ErrorSourceStrings (copy)
		local Measure_Triangle_Intersection = p2.aqsSummaryData.Measure_Triangle_Intersection

		if Measure_Triangle_Intersection == nil then
			if getFFlagUGCValidateAQMeshQualityBlockUpload() then
				error("Measure_Triangle_Intersection: AQS summary data is nil")

				return
			end

			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Triangle_Intersection"
			})

			return
		end

		for v8, v9 in Measure_Triangle_Intersection do
			if v8 == "measurement_score" then
				continue
			end

			if v9 == nil or v9.score == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Triangle_Intersection"
				})

				return
			end

			if tonumber(v9.score) ~= 100 then
				local t1 = {
					partName = v8,
					intersecting_tri_face_percent = string.format("%.2f", (tonumber(v9.intersecting_tri_face_percent) or 0) * 100),
					score = tostring((math.floor(tonumber(v9.score) or 0)))
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					p1:fail(ErrorSourceStrings.Keys.AQSWarn_TriangleIntersection, t1)
				else
					p1:warn(ErrorSourceStrings.Keys.AQSWarn_TriangleIntersection, t1)
				end
			end
		end
	end
}
