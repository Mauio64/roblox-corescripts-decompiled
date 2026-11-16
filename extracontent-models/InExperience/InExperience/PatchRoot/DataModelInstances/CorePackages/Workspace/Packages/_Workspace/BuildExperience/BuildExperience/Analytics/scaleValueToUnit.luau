local BuildExperience = script:FindFirstAncestor("BuildExperience")

local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)

local function scaleValueToUnit(p: number, p2)
	if p2 == AnalyticsUnit.Temporal then
		return p * 60
	end

	return p
end

return scaleValueToUnit
