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
		local measure_Mesh_Watertight = p.aqsSummaryData.Measure_Mesh_Watertight

		if measure_Mesh_Watertight == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Mesh_Watertight"
			})

			return
		end

		local v = { Head = true, Head_Geo = true, Head_OuterCage = true }

		for k, v2 in measure_Mesh_Watertight do
			if k == "measurement_score" then
				continue
			end

			if v2 == nil or v2.boundary_edges_percent == nil then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Mesh_Watertight"
				})
				break
			elseif not v[k] and (tonumber(v2.boundary_edges_percent) or 0) > 0 then
				object:warn(ErrorSourceStrings.Keys.AQSWarn_MeshNotWatertight, {
					partName = k,
					boundary_edges_percent = string.format("%.2f", (tonumber(v2.boundary_edges_percent) or 0) * 100)
				})
			end
		end
	end
}
