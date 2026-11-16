local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/FocusNavigationUtils")
local Responsive = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Responsive")
local WebViewUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/WebViewUtils")
local useOpenWebView = WebViewUtils.useOpenWebView
local openWebViewSession = WebViewUtils.openWebViewSession
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/Localization").Hooks.useLocalization

local FFlagBuildAnalyticsCreatorHubWindowFix = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsCreatorHubWindowFix")
local FFlagBuildAnalyticsGoals = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildAnalyticsGoals")
local FFlagBuildCheckGamePermissions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildCheckGamePermissions")

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
local AnalyticsKeys = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsKeys")
local AnalyticsMetric = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsMetric")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Analytics/AnalyticsWindow")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/CreatorAnalytics")
local GameConfigurationActions = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/GameConfigurationActions")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/Analytics/MetricDetailSheet/MetricDetailSheetView")
local useClosableFocusRoot = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/utils/useClosableFocusRoot")

local function useMetricDetailSheetViewModel(data)
	local v5, v6

	if FFlagBuildAnalyticsGoals then
		v5 = useClosableFocusRoot({
			surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
			isOpen = true,
			onClose = data.onClose
		})

		v6 = not (Responsive.usePreferredInput() == Responsive.Input.Directional)
	else
		v6 = true
	end

	local v7

	if data.metricId == nil then
		v7 = AnalyticsMetric.DailyActiveUsers
	else
		v7 = AnalyticsMetric.MetricById[data.metricId] or AnalyticsMetric.DailyActiveUsers
	end

	local v8 = data.latestAvailableTime
	local v9 = nil

	if FFlagBuildAnalyticsGoals then
		local state, setState = React.useState(1)
		local metrics = data.metrics
		local v10 = metrics == nil and 0 or #metrics
		local v11 = math.clamp(state, 1, (math.max(1, v10)))
		React.useEffect(function()
			setState(1)
		end, { metrics })

		if metrics ~= nil and v10 > 0 then
			v7 = metrics[v11]
			v8 = if data.latestByMetric ~= nil then data.latestByMetric[v7.id] else nil
		end

		if v10 > 1 then
			v9 = {
				index = v11,
				count = v10,
				onPrevious = function()
					setState((math.max(1, v11 - 1)))
				end,
				onNext = function()
					setState((math.min(v10, v11 + 1)))
				end
			}
		end
	end

	local v10 = useOpenWebView()

	local v11 = {
		analyze = 0,
		viewInOverview = 0,
		title = 0,
		summary = 0,
		description = 0,
		analyzeName = 0
	}

	local v12 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_SHEET_ASK_ABOUT_THIS else AnalyticsKeys.ANALYTICS_SHEET_ANALYZE
	v11.analyze = v12

	local v13 = if FFlagBuildAnalyticsGoals then AnalyticsKeys.ANALYTICS_SHEET_VIEW_MORE_STATS else AnalyticsKeys.ANALYTICS_SHEET_VIEW_IN_OVERVIEW
	v11.viewInOverview = v13

	local v14 = if FFlagBuildAnalyticsGoals then data.titleKey or v7.titleKey else v7.titleKey
	v11.title = v14
	v11.summary = v7.summaryKey
	v11.description = v7.descriptionKey
	v11.analyzeName = v7.analyzeNameKey

	local improvementKey = if FFlagBuildAnalyticsGoals then v7.improvementKey else nil

	if improvementKey ~= nil then
		v11.howToImprove = AnalyticsKeys.ANALYTICS_HOW_TO_IMPROVE
		v11.improvement = improvementKey
	end

	local v15 = useLocalization(v11)
	local function copy(p2)
		if v11[p2] == nil then
			return ""
		end

		return v15[p2]
	end

	local onClose = data.onClose
	local v16 = v11.analyzeName == nil and "" or v15.analyzeName

	local analyzePrompt = useLocalization({
		analyzePrompt = {
			AnalyticsKeys.ANALYTICS_ANALYZE_CHAT_PROMPT,
			analyzeName = v16,
			days = tostring(data.window.days)
		}
	}).analyzePrompt
	local onOpenChat = data.onOpenChat
	local v17 = React.useCallback(function()
		if onOpenChat ~= nil and v16 ~= "" then
			onOpenChat(analyzePrompt)
		end

		onClose()
	end, { onOpenChat, analyzePrompt, v16, onClose })

	local creatorHub = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
	}).creatorHub
	local overviewPath = v7.overviewPath
	local universeId = data.universeId

	local creatorHubRangeType = if FFlagBuildAnalyticsCreatorHubWindowFix then data.window.creatorHubRangeType else nil
	local v18 = React.useCallback(function()
		if overviewPath ~= nil then
			local creatorHubAnalyticsUrl = GameConfigurationActions.getCreatorHubAnalyticsUrl(
				universeId,
				overviewPath,
				creatorHubRangeType
			)

			if FFlagBuildAnalyticsGoals then
				openWebViewSession(creatorHubAnalyticsUrl, creatorHub)
			else
				v10(creatorHubAnalyticsUrl, creatorHub)
			end
		end

		onClose()
	end, { v10, overviewPath, universeId, creatorHubRangeType, creatorHub, onClose })
	return {
		focusRootRef = v5,
		showCloseButton = v6,
		metric = v7,
		universeId = data.universeId,
		window = data.window,
		latestAvailableTime = v8,
		navigation = v9,
		metadataStatus = data.metadataStatus,
		titleText = v11.title == nil and "" or v15.title,
		summaryText = v11.summary == nil and "" or v15.summary,
		descriptionText = v11.description == nil and "" or v15.description,
		improvementTitleText = v11.howToImprove == nil and "" or v15.howToImprove,
		improvementText = v11.improvement == nil and "" or v15.improvement,
		analyzeText = v11.analyze == nil and "" or v15.analyze,
		viewInOverviewText = v11.viewInOverview == nil and "" or v15.viewInOverview,
		onAnalyze = v17,
		isAnalyzeDisabled = FFlagBuildCheckGamePermissions and onOpenChat == nil,
		onViewInOverview = v18,
		onClose = data.onClose,
		testId = data.testId
	}
end

return useMetricDetailSheetViewModel
