local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(parent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)

local set = {
	[ValidationEnums.UploadCategory.FULL_BODY] = true,
	[ValidationEnums.UploadCategory.DYNAMIC_HEAD] = true
}

local defineFastInt = game:DefineFastInt("UGCValidationVertexSimilarityMaxPercent", 30)

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
		local measure_Vertex_Similarity = p.aqsSummaryData.Measure_Vertex_Similarity
		local v = getFFlagUGCValidateAQMeshQualityBlockUpload() and set[p.uploadCategory]

		if measure_Vertex_Similarity == nil then
			if v then
				error("Measure_Vertex_Similarity: AQS summary data is nil")
			else
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Vertex_Similarity"
				})
			end
		else
			local v2 = defineFastInt / 100

			for k, v3 in measure_Vertex_Similarity do
				if k == "measurement_score" then
					continue
				end

				if v3 == nil or v3.similar_vertex_percent == nil then
					object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
						measureName = "Measure_Vertex_Similarity"
					})

					return
				end

				local similar_vertex_percent = tonumber(v3.similar_vertex_percent) or 0

				if not (v2 < similar_vertex_percent) then
					continue
				end

				local v4 = {
					partName = k,
					similar_vertex_percent = string.format("%.2f", similar_vertex_percent * 100),
					threshold = tostring(defineFastInt)
				}

				if v then
					object:fail(ErrorSourceStrings.Keys.AQSWarn_VertexSimilarity, v4)
				else
					object:warn(ErrorSourceStrings.Keys.AQSWarn_VertexSimilarity, v4)
				end
			end
		end
	end
}
