local parent = script.Parent.Parent.Parent
require(parent.util.Types)
local ValidationEnums = require(parent.validationSystem.ValidationEnums)
local ErrorSourceStrings = require(parent.validationSystem.ErrorSourceStrings)

local MeasureCagePartPlacement = {}

MeasureCagePartPlacement.categories = { ValidationEnums.UploadCategory.LAYERED_CLOTHING }
MeasureCagePartPlacement.fflag = require(parent.flags.getFFlagUGCValidateAQCagePartPlacement)

local function collectViolationDetails(p)
	local count = 0
	local violationDetails = {}

	while true do
		local violationType = p[`violation_{count}_type`]

		if violationType == nil then
			return violationDetails
		end

		if violationType == "part_vertex_count_mismatch" then
			table.insert(violationDetails, {
				violationType = "part_vertex_count_mismatch",
				partName = p[`violation_{count}_upper_part`] or "unknown",
				expectedCount = p[`violation_{count}_expected_vertex_count`] or "?",
				actualCount = p[`violation_{count}_actual_vertex_count`] or "?"
			})
		else
			table.insert(violationDetails, {
				violationType = violationType,
				upperPart = p[`violation_{count}_upper_part`] or "unknown",
				lowerPart = p[`violation_{count}_lower_part`] or "unknown"
			})
		end

		count += 1
	end
end

function MeasureCagePartPlacement.run(object, p)
	local measure_Cage_Part_Placement = p.aqsSummaryData.Measure_Cage_Part_Placement

	if measure_Cage_Part_Placement == nil then
		object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
			measureName = "Measure_Cage_Part_Placement"
		})

		return
	end

	for k, v in measure_Cage_Part_Placement do
		if k == "measurement_score" then
			continue
		end

		if v == nil or v.score == nil then
			object:warn(ErrorSourceStrings.Keys.AQSWarn_MissingData, {
				measureName = "Measure_Cage_Part_Placement"
			})
			break
		end

		if tonumber(v.score) == 100 then
			continue
		end

		local v2 = collectViolationDetails(v)

		for _, v3 in v2 do
			if v3.violationType == "part_vertex_count_mismatch" then
				object:fail(ErrorSourceStrings.Keys.AQSFail_CagePartVertexCount, {
					cageName = k,
					partName = v3.partName,
					expectedCount = v3.expectedCount,
					actualCount = v3.actualCount
				})
			else
				object:fail(ErrorSourceStrings.Keys.AQSFail_CagePartPlacement, {
					cageName = k,
					upperPart = v3.upperPart,
					lowerPart = v3.lowerPart
				})
			end
		end
	end
end

return MeasureCagePartPlacement
