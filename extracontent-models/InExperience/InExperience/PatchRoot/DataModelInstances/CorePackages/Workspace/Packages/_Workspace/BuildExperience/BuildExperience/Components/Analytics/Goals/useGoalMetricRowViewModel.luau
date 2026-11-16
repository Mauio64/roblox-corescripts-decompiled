local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local CreatorAnalytics = require(parent.DataHydration.CreatorAnalytics)
local DataStatus = CreatorAnalytics.DataStatus
require(BuildExperience.Analytics.AnalyticsWindow)
require(BuildExperience.Analytics.Goals.GoalTypes)
local useGoalMetricSummary = require(BuildExperience.Analytics.Goals.useGoalMetricSummary)
local AnalyticsUnit = require(BuildExperience.Analytics.AnalyticsUnit)
local formatStatNumber = require(BuildExperience.Analytics.formatStatNumber)
local FFlagBuildAnalyticsTwoDecimalPlaces = require(BuildExperience.Flags.FFlagBuildAnalyticsTwoDecimalPlaces)
local metricValueRoundsToZero = require(BuildExperience.Analytics.metricValueRoundsToZero)
local roundToDecimals = require(BuildExperience.Analytics.roundToDecimals)
local scaleValueToUnit = require(BuildExperience.Analytics.scaleValueToUnit)
local metricUnitTemplate = require(BuildExperience.Analytics.metricUnitTemplate)
local noDataPlaceholder = require(BuildExperience.Components.Analytics.noDataPlaceholder)

require(script.Parent.GoalMetricRowView)

local function getNumberValueText(summary, value)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local number = formatStatNumber(value.value, summary.format.unit, "Regular", robloxLocaleId)
	local templateFor = metricUnitTemplate.templateFor(summary.format.unit)

	if templateFor == nil then
		return { type = "raw", value = number }
	end

	return {
		type = "translationTemplate",
		template = templateFor,
		values = { number = number }
	}
end

local function getBreakdownValueText(summary, value)
	local format = summary.format

	if format.type == "custom" then
		return {
			type = "raw",
			value = format.formatter(value.metric, value.breakdown)
		}
	end

	local translationKeyFor = format.translationKeyFor(value.metric, value.breakdown)

	if translationKeyFor == nil then
		return { type = "empty" }
	end

	return { type = "translationKey", key = translationKeyFor }
end

local function getNumberDelta(summary, value)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local priorValue = value.priorValue
	local trendPct = value.trendPct

	if priorValue == nil or trendPct == nil then
		return nil
	end

	if
		metricValueRoundsToZero(
			scaleValueToUnit(priorValue, summary.format.unit),
			summary.format.unit,
			nil,
			robloxLocaleId
		)
		or metricValueRoundsToZero(trendPct, AnalyticsUnit.Percent, nil, robloxLocaleId)
	then
		return nil
	end

	local magnitude = roundToDecimals(math.abs(trendPct) * 100, FFlagBuildAnalyticsTwoDecimalPlaces and 2 or 1) / 100

	if magnitude == 0 then
		return nil
	end

	return {
		magnitude = magnitude,
		isPositive = trendPct > 0
	}
end

local function getDeltaValueText(p)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local number = formatStatNumber(p.magnitude, AnalyticsUnit.Percent, "Regular", robloxLocaleId)
	local templateFor = metricUnitTemplate.templateFor(AnalyticsUnit.Percent)

	if templateFor == nil then
		return { type = "raw", value = number }
	end

	return {
		type = "translationTemplate",
		template = templateFor,
		values = { number = number }
	}
end

local function buildLocalizationRequest(items)
	local localizationRequest = {}

	for k, item in items do
		if item.type == "translationTemplate" then
			local v = { item.template }

			for k2, value in item.values do
				v[k2] = value
			end

			localizationRequest[k] = v
		elseif item.type == "translationKey" then
			localizationRequest[k] = item.key
		end
	end

	return localizationRequest
end

local function useGoalMetricRowViewModel(data)
	local summary = data.summary
	local v = useGoalMetricSummary(data.universeId, summary.source, data.window, data.latestAvailableTime)
	local value = v.value

	local v2 = data.latestAvailableTime ~= nil
	local isLoading

	if data.metadataStatus == DataStatus.NotReady then
		isLoading = true
	elseif data.metadataStatus == DataStatus.Ready then
		isLoading = v2 and v.status == DataStatus.NotReady
	else
		isLoading = false
	end

	local valueText = nil

	if value == nil then
		valueText = { type = "empty" }
	elseif summary.kind == "number" then
		valueText = getNumberValueText(summary, value)
	elseif summary.kind == "breakdown" then
		valueText = getBreakdownValueText(summary, value)
	end

	local v3

	if not (value == nil or summary.kind ~= "number") then
		v3 = getNumberDelta(summary, value)
	end

	local deltaText = v3 == nil and { type = "empty" } or getDeltaValueText(v3)

	local v4 = useLocalization(buildLocalizationRequest({
		valueText = valueText,
		deltaText = deltaText
	}))
	local valueText2

	if valueText.type == "empty" then
		valueText2 = noDataPlaceholder
	elseif valueText.type == "raw" then
		valueText2 = valueText.value
	else
		valueText2 = v4.valueText
	end

	local deltaText2 = nil

	if deltaText.type == "raw" then
		deltaText2 = deltaText.value
	elseif deltaText.type ~= "empty" then
		deltaText2 = v4.deltaText
	end

	local v5 = {
		title = data.title,
		valueText = valueText2,
		icon = 0,
		deltaText = 0,
		isDeltaPositive = 0,
		isLoading = 0,
		layoutOrder = 0,
		testId = 0
	}
	local icon

	if summary.kind == "number" then
		icon = summary.icon
	end

	v5.icon = icon
	v5.deltaText = deltaText2
	v5.isDeltaPositive = v3 ~= nil and v3.isPositive
	v5.isLoading = isLoading
	v5.layoutOrder = data.layoutOrder
	v5.testId = data.testId
	return v5
end

return useGoalMetricRowViewModel
