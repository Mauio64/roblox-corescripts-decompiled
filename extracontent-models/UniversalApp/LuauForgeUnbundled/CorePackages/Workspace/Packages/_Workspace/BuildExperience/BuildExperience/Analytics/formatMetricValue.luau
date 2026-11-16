local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization

local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local formatStatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/formatStatNumber")
local fillTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricUnitTemplate").fillTemplate

local function formatNumber(p2, p3, p4, p5)
	if p5 ~= "Full" then
		return formatStatNumber(p2, p3, "Abbreviated", p4)
	end

	if p3 == AnalyticsUnit.Percent then
		return numberLocalization.localizeDecimal(p2 * 100, p4, 2)
	end

	if p3 == AnalyticsUnit.Temporal then
		return numberLocalization.localizeDecimal(p2 / 60, p4, 2)
	end

	local v5 = p2 == math.floor(p2) and 0 or 2
	return numberLocalization.localizeDecimal(p2, p4, v5)
end

local function formatMetricValue(p2, p3, p4, p5, p6)
	local v5 = formatNumber(p2, p3, p4, p6)

	if p3 == AnalyticsUnit.Percent then
		return fillTemplate(p5.percent, v5)
	end

	if p3 == AnalyticsUnit.Temporal or p3 == AnalyticsUnit.Minutes then
		return fillTemplate(p5.duration, v5)
	end

	return v5
end

return formatMetricValue
