local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Foundation")

local view = Foundation.View
local text = Foundation.Text

require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")
local MetricDetailSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/MetricDetailSheet/MetricDetailSheet")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCard/StatsCard")
local StatsCardContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/StatsCardContainer")
local GoalsSection = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Goals/GoalsSection")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/InstantStatCard")
local InstantStatsRow = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/InstantStatsRow")
local WindowSegmentedControl = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/Overview/WindowSegmentedControl")

local function sectionHeading(p2, p3)
	return React.createElement(text, {
		LayoutOrder = 1,
		Text = p2,
		tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
		testId = p3
	})
end

local function AnalyticsOverviewView(props)
	local testId = props.testId or "AnalyticsOverviewView"

	local createElement = React.createElement
	local v6 = {
		LayoutOrder = 1,
		tag = "col gap-xlarge size-full-0 auto-y",
		testId = `{testId}.Overview`
	}

	local overviewTitle = props.overviewTitle
	local formatted = `{testId}.OverviewHeading`
	local element = createElement(view, v6, {
		Heading = React.createElement(text, {
			LayoutOrder = 1,
			Text = overviewTitle,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			testId = formatted
		}),
		InstantStats = React.createElement(InstantStatsRow, {
			layoutOrder = 2,
			stats = props.instantStats
		})
	})

	local createElement2 = React.createElement
	local v8 = {
		LayoutOrder = 2,
		tag = "col gap-large size-full-0 auto-y",
		testId = `{testId}.KeyStats`
	}
	local v10

	if not FFlagBuildAnalyticsGoals then
		local keyStatsTitle = props.keyStatsTitle
		local formatted2 = `{testId}.KeyStatsHeading`
		v10 = React.createElement(text, {
			LayoutOrder = 1,
			Text = keyStatsTitle,
			tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
			testId = formatted2
		})
	end

	local v9 = {
		Heading = v10,
		WindowToggle = React.createElement(WindowSegmentedControl, {
			layoutOrder = 2,
			windows = props.windows,
			selectedWindowId = props.selectedWindowId,
			onWindowSelected = props.onWindowSelected
		}),
		Cards = 0,
		Goals = 0
	}

	local v11 = if not FFlagBuildAnalyticsGoals then React.createElement(StatsCardContainer, {
		layoutOrder = 3,
		cards = props.statsCards
	}) else nil
	v9.Cards = v11

	local v12 = if FFlagBuildAnalyticsGoals then React.createElement(GoalsSection, {
		onOpenChat = props.onOpenChat,
		universeId = props.universeId,
		window = props.window,
		layoutOrder = 4,
		testId = `{testId}.Goals`
	}) else nil
	v9.Goals = v12
	local element2 = createElement2(view, v8, v9)

	local sheet = props.sheet
	local createElement3 = React.createElement
	local v14 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col gap-xxlarge size-full-0 auto-y"] = true,
			["padding-bottom-xlarge"] = FFlagBuildAnalyticsGoals
		},
		testId = testId
	}

	local v16 = if sheet ~= nil then React.createElement(MetricDetailSheet, {
		metricId = sheet.metricId,
		universeId = sheet.universeId,
		window = sheet.window,
		latestAvailableTime = sheet.latestAvailableTime,
		metadataStatus = sheet.metadataStatus,
		onClose = props.onSheetClose,
		onOpenChat = props.onOpenChat
	}) else nil
	return createElement3(view, v14, {
		Overview = element,
		KeyStats = element2,
		Sheet = v16
	})
end

return AnalyticsOverviewView
