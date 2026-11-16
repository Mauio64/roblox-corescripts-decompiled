local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

require(parent.Navigation)
local React = require(parent.React)
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local AppComposition = require(parent.AppComposition)
local CompositionTags = AppComposition.CompositionTags

local AppPage = RobloxAppEnums.AppPage
local SharedFlags = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026HomeBackground = SharedFlags.FFlagAppThemeHalloween2026HomeBackground

local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsSortDetailConstants = require(Charts.ChartsSortDetailPage.ChartsSortDetailConstants)
local ChartsSortDetailScopeFields = require(Charts.ChartsSortDetailPage.ChartsSortDetailScopeFields)
local fetchChartsSortDetail = require(Charts.ChartsSortDetailPage.fetchChartsSortDetail)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)

local function getFromPropsOrNavigationParams(props, p: string) -- 2 equivalent calls inferred from this helper
	return props[p] or props.navigation and props.navigation.getParam(p)
end

local function ChartsSortDetailPage(props)
	local v = getFromPropsOrNavigationParams(props, "sortId") -- inferred equivalent call
	local chartsSortDetailPageKey = getChartsSortDetailPageKey(v, nil, (React.useMemo(function()
		return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	end, {})))
	local v2 = getFromPropsOrNavigationParams(props, "pageTimer") -- inferred equivalent call
	usePageScopeRef(chartsSortDetailPageKey)
	React.useMemo(function()
		getSduiClientPageScope(chartsSortDetailPageKey).set(ChartsSortDetailScopeFields.SelectedSortId, v)
	end, { chartsSortDetailPageKey, v })

	local pageTimer = React.useMemo(function()
		local selected = v2 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(chartsSortDetailPageKey, {
			eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
			metadata = { page = "mount" }
		})

		getSduiClientPageScope(chartsSortDetailPageKey).set(
			SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			selected
		)
		return selected
	end, { chartsSortDetailPageKey, v2 })

	React.useEffect(function()
		if v then
			fetchChartsSortDetail(v, pageTimer)
		end
	end, { v, pageTimer })

	local refresh = React.useCallback(function()
		if v then
			local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
				chartsSortDetailPageKey,
				{
					eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
					metadata = { page = "refresh" }
				}
			)

			loadTimerWithSurfaceLoadTime.start("refresh")
			fetchChartsSortDetail(v, loadTimerWithSurfaceLoadTime)
		end
	end, { v, chartsSortDetailPageKey })

	local additionalAnalyticsData = React.useMemo(function()
		if props.pageContext then
			return { pageContext = props.pageContext }
		end

		return nil
	end, { props.pageContext })

	if v == nil then
		return nil
	end

	local createElement = React.createElement
	local v3 = {
		appPage = props.pageContext or AppPage.Games,
		routeName = AppPage.GamesList,
		configKey = chartsSortDetailPageKey,
		pageTimer = pageTimer,
		includeNavigationHeaderBar = false,
		refresh = refresh,
		contentTag = CompositionTags.ContentRegion.Body,
		stickyContentTag = CompositionTags.ContentRegion.Header,
		additionalAnalyticsData = additionalAnalyticsData,
		pageTopPadding = props.pageTopPadding,
		backgroundStyle = 0,
		feedBackgroundStyle = 0
	}
	local backgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		backgroundStyle = props.backgroundStyle
	end

	v3.backgroundStyle = backgroundStyle
	local feedBackgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		feedBackgroundStyle = props.backgroundStyle
	end

	v3.feedBackgroundStyle = feedBackgroundStyle
	return createElement(SduiPageEntryPoint, v3)
end

return React.memo(ChartsSortDetailPage)
