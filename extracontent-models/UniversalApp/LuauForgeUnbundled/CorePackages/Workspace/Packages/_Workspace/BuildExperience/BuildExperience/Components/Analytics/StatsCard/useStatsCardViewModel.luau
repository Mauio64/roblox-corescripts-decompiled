local LocalizationService = game:GetService("LocalizationService")

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCardView")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsUnit")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCardValueFormat")
local formatStatNumber = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/formatStatNumber")
local metricValueRoundsToZero = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricValueRoundsToZero")
local metricUnitTemplate = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/metricUnitTemplate")
local noDataPlaceholder = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/noDataPlaceholder")

local templateFor = metricUnitTemplate.templateFor

local function useStatsCardViewModel(data)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local v5 = data.hasData == nil or data.hasData

	local v6 = formatStatNumber(data.statValue, data.statUnit, data.statValueFormat, robloxLocaleId)
	local v7 = templateFor(data.statUnit)

	local deltaValue = math.abs(data.deltaValue)
	local v8

	if v5 then
		if deltaValue == 0 then
			v8 = false
		else
			v8 = not metricValueRoundsToZero(deltaValue, data.deltaUnit, data.deltaValueFormat, robloxLocaleId)
		end
	else
		v8 = v5
	end

	local v9

	if v8 then
		v9 = formatStatNumber(deltaValue, data.deltaUnit, data.deltaValueFormat, robloxLocaleId)
	end

	local v10 = templateFor(data.deltaUnit)

	local v11 = {}

	if v5 and v7 ~= nil then
		v11.statText = {
			v7,
			number = v6
		}
	end

	if v8 and v10 ~= nil then
		v11.deltaText = {
			v10,
			number = v9
		}
	end

	local v12 = useLocalization(v11)

	if v5 then
		if v7 ~= nil then
			v6 = v12.statText
		end
	else
		v6 = noDataPlaceholder
	end

	if v8 then
		if v10 ~= nil then
			v9 = v12.deltaText
		end
	else
		v9 = nil
	end

	local v13 = {
		title = data.title,
		statText = v6,
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

	local v14 = if v5 then data.statIcon else nil
	v13.statIcon = v14
	v13.statIconPosition = data.statIconPosition
	v13.deltaText = v9
	v13.deltaIcon = data.deltaIcon
	v13.deltaIconPosition = data.deltaIconPosition
	v13.isDeltaPositive = v5 and data.deltaValue > 0
	v13.isLoading = data.isLoading == true
	v13.isSelected = data.isSelected
	v13.onActivated = data.onActivated
	v13.layoutOrder = data.layoutOrder
	v13.testId = data.testId
	return v13
end

return useStatsCardViewModel
