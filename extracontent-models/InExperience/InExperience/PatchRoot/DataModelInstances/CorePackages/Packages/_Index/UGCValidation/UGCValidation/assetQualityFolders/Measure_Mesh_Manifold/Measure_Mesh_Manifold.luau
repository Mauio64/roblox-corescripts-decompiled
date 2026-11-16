local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

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
		local measure_Mesh_Manifold = p.aqsSummaryData.Measure_Mesh_Manifold

		if measure_Mesh_Manifold == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Mesh_Manifold"
			})

			return
		end

		for k, v in measure_Mesh_Manifold do
			if k == "measurement_score" then
				continue
			end

			if v == nil or v.score == nil then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Mesh_Manifold"
				})
				break
			elseif tonumber(v.score) ~= 100 then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MeshManifold, { partName = k })
			end
		end
	end
}
