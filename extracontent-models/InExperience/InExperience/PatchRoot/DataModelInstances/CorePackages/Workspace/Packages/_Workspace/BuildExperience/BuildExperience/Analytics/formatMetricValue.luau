local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization

local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local formatStatNumber = require(BuildExperience.Analytics.formatStatNumber)
local metricUnitTemplate = require(BuildExperience.Analytics.metricUnitTemplate)

local fillTemplate = metricUnitTemplate.fillTemplate

local function formatNumber(p: number, p2, p3: string, p4: string?)
	if p4 ~= "Full" then
		return formatStatNumber(p, p2, "Abbreviated", p3)
	end

	if p2 == AnalyticsUnit.Percent then
		return NumberLocalization.localizeDecimal(p * 100, p3, 2)
	end

	if p2 == AnalyticsUnit.Temporal then
		return NumberLocalization.localizeDecimal(p / 60, p3, 2)
	end

	local v = p == math.floor(p) and 0 or 2
	return NumberLocalization.localizeDecimal(p, p3, v)
end

local function formatMetricValue(p: number, p2, p3: string, p4, p5: string?)
	local v = formatNumber(p, p2, p3, p5)

	if p2 == AnalyticsUnit.Percent then
		return fillTemplate(p4.percent, v)
	end

	if p2 == AnalyticsUnit.Temporal or p2 == AnalyticsUnit.Minutes then
		return fillTemplate(p4.duration, v)
	end

	return v
end

return formatMetricValue
