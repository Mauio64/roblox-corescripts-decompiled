local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local View = Foundation.View
local Text = Foundation.Text

require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
require(parent.DataHydration.CreatorAnalytics)
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)
local MetricDetailSheet = require(BuildExperience.Components.Analytics.MetricDetailSheet.MetricDetailSheet)
require(BuildExperience.Components.Analytics.StatsCard.StatsCard)
local StatsCardContainer = require(BuildExperience.Components.Analytics.StatsCardContainer)
local GoalsSection = require(BuildExperience.Components.Analytics.Goals.GoalsSection)
require(script.Parent.InstantStatCard)
local InstantStatsRow = require(script.Parent.InstantStatsRow)
local WindowSegmentedControl = require(script.Parent.WindowSegmentedControl)

local function sectionHeading(text: string, testId: string) -- 2 equivalent calls inferred from this helper
	return React.createElement(Text, {
		LayoutOrder = 1,
		Text = text,
		tag = "size-full-0 auto-y text-heading-small text-align-x-left content-emphasis",
		testId = testId
	})
end

local function AnalyticsOverviewView(props)
	local testId = props.testId or "AnalyticsOverviewView"

	local element = React.createElement(
		View,
		{ LayoutOrder = 1, tag = "col gap-xlarge size-full-0 auto-y", testId = `{testId}.Overview` },
		{
			Heading = sectionHeading(props.overviewTitle, `{testId}.OverviewHeading`), -- inferred equivalent call
			InstantStats = React.createElement(InstantStatsRow, {
				layoutOrder = 2,
				stats = props.instantStats
			})
		}
	)

	local createElement = React.createElement
	local v = {
		LayoutOrder = 2,
		tag = "col gap-large size-full-0 auto-y",
		testId = `{testId}.KeyStats`
	}
	local heading

	if not FFlagBuildAnalyticsGoals then
		heading = sectionHeading(props.keyStatsTitle, `{testId}.KeyStatsHeading`) -- inferred equivalent call
	end

	local v2 = {
		Heading = heading,
		WindowToggle = React.createElement(WindowSegmentedControl, {
			layoutOrder = 2,
			windows = props.windows,
			selectedWindowId = props.selectedWindowId,
			onWindowSelected = props.onWindowSelected
		}),
		Cards = 0,
		Goals = 0
	}
	local cards

	if not FFlagBuildAnalyticsGoals then
		cards = React.createElement(StatsCardContainer, {
			layoutOrder = 3,
			cards = props.statsCards
		})
	end

	v2.Cards = cards
	local goals

	if FFlagBuildAnalyticsGoals then
		goals = React.createElement(GoalsSection, {
			onOpenChat = props.onOpenChat,
			universeId = props.universeId,
			window = props.window,
			layoutOrder = 4,
			testId = `{testId}.Goals`
		})
	end

	v2.Goals = goals
	local element2 = createElement(View, v, v2)

	local sheet = props.sheet
	local createElement2 = React.createElement
	local v3 = {
		LayoutOrder = props.layoutOrder,
		tag = {
			["col gap-xxlarge size-full-0 auto-y"] = true,
			["padding-bottom-xlarge"] = FFlagBuildAnalyticsGoals
		},
		testId = testId
	}
	local sheet2

	if sheet ~= nil then
		sheet2 = React.createElement(MetricDetailSheet, {
			metricId = sheet.metricId,
			universeId = sheet.universeId,
			window = sheet.window,
			latestAvailableTime = sheet.latestAvailableTime,
			metadataStatus = sheet.metadataStatus,
			onClose = props.onSheetClose,
			onOpenChat = props.onOpenChat
		})
	end

	return createElement2(View, v3, { Overview = element, KeyStats = element2, Sheet = sheet2 })
end

return AnalyticsOverviewView
