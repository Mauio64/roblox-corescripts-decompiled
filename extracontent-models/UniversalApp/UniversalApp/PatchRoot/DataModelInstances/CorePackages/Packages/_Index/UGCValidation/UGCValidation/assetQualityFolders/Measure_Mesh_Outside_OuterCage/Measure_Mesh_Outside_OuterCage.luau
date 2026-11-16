local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)

local defineFastInt = game:DefineFastInt("UGCValidateRenderMeshOutsideOuterCageMeshThreshold", 65)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING, ValidationEnums.UploadCategory.EYEBROW_EYELASH },
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQCageQualityLC),
	run = function(object, p)
		local handle = p.aqsSummaryData.Measure_Mesh_Outside_OuterCage.Handle
		local mesh_outside_outer_cage_percent = handle and tonumber(handle.mesh_outside_outer_cage_percent)

		if mesh_outside_outer_cage_percent == nil then
			error("Measure_Mesh_Outside_OuterCage: AQS summary missing required fields")
			return
		end

		if defineFastInt < mesh_outside_outer_cage_percent * 100 then
			object:fail(ErrorSourceStrings.Keys.MeasureMeshOutsideOuterCage, {
				mesh_outside_outer_cage_percent = string.format("%.2f", mesh_outside_outer_cage_percent * 100)
			})
		end

		if getFFlagUGCValidateAQScoreWarnings() and handle.score ~= nil and tonumber(handle.score) ~= 100 then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MeshOutsideOuterCage, {
				mesh_outside_outer_cage_percent = string.format(
					"%.2f",
					(tonumber(handle.mesh_outside_outer_cage_percent) or 0) * 100
				)
			})
		end
	end
}
