local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local defineFastInt = game:DefineFastInt("UGCValidationMeshIslandMLMinScore", 9)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	run = function(object, p)
		local measure_Mesh_Island_ML = p.aqsSummaryData.Measure_Mesh_Island_ML

		if measure_Mesh_Island_ML == nil then
			object:err("Measure_Mesh_Island_ML: missing AQS summary data")
			return
		end

		for k, v in measure_Mesh_Island_ML do
			if k == "measurement_score" then
				continue
			end

			if v == nil or v.score == nil then
				object:err("Measure_Mesh_Island_ML: missing score data for " .. tostring(k))
				break
			end

			local score = tonumber(v.score) or 0

			if score < 0 then
				error("Measure_Mesh_Island_ML: received unexpected negative score, possible upstream bug")
			end

			if score < defineFastInt then
				object:fail(ErrorSourceStrings.Keys.AQSFail_MeshIslandML)
			end
		end
	end
}
