local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(ParentParent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)
local v5 = game:DefineFastInt("UGCValidationMeshIslandVolumeMaxComponents", 10)

return {
	categories = {
		ValidationEnums.UploadCategory.FULL_BODY,
		ValidationEnums.UploadCategory.DYNAMIC_HEAD
	},
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQMeshIslandVolume),
	run = function(p1, p2) -- line: 17
		-- upvalues: getFFlagUGCValidateAQMeshQualityBlockUpload (copy), ErrorSourceStrings (copy), v5 (copy)
		local Measure_Mesh_Island_Volume = p2.aqsSummaryData.Measure_Mesh_Island_Volume

		if Measure_Mesh_Island_Volume == nil then
			if getFFlagUGCValidateAQMeshQualityBlockUpload() then
				error("Measure_Mesh_Island_Volume: AQS summary data is nil")

				return
			end

			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Mesh_Island_Volume"
			})

			return
		end

		for v9, v10 in Measure_Mesh_Island_Volume do
			if v9 == "measurement_score" then
				continue
			end

			if v10 == nil or v10.score == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Mesh_Island_Volume"
				})

				return
			end

			local v11 = tonumber(v10.num_disconnected_components) or 0

			if v11 > v5 then
				local t1 = {
					partName = v9,
					num_disconnected_components = tostring(v11),
					max_disconnected_components = tostring(v5)
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					p1:fail(ErrorSourceStrings.Keys.AQSFail_TooManyDisconnectedComponents, t1)
				else
					p1:warn(ErrorSourceStrings.Keys.AQSFail_TooManyDisconnectedComponents, t1)
				end
			end

			if tonumber(v10.score) ~= 100 then
				local t2 = {
					partName = v9,
					num_small_volume_islands = v10.num_small_volume_islands or "unknown",
					num_disconnected_components = v10.num_disconnected_components or "unknown",
					score = tostring((math.floor(tonumber(v10.score) or 0)))
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					p1:fail(ErrorSourceStrings.Keys.AQSWarn_MeshIslandVolume, t2)
				else
					p1:warn(ErrorSourceStrings.Keys.AQSWarn_MeshIslandVolume, t2)
				end
			end
		end
	end
}
