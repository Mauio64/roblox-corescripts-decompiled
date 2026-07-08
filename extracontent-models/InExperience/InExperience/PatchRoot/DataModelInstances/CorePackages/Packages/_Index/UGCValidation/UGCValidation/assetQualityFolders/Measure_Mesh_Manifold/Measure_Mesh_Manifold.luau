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
		local Measure_Mesh_Manifold = p2.aqsSummaryData.Measure_Mesh_Manifold

		if Measure_Mesh_Manifold == nil then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Mesh_Manifold"
			})

			return
		end

		for v7, v8 in Measure_Mesh_Manifold do
			if v7 == "measurement_score" then
				continue
			end

			if v8 == nil or v8.score == nil then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
					measureName = "Measure_Mesh_Manifold"
				})

				return
			end

			if tonumber(v8.score) ~= 100 then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_MeshManifold, {
					partName = v7,
					score = tostring((math.floor(tonumber(v8.score) or 0)))
				})
			end
		end
	end
}
