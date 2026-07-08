local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local v4 = game:DefineFastInt("UGCValidationCageMeshDistanceMaxCageMeshDistanceAvatar", 60)
local v5 = game:DefineFastInt("UGCValidationCageMeshDistanceMaxNegativeSDFThresholdAvatar", 30)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQCageQualityAvatar),
	run = function(p1, p2) -- line: 16
		-- upvalues: ErrorSourceStrings (copy), v4 (copy), v5 (copy), getFFlagUGCValidateAQScoreWarnings (copy)
		local full_body_cage = p2.aqsSummaryData.Measure_Cage_Mesh_Distance_Avatar.full_body_cage

		if full_body_cage == nil or (full_body_cage.max_distance == nil or full_body_cage.negative_sdf_percent == nil) then
			p1:fail(ErrorSourceStrings.Keys.AQSInputDataError)

			return
		end

		if tonumber(full_body_cage.max_distance) > v4 / 100 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceAvatar_CageTooFar, {
				max_sdf = tonumber(full_body_cage.max_distance),
				max_sdf_threshold = v4 / 100
			})
		end

		if tonumber(full_body_cage.negative_sdf_percent) * 100 > v5 then
			p1:fail(ErrorSourceStrings.Keys.MeasureCageMeshDistanceAvatar_CageInsideMesh, {
				negtiveSDFPercent = string.format("%.2f", tonumber(full_body_cage.negative_sdf_percent) * 100)
			})
		end

		if getFFlagUGCValidateAQScoreWarnings() and full_body_cage.score ~= nil and tonumber(full_body_cage.score) ~= 100 then
			p1:warn(ErrorSourceStrings.Keys.AQSWarn_CageMeshDistanceAvatar, {
				score = tostring((math.floor(tonumber(full_body_cage.score) or 0))),
				max_distance = full_body_cage.max_distance or "unknown",
				negative_sdf_percent = string.format("%.2f", (tonumber(full_body_cage.negative_sdf_percent) or 0) * 100)
			})
		end
	end
}
