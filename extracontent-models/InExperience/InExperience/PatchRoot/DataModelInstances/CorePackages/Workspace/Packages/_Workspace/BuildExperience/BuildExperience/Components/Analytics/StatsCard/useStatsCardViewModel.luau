local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local LocalizationService = game:GetService("LocalizationService")

require(parent.Foundation)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

require(script.Parent.StatsCardView)
require(BuildExperience.Analytics.AnalyticsUnit)
require(script.Parent.StatsCardValueFormat)
local formatStatNumber = require(BuildExperience.Analytics.formatStatNumber)
local metricValueRoundsToZero = require(BuildExperience.Analytics.metricValueRoundsToZero)
local metricUnitTemplate = require(BuildExperience.Analytics.metricUnitTemplate)
local noDataPlaceholder = require(BuildExperience.Components.Analytics.noDataPlaceholder)

local templateFor = metricUnitTemplate.templateFor

local function useStatsCardViewModel(data)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v = data.hasData == nil or data.hasData

	local v2 = formatStatNumber(data.statValue, data.statUnit, data.statValueFormat, robloxLocaleId)
	local v3 = templateFor(data.statUnit)

	local deltaValue = math.abs(data.deltaValue)
	local v4

	if v then
		if deltaValue == 0 then
			v4 = false
		else
			v4 = not metricValueRoundsToZero(deltaValue, data.deltaUnit, data.deltaValueFormat, robloxLocaleId)
		end
	else
		v4 = v
	end

	local v5

	if v4 then
		v5 = formatStatNumber(deltaValue, data.deltaUnit, data.deltaValueFormat, robloxLocaleId)
	end

	local v6 = templateFor(data.deltaUnit)

	local v7 = {}

	if v and v3 ~= nil then
		v7.statText = {
			v3,
			number = v2
		}
	end

	if v4 and v6 ~= nil then
		v7.deltaText = {
			v6,
			number = v5
		}
	end

	local v8 = useLocalization(v7)

	if v then
		if v3 ~= nil then
			v2 = v8.statText
		end
	else
		v2 = noDataPlaceholder
	end

	if v4 then
		if v6 ~= nil then
			v5 = v8.deltaText
		end
	else
		v5 = nil
	end

	local v9 = {
		title = data.title,
		statText = v2,
		statIcon = 0,
		statIconPosition = 0,
		deltaText = 0,
		deltaIcon = 0,
		deltaIconPosition = 0,
		isDeltaPositive = 0,
		isLoading = 0,
		isSelected = 0,
		onActivated = 0,
		layoutOrder = 0,
		testId = 0
	}
	local statIcon

	if v then
		statIcon = data.statIcon
	end

	v9.statIcon = statIcon
	v9.statIconPosition = data.statIconPosition
	v9.deltaText = v5
	v9.deltaIcon = data.deltaIcon
	v9.deltaIconPosition = data.deltaIconPosition
	v9.isDeltaPositive = v and data.deltaValue > 0
	v9.isLoading = data.isLoading == true
	v9.isSelected = data.isSelected
	v9.onActivated = data.onActivated
	v9.layoutOrder = data.layoutOrder
	v9.testId = data.testId
	return v9
end

return useStatsCardViewModel
