local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

local React = require(parent.React)
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local Responsive = require(parent.Responsive)
local WebViewUtils = require(parent.WebViewUtils)
local useOpenWebView = WebViewUtils.useOpenWebView
local openWebViewSession = WebViewUtils.openWebViewSession
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local FFlagBuildAnalyticsCreatorHubWindowFix = require(BuildExperience.Flags.FFlagBuildAnalyticsCreatorHubWindowFix)
local FFlagBuildAnalyticsGoals = require(BuildExperience.Flags.FFlagBuildAnalyticsGoals)
local FFlagBuildCheckGamePermissions = require(BuildExperience.Flags.FFlagBuildCheckGamePermissions)

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
local AnalyticsKeys = require(BuildExperience.Analytics.AnalyticsKeys)
local AnalyticsMetric = require(BuildExperience.Analytics.AnalyticsMetric)
require(BuildExperience.Analytics.AnalyticsWindow)
require(parent.DataHydration.CreatorAnalytics)
local GameConfigurationActions = require(BuildExperience.utils.GameConfigurationActions)
require(script.Parent.MetricDetailSheetView)
local useClosableFocusRoot = require(BuildExperience.utils.useClosableFocusRoot)

local function useMetricDetailSheetViewModel(data)
	local focusRootRef, showCloseButton

	if FFlagBuildAnalyticsGoals then
		focusRootRef = useClosableFocusRoot({
			surfaceIdentifier = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum.PopUp,
			isOpen = true,
			onClose = data.onClose
		})

		if Responsive.usePreferredInput() == Responsive.Input.Directional then
			showCloseButton = false
		else
			showCloseButton = true
		end
	else
		showCloseButton = true
	end

	local metric

	if data.metricId == nil then
		metric = AnalyticsMetric.DailyActiveUsers
	else
		metric = AnalyticsMetric.MetricById[data.metricId] or AnalyticsMetric.DailyActiveUsers
	end

	local latestAvailableTime = data.latestAvailableTime
	local navigation = nil

	if FFlagBuildAnalyticsGoals then
		local state, setState = React.useState(1)
		local metrics = data.metrics
		local count = metrics == nil and 0 or #metrics
		local v = math.clamp(state, 1, (math.max(1, count)))
		React.useEffect(function()
			setState(1)
		end, { metrics })

		if metrics ~= nil and count > 0 then
			metric = metrics[v]

			if data.latestByMetric == nil then
				latestAvailableTime = nil
			else
				latestAvailableTime = data.latestByMetric[metric.id]
			end
		end

		if count > 1 then
			navigation = {
				index = v,
				count = count,
				onPrevious = function()
					setState((math.max(1, v - 1)))
				end,
				onNext = function()
					setState((math.min(count, v + 1)))
				end
			}
		end
	end

	local v = useOpenWebView()

	local v2 = {
		analyze = 0,
		viewInOverview = 0,
		title = 0,
		summary = 0,
		description = 0,
		analyzeName = 0
	}
	local analyze

	if FFlagBuildAnalyticsGoals then
		analyze = AnalyticsKeys.ANALYTICS_SHEET_ASK_ABOUT_THIS
	else
		analyze = AnalyticsKeys.ANALYTICS_SHEET_ANALYZE
	end

	v2.analyze = analyze
	local viewInOverview

	if FFlagBuildAnalyticsGoals then
		viewInOverview = AnalyticsKeys.ANALYTICS_SHEET_VIEW_MORE_STATS
	else
		viewInOverview = AnalyticsKeys.ANALYTICS_SHEET_VIEW_IN_OVERVIEW
	end

	v2.viewInOverview = viewInOverview
	local title

	if FFlagBuildAnalyticsGoals then
		title = data.titleKey or metric.titleKey
	else
		title = metric.titleKey
	end

	v2.title = title
	v2.summary = metric.summaryKey
	v2.description = metric.descriptionKey
	v2.analyzeName = metric.analyzeNameKey
	local improvementKey

	if FFlagBuildAnalyticsGoals then
		improvementKey = metric.improvementKey
	end

	if improvementKey ~= nil then
		v2.howToImprove = AnalyticsKeys.ANALYTICS_HOW_TO_IMPROVE
		v2.improvement = improvementKey
	end

	local v3 = useLocalization(v2)
	local function copy(p: string) -- 8 equivalent calls inferred from this helper
		if v2[p] == nil then
			return ""
		end

		return v3[p]
	end

	local onClose = data.onClose
	local analyzeName = copy("analyzeName") -- inferred equivalent call
	local analyzePrompt = useLocalization({
		analyzePrompt = {
			AnalyticsKeys.ANALYTICS_ANALYZE_CHAT_PROMPT,
			analyzeName = analyzeName,
			days = tostring(data.window.days)
		}
	}).analyzePrompt
	local onOpenChat = data.onOpenChat
	local onAnalyze = React.useCallback(function()
		if onOpenChat ~= nil and analyzeName ~= "" then
			onOpenChat(analyzePrompt)
		end

		onClose()
	end, { onOpenChat, analyzePrompt, analyzeName, onClose })

	local creatorHub = useLocalization({
		creatorHub = LocalizationStrings.GAME_CONFIGURATION_CREATOR_HUB
	}).creatorHub
	local overviewPath = metric.overviewPath
	local universeId = data.universeId
	local creatorHubRangeType

	if FFlagBuildAnalyticsCreatorHubWindowFix then
		creatorHubRangeType = data.window.creatorHubRangeType
	else
		creatorHubRangeType = nil
	end

	local onViewInOverview = React.useCallback(function()
		if overviewPath ~= nil then
			local creatorHubAnalyticsUrl = GameConfigurationActions.getCreatorHubAnalyticsUrl(
				universeId,
				overviewPath,
				creatorHubRangeType
			)

			if FFlagBuildAnalyticsGoals then
				openWebViewSession(creatorHubAnalyticsUrl, creatorHub)
			else
				v(creatorHubAnalyticsUrl, creatorHub)
			end
		end

		onClose()
	end, { v, overviewPath, universeId, creatorHubRangeType, creatorHub, onClose })

	return {
		focusRootRef = focusRootRef,
		showCloseButton = showCloseButton,
		metric = metric,
		universeId = data.universeId,
		window = data.window,
		latestAvailableTime = latestAvailableTime,
		navigation = navigation,
		metadataStatus = data.metadataStatus,
		titleText = copy("title"), -- inferred equivalent call
		summaryText = copy("summary"), -- inferred equivalent call
		descriptionText = copy("description"), -- inferred equivalent call
		improvementTitleText = copy("howToImprove"), -- inferred equivalent call
		improvementText = copy("improvement"), -- inferred equivalent call
		analyzeText = copy("analyze"), -- inferred equivalent call
		viewInOverviewText = copy("viewInOverview"), -- inferred equivalent call
		onAnalyze = onAnalyze,
		isAnalyzeDisabled = FFlagBuildCheckGamePermissions and onOpenChat == nil,
		onViewInOverview = onViewInOverview,
		onClose = data.onClose,
		testId = data.testId
	}
end

return useMetricDetailSheetViewModel
