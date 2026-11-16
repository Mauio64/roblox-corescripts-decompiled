local LocalizationService = game:GetService("LocalizationService")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local dataStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics").DataStatus
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/GoalTypes")
local useGoalMetricSummary = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/Goals/useGoalMetricSummary")
local AnalyticsUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
local formatStatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/formatStatNumber")
local FFlagBuildAnalyticsTwoDecimalPlaces = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsTwoDecimalPlaces")
local metricValueRoundsToZero = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricValueRoundsToZero")
local roundToDecimals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/roundToDecimals")
local scaleValueToUnit = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/scaleValueToUnit")
local metricUnitTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricUnitTemplate")
local noDataPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/noDataPlaceholder")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalMetricRowView")

local function getNumberValueText(summary, value)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = formatStatNumber(value.value, summary.format.unit, "Regular", robloxLocaleId)
	local templateFor = metricUnitTemplate.templateFor(summary.format.unit)

	if templateFor == nil then
		return { type = "raw", value = v5 }
	end

	return {
		type = "translationTemplate",
		template = templateFor,
		values = { number = v5 }
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
		metricValueRoundsToZero(scaleValueToUnit(priorValue, summary.format.unit), summary.format.unit, nil, robloxLocaleId)
		or metricValueRoundsToZero(trendPct, AnalyticsUnit.Percent, nil, robloxLocaleId)
	then
		return nil
	end

	local v6 = roundToDecimals(math.abs(trendPct) * 100, FFlagBuildAnalyticsTwoDecimalPlaces and 2 or 1) / 100

	if v6 == 0 then
		return nil
	end

	return {
		magnitude = v6,
		isPositive = trendPct > 0
	}
end

local function getDeltaValueText(p2)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = formatStatNumber(p2.magnitude, AnalyticsUnit.Percent, "Regular", robloxLocaleId)
	local templateFor = metricUnitTemplate.templateFor(AnalyticsUnit.Percent)

	if templateFor == nil then
		return { type = "raw", value = v5 }
	end

	return {
		type = "translationTemplate",
		template = templateFor,
		values = { number = v5 }
	}
end

local function buildLocalizationRequest(items)
	local localizationRequest = {}

	for k, item in items do
		if item.type == "translationTemplate" then
			local v5 = { item.template }

			for k2, value in item.values do
				v5[k2] = value
			end

			localizationRequest[k] = v5
		elseif item.type == "translationKey" then
			localizationRequest[k] = item.key
		end
	end

	return localizationRequest
end

local function useGoalMetricRowViewModel(data)
	local summary = data.summary
	local v5 = useGoalMetricSummary(data.universeId, summary.source, data.window, data.latestAvailableTime)
	local value = v5.value

	local v6 = data.latestAvailableTime ~= nil
	local v7

	if data.metadataStatus == dataStatus.NotReady then
		v7 = true
	else
		v7 = data.metadataStatus == dataStatus.Ready and (v6 and v5.status == dataStatus.NotReady)
	end

	local v8 = nil

	if value == nil then
		v8 = { type = "empty" }
	elseif summary.kind == "number" then
		v8 = getNumberValueText(summary, value)
	elseif summary.kind == "breakdown" then
		v8 = getBreakdownValueText(summary, value)
	end

	local v9

	if not (value == nil or summary.kind ~= "number") then
		v9 = getNumberDelta(summary, value)
	end

	local v10 = v9 == nil and { type = "empty" } or getDeltaValueText(v9)

	local v11 = useLocalization(buildLocalizationRequest({
		valueText = v8,
		deltaText = v10
	}))
	local v12

	if v8.type == "empty" then
		v12 = noDataPlaceholder
	else
		v12 = if v8.type == "raw" then v8.value else v11.valueText
	end

	local v13 = if v10.type == "raw" then v10.value elseif v10.type ~= "empty" then v11.deltaText else nil

	local v14 = {
		title = data.title,
		valueText = v12,
		icon = 0,
		deltaText = 0,
		isDeltaPositive = 0,
		isLoading = 0,
		layoutOrder = 0,
		testId = 0
	}

	local v15 = if summary.kind == "number" then summary.icon else nil
	v14.icon = v15
	v14.deltaText = v13
	v14.isDeltaPositive = v9 ~= nil and v9.isPositive
	v14.isLoading = v7
	v14.layoutOrder = data.layoutOrder
	v14.testId = data.testId
	return v14
end

return useGoalMetricRowViewModel
