local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local defineFastInt = game:DefineFastInt("UGCValidationCageMeshDistanceMaxCageMeshDistanceAvatar", 60)
local defineFastInt2 = game:DefineFastInt("UGCValidationCageMeshDistanceMaxNegativeSDFThresholdAvatar", 30)

local getFFlagUGCValidateAQScoreWarnings = require(parent.flags.getFFlagUGCValidateAQScoreWarnings)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	["fflag"] = require(parent.flags.getFFlagUGCValidateAQCageQualityAvatar),
	run = function(object, p)
		local full_body_cage = p.aqsSummaryData.Measure_Cage_Mesh_Distance_Avatar.full_body_cage

		if
			full_body_cage == nil
			or full_body_cage.max_distance == nil
			or full_body_cage.negative_sdf_percent == nil
		then
			error("Measure_Cage_Mesh_Distance_Avatar: AQS summary missing required fields")
			return
		end

		local max_distance = tonumber(full_body_cage.max_distance)

		if defineFastInt / 100 < max_distance then
			object:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceAvatar_CageTooFar, {
				max_sdf = tonumber(full_body_cage.max_distance),
				max_sdf_threshold = defineFastInt / 100
			})
		end

		if defineFastInt2 < tonumber(full_body_cage.negative_sdf_percent) * 100 then
			object:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceAvatar_CageInsideMesh, {
				negtiveSDFPercent = string.format("%.2f", tonumber(full_body_cage.negative_sdf_percent) * 100)
			})
		end

		if
			getFFlagUGCValidateAQScoreWarnings()
			and full_body_cage.score ~= nil
			and tonumber(full_body_cage.score) ~= 100
		then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_CageMeshDistanceAvatar, {
				max_distance = full_body_cage.max_distance or "unknown",
				negative_sdf_percent = string.format("%.2f", (tonumber(full_body_cage.negative_sdf_percent) or 0) * 100)
			})
		end
	end
}
