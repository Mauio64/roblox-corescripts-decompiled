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
		local Measure_Vertex_Similarity = p2.aqsSummaryData.Measure_Vertex_Similarity

		if Measure_Vertex_Similarity == nil then
			if getFFlagUGCValidateAQMeshQualityBlockUpload() then
				error("Measure_Vertex_Similarity: AQS summary data is nil")

				return
			end

			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Vertex_Similarity"
			})

			return
		end

		for v8, v9 in Measure_Vertex_Similarity do
			if v8 == "measurement_score" then
				continue
			end

			if v9 == nil or v9.score == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Vertex_Similarity"
				})

				return
			end

			if tonumber(v9.score) ~= 100 then
				local t1 = {
					partName = v8,
					similar_vertex_percent = string.format("%.2f", (tonumber(v9.similar_vertex_percent) or 0) * 100),
					score = tostring((math.floor(tonumber(v9.score) or 0)))
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					p1:fail(ErrorSourceStrings.Keys.AQSWarn_VertexSimilarity, t1)
				else
					p1:warn(ErrorSourceStrings.Keys.AQSWarn_VertexSimilarity, t1)
				end
			end
		end
	end
}
