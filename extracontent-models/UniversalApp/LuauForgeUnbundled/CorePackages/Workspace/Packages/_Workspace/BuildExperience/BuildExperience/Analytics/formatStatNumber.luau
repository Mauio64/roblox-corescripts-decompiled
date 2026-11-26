local numberLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").NumberLocalization

local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local roundToDecimals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/roundToDecimals")
local FFlagBuildAnalyticsTwoDecimalPlaces = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsTwoDecimalPlaces")

local function formatNumber(p2, p3, p4)
	if p3 == "Regular" then
		return numberLocalization.localizeDecimal(p2, p4, 2)
	end

	if FFlagBuildAnalyticsTwoDecimalPlaces then
		return numberLocalization.abbreviateDecimal(p2, p4, 2)
	end

	return numberLocalization.abbreviate(p2, p4)
end

local function formatStatNumber(p2, p3, p4, p5)
	if p3 == AnalyticsUnit.Minutes then
		return numberLocalization.localizeDecimal(p2, p5, 2)
	end

	if p3 == AnalyticsUnit.Percent then
		return formatNumber(p2 * 100, p4, p5)
	end

	if p3 ~= AnalyticsUnit.Temporal then
		return formatNumber(p2, p4, p5)
	end

	local v5 = p2 / 60

	if math.abs(v5) < 1 then
		local v6 = roundToDecimals(v5, 2)
		return numberLocalization.localizeDecimal(v6, p5, 2)
	end

	return formatNumber(roundToDecimals(v5, FFlagBuildAnalyticsTwoDecimalPlaces and 2 or 1), p4, p5)
end

return formatStatNumber
