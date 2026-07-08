local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local Constants = require(ParentParent.Constants)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)
local v6 = game:DefineFastInt("UGCValidateLCCagingIncorrectUVThresholdBodyPart", 7)

return {
	categories = { ValidationEnums.UploadCategory.FULL_BODY },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQCageQualityAvatar),
	run = function(p1, p2) -- line: 15
		-- upvalues: Constants (copy), ErrorSourceStrings (copy), v6 (copy), getFFlagUGCValidateAQScoreWarnings (copy)
		local Measure_Cage_UV_Avatar = p2.aqsSummaryData.Measure_Cage_UV_Avatar

		for _, v11 in Constants.R15_CAGE_PARTS do
			if Measure_Cage_UV_Avatar[v11] == nil or Measure_Cage_UV_Avatar[v11].incorrect_uv_count == nil then
				p1:fail(ErrorSourceStrings.Keys.AQSInputDataError)
			else
				if tonumber(Measure_Cage_UV_Avatar[v11].incorrect_uv_count) > v6 then
					p1:fail(ErrorSourceStrings.Keys.MeasureCageUV, {
						cage_name = v11,
						incorrect_uv_count = tonumber(Measure_Cage_UV_Avatar[v11].incorrect_uv_count)
					})
				end

				if getFFlagUGCValidateAQScoreWarnings() and Measure_Cage_UV_Avatar[v11].score ~= nil and tonumber(Measure_Cage_UV_Avatar[v11].score) ~= 100 then
					p1:warn(ErrorSourceStrings.Keys.AQSWarn_CageUV, {
						score = tostring((math.floor(tonumber(Measure_Cage_UV_Avatar[v11].score) or 0))),
						cage_name = v11,
						incorrect_uv_count = Measure_Cage_UV_Avatar[v11].incorrect_uv_count or "0"
					})
				end
			end
		end
	end
}
