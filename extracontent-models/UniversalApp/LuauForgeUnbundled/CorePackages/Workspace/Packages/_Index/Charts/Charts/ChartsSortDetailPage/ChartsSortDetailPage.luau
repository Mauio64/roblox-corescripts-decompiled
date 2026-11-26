require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/React")
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/RobloxAppEnums")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")
local compositionTags = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/AppComposition").CompositionTags

local appPage = RobloxAppEnums.AppPage
local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SharedFlags").FFlagAppThemeHalloween2026HomeBackground

local sduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local ChartsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsConstants")
local ChartsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsPageScopeFields")
local ChartsSortDetailConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/ChartsSortDetailConstants")
local ChartsSortDetailScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/ChartsSortDetailScopeFields")
local fetchChartsSortDetail = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/fetchChartsSortDetail")
local getChartsSortDetailPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/getChartsSortDetailPageKey")

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function ChartsSortDetailPage(props)
	local sortId = props.sortId or props.navigation and props.navigation.getParam("sortId")

	local v6 = getChartsSortDetailPageKey(sortId, nil, (React.useMemo(function()
		return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	end, {})))
	local pageTimer = props.pageTimer or props.navigation and props.navigation.getParam("pageTimer")

	usePageScopeRef(v6)
	React.useMemo(function()
		getSduiClientPageScope(v6).set(ChartsSortDetailScopeFields.SelectedSortId, sortId)
	end, { v6, sortId })

	local v7 = React.useMemo(function()
		local v8 = pageTimer or sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v6, {
			eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
			metadata = { page = "mount" }
		})

		getSduiClientPageScope(v6).set(sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v8)
		return v8
	end, { v6, pageTimer })

	React.useEffect(function()
		if sortId then
			fetchChartsSortDetail(sortId, v7)
		end
	end, { sortId, v7 })

	local v8 = React.useCallback(function()
		if sortId then
			local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
				v6,
				{
					eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
					metadata = { page = "refresh" }
				}
			)

			loadTimerWithSurfaceLoadTime.start("refresh")
			fetchChartsSortDetail(sortId, loadTimerWithSurfaceLoadTime)
		end
	end, { sortId, v6 })

	local v9 = React.useMemo(function()
		if props.pageContext then
			return { pageContext = props.pageContext }
		end

		return nil
	end, { props.pageContext })

	if sortId == nil then
		return nil
	end

	local createElement = React.createElement
	local v11 = {
		appPage = props.pageContext or appPage.Games,
		routeName = appPage.GamesList,
		configKey = v6,
		pageTimer = v7,
		includeNavigationHeaderBar = false,
		refresh = v8,
		contentTag = compositionTags.ContentRegion.Body,
		stickyContentTag = compositionTags.ContentRegion.Header,
		additionalAnalyticsData = v9,
		pageTopPadding = props.pageTopPadding,
		backgroundStyle = 0,
		feedBackgroundStyle = 0
	}
	local v12 = if fFlagAppThemeHalloween2026HomeBackground then props.backgroundStyle else nil
	v11.backgroundStyle = v12
	local v13 = if fFlagAppThemeHalloween2026HomeBackground then props.backgroundStyle else nil
	v11.feedBackgroundStyle = v13
	return createElement(sduiPageEntryPoint, v11)
end

return React.memo(ChartsSortDetailPage)
