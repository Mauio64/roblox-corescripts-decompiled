local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)

return {
	categories = {
		ValidationEnums.UploadCategory.LAYERED_CLOTHING,
		ValidationEnums.UploadCategory.FULL_BODY,
		ValidationEnums.UploadCategory.RIGID_ACCESSORY,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQMeshQuality),
	run = function(p1, p2) -- line: 16
		-- upvalues: ErrorSourceStrings (copy)
		local Measure_Degen_Triangles = p2.aqsSummaryData.Measure_Degen_Triangles

		if Measure_Degen_Triangles == nil then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Degen_Triangles"
			})

			return
		end

		for v7, v8 in Measure_Degen_Triangles do
			if v7 == "measurement_score" then
				continue
			end

			if v8 == nil or v8.score == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Degen_Triangles"
				})

				return
			end

			if tonumber(v8.score) ~= 100 then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_DegenTriangles, {
					partName = v7,
					degenerate_triangle_percent = string.format("%.2f", (tonumber(v8.degenerate_triangle_percent) or 0) * 100),
					score = tostring((math.floor(tonumber(v8.score) or 0)))
				})
			end
		end
	end
}
