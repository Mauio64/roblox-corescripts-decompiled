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
		local Measure_Mesh_Watertight = p2.aqsSummaryData.Measure_Mesh_Watertight

		if Measure_Mesh_Watertight == nil then
			if getFFlagUGCValidateAQMeshQualityBlockUpload() then
				error("Measure_Mesh_Watertight: AQS summary data is nil")

				return
			end

			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Mesh_Watertight"
			})

			return
		end

		local t1 = {
			Head = true,
			Head_Geo = true,
			Head_OuterCage = true
		}

		for v9, v10 in Measure_Mesh_Watertight do
			if v9 == "measurement_score" then
				continue
			end

			if v10 == nil or v10.boundary_edges_percent == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Mesh_Watertight"
				})

				return
			end

			if not t1[v9] and (tonumber(v10.boundary_edges_percent) or 0) > 0 then
				local t2 = {
					partName = v9,
					boundary_edges_percent = string.format("%.2f", (tonumber(v10.boundary_edges_percent) or 0) * 100)
				}

				if getFFlagUGCValidateAQMeshQualityBlockUpload() then
					p1:fail(ErrorSourceStrings.Keys.AQSWarn_MeshNotWatertight, t2)
				else
					p1:warn(ErrorSourceStrings.Keys.AQSWarn_MeshNotWatertight, t2)
				end
			end
		end
	end
}
