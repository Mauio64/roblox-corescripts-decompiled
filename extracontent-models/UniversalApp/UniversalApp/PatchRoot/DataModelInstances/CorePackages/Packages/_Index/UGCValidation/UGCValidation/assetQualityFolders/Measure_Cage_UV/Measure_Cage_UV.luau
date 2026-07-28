local ParentParent = script.Parent.Parent.Parent

require(ParentParent.util.Types)

local ValidationEnums = require(ParentParent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(ParentParent.validationSystem.ErrorSourceStrings)
local getFFlagUGCValidateAQScoreWarnings = require(ParentParent.flags.getFFlagUGCValidateAQScoreWarnings)
local v5 = game:DefineFastInt("UGCValidateLCCagingIncorrectUVThreshold", 100)
local t1 = {
	categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING },
	fflag = require(ParentParent.flags.getFFlagUGCValidateAQCageQualityLC)
}
local t2 = {
	"Handle_InnerCage",
	"Handle_OuterCage"
}

function t1.run(p1, p2) -- line: 19
	-- upvalues: t2 (copy), v5 (copy), ErrorSourceStrings (copy), getFFlagUGCValidateAQScoreWarnings (copy)
	local Measure_Cage_UV = p2.aqsSummaryData.Measure_Cage_UV

	if Measure_Cage_UV == nil then
		error("Measure_Cage_UV: AQS summary data is nil")
	end

	for _, v12 in t2 do
		if Measure_Cage_UV[v12] == nil or Measure_Cage_UV[v12].incorrect_uv_count == nil then
			error("Measure_Cage_UV: AQS summary missing required fields for cage " .. v12)
		else
			if tonumber(Measure_Cage_UV[v12].incorrect_uv_count) > v5 then
				p1:fail(ErrorSourceStrings.Keys.MeasureCageUV, {
					cage_name = v12,
					incorrect_uv_count = tonumber(Measure_Cage_UV[v12].incorrect_uv_count)
				})
			end

			if getFFlagUGCValidateAQScoreWarnings() and Measure_Cage_UV[v12].score ~= nil and tonumber(Measure_Cage_UV[v12].score) ~= 100 then
				p1:warn(ErrorSourceStrings.Keys.AQSWarn_CageUV, {
					score = tostring((math.floor(tonumber(Measure_Cage_UV[v12].score) or 0))),
					cage_name = v12,
					incorrect_uv_count = Measure_Cage_UV[v12].incorrect_uv_count or "0"
				})
			end
		end
	end
end

return t1
