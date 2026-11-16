local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQMeshQualityBlockUpload = require(parent.flags.getFFlagUGCValidateAQMeshQualityBlockUpload)

local defineFastInt = game:DefineFastInt("UGCValidationMeshIslandVolumeMaxComponents", 10)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY, ValidationEnums.UploadCategory.DYNAMIC_HEAD },
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQMeshIslandVolume),
	run = function(object, p)
		local measure_Mesh_Island_Volume = p.aqsSummaryData.Measure_Mesh_Island_Volume

		if measure_Mesh_Island_Volume == nil then
			if getFFlagUGCValidateAQMeshQualityBlockUpload() then
				error("Measure_Mesh_Island_Volume: AQS summary data is nil")
			else
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Mesh_Island_Volume"
				})
			end
		else
			for k, v in measure_Mesh_Island_Volume do
				if k == "measurement_score" then
					continue
				end

				if v == nil or v.score == nil then
					object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
						measureName = "Measure_Mesh_Island_Volume"
					})

					return
				end

				local num_disconnected_components = tonumber(v.num_disconnected_components) or 0

				if defineFastInt < num_disconnected_components then
					local v2 = {
						partName = k,
						num_disconnected_components = tostring(num_disconnected_components),
						max_disconnected_components = tostring(defineFastInt)
					}

					if getFFlagUGCValidateAQMeshQualityBlockUpload() then
						object:fail(ErrorSourceStrings.Keys.AQSFail_TooManyDisconnectedComponents, v2)
					else
						object:warn(ErrorSourceStrings.Keys.AQSFail_TooManyDisconnectedComponents, v2)
					end
				end

				if tonumber(v.score) == 100 then
					continue
				end

				local v2 = {
					partName = k,
					num_small_volume_islands = v.num_small_volume_islands or "unknown",
					num_disconnected_components = v.num_disconnected_components or "unknown"
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					object:fail(ErrorSourceStrings.Keys.AQSWarn_MeshIslandVolume, v2)
				else
					object:warn(ErrorSourceStrings.Keys.AQSWarn_MeshIslandVolume, v2)
				end
			end
		end
	end
}
