local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local Localization = require(parent.Localization)
local NumberLocalization = Localization.NumberLocalization

local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local roundToDecimals = require(BuildExperience.Analytics.roundToDecimals)
local FFlagBuildAnalyticsTwoDecimalPlaces = require(BuildExperience.Flags.FFlagBuildAnalyticsTwoDecimalPlaces)

local function formatNumber(p: number, p2: string?, p3: string)
	if p2 == "Regular" then
		return NumberLocalization.localizeDecimal(p, p3, 2)
	end

	if FFlagBuildAnalyticsTwoDecimalPlaces then
		return NumberLocalization.abbreviateDecimal(p, p3, 2)
	end

	return NumberLocalization.abbreviate(p, p3)
end

local function formatStatNumber(p: number, p2, p3: string?, p4: string)
	if p2 == AnalyticsUnit.Minutes then
		return NumberLocalization.localizeDecimal(p, p4, 2)
	end

	if p2 == AnalyticsUnit.Percent then
		return formatNumber(p * 100, p3, p4)
	end

	if p2 ~= AnalyticsUnit.Temporal then
		return formatNumber(p, p3, p4)
	end

	local v = p / 60

	if math.abs(v) < 1 then
		local v2 = roundToDecimals(v, 2)
		return NumberLocalization.localizeDecimal(v2, p4, 2)
	end

	return formatNumber(roundToDecimals(v, FFlagBuildAnalyticsTwoDecimalPlaces and 2 or 1), p3, p4)
end

return formatStatNumber
