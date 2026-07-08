local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)
local v5 = game:DefineFastInt("UGCValidateRenderMeshOutsideOuterCageMeshThreshold", 65)

return {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQCageQualityLC),
	run = function(p1, p2) -- line: 16
		-- upvalues: ErrorSourceStrings (copy), v5 (copy), getFFlagUGCValidateAQScoreWarnings (copy)
		local Handle = p2.aqsSummaryData.Measure_Mesh_Outside_OuterCage.Handle
		local v9 = Handle and tonumber(Handle.mesh_outside_outer_cage_percent)

		if v9 == nil then
			p1:fail(ErrorSourceStrings.Keys.AQSInputDataError)

			return
		end

		if v9 * 100 > v5 then
			p1:fail(ErrorSourceStrings.Keys.MeasureMeshOutsideOuterCage, {
				mesh_outside_outer_cage_percent = string.format("%.2f", v9 * 100)
			})
		end

		if getFFlagUGCValidateAQScoreWarnings() and Handle.score ~= nil and tonumber(Handle.score) ~= 100 then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_MeshOutsideOuterCage, {
				score = tostring((math.floor(tonumber(Handle.score) or 0))),
				mesh_outside_outer_cage_percent = string.format("%.2f", (tonumber(Handle.mesh_outside_outer_cage_percent) or 0) * 100)
			})
		end
	end
}
