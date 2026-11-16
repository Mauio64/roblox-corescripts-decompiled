local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local LoggingProtocol = require(parent.LoggingProtocol)
require(parent.Navigation)
local React = require(parent.React)
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sortDeeplinkFailureCounter = DiscoveryAnalytics.Events.sortDeeplinkFailureCounter

local buildHomeSortDetailPageEntry = require(Home.HomeSortDetailPage.buildHomeSortDetailPageEntry)
local fetchHomeSortDetail = require(Home.HomeSortDetailPage.fetchHomeSortDetail)
local getHomeSortDetailPageKey = require(Home.HomeSortDetailPage.getHomeSortDetailPageKey)
local HomeConstants = require(Home.HomeConstants)
local HomeSortDetailConstants = require(Home.HomeSortDetailPage.HomeSortDetailConstants)
local HomeSortDetailScopeFields = require(Home.HomeSortDetailPage.HomeSortDetailScopeFields)
local fetchHomePage = require(Home.fetchHomePage)
local refreshHomePage = require(Home.refreshHomePage)

local SduiPageWrapperEntryPoint = SduiSharedUtilities.SduiPageWrapperEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local UiStatus = SduiSharedUtilities.UiStatus
local useInputData = SduiSharedUtilities.useInputData
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local useUiStatus = SduiSharedUtilities.useUiStatus

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSduiHomeSortDetailPageContext = SharedFlags.FFlagLuaAppSduiHomeSortDetailPageContext
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAppThemeHalloween2026HomeBackground = SharedFlags2.FFlagAppThemeHalloween2026HomeBackground

local _ = { InvalidSort = "InvalidSort", SortTokenFetchFailed = "SortTokenFetchFailed" }

local function getFromPropsOrNavigationParams(props, p: string) -- 3 equivalent calls inferred from this helper
	return props[p] or props.navigation and props.navigation.getParam(p)
end

local function HomeSortDetailPage(props)
	local sortName = getFromPropsOrNavigationParams(props, "sortId") -- inferred equivalent call
	local v = getFromPropsOrNavigationParams(props, "sortIndex") -- inferred equivalent call
	local homeSortDetailPageKey = getHomeSortDetailPageKey(sortName, v)
	local v2 = getFromPropsOrNavigationParams(props, "pageTimer") -- inferred equivalent call
	local v3 = useInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
	local v4 = useUiStatus(HomeConstants.ConfigKey)
	local v5 = useUiStatus(homeSortDetailPageKey)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	usePageScopeRef(homeSortDetailPageKey)

	React.useMemo(function()
		local sduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope(homeSortDetailPageKey)
		sduiClientPageScope.set(HomeSortDetailScopeFields.SelectedSortId, sortName)
		sduiClientPageScope.set(HomeSortDetailScopeFields.SelectedSortIndex, v)
	end, { homeSortDetailPageKey, sortName, v })

	local pageTimer = React.useMemo(function()
		local selected = v2
			or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(HomeSortDetailConstants.SurfaceKey, {
				eventName = HomeSortDetailConstants.SurfaceLoadTimeEventName,
				metadata = { page = "mount" }
			})

		SduiSharedUtilities.getSduiClientPageScope(homeSortDetailPageKey).set(
			SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			selected
		)
		return selected
	end, { homeSortDetailPageKey, v2 })

	local v6 = React.useCallback(function(reason: string)
		if ref2.current then
			return
		end

		ref2.current = true
		LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
			reason = reason,
			sortName = sortName,
			isOmni = true
		})

		if props.onSortUnavailable then
			props.onSortUnavailable()
		end
	end, { props.onSortUnavailable, sortName })

	React.useEffect(function()
		fetchHomePage(SduiSharedUtilities.SduiLoadTimer.createLoadTimer(HomeConstants.ConfigKey))
	end, {})

	React.useEffect(function()
		if sortName == nil then
			v6("InvalidSort")
			return
		end

		if v4 == UiStatus.Error then
			v6("SortTokenFetchFailed")
			return
		end

		if v4 ~= UiStatus.Resolved or v3 == nil then
			return
		end

		if buildHomeSortDetailPageEntry(sortName, v) == nil then
			v6("InvalidSort")
		elseif ref.current ~= homeSortDetailPageKey then
			ref.current = homeSortDetailPageKey

			if fetchHomeSortDetail(sortName, v, pageTimer) == nil then
				v6("SortTokenFetchFailed")
			end
		end
	end, { homeSortDetailPageKey, v3, v4, pageTimer, v6, sortName, v })

	React.useEffect(function()
		if v5 == UiStatus.Error then
			v6("SortTokenFetchFailed")
			return
		end

		if v5 ~= UiStatus.Resolved or v4 ~= UiStatus.Resolved or v3 == nil or sortName == nil then
			return
		end

		local homeSortDetailPageEntry = buildHomeSortDetailPageEntry(sortName, v)
		local v7 = SduiSharedUtilities.getSduiApiStore().getRootConfig(homeSortDetailPageKey, false) ~= nil

		if homeSortDetailPageEntry == nil or not v7 then
			v6("InvalidSort")
		end
	end, { homeSortDetailPageKey, v5, v3, v4, v6, sortName, v })

	local refresh = React.useCallback(function()
		if sortName == nil then
			return nil
		end

		local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			HomeSortDetailConstants.SurfaceKey,
			{
				eventName = HomeSortDetailConstants.SurfaceLoadTimeEventName,
				metadata = { page = "refresh" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("refresh")

		local v7 = refreshHomePage()

		if v7 then
			return v7:finally(function()
				loadTimerWithSurfaceLoadTime.logRefreshComplete()
			end)
		end

		loadTimerWithSurfaceLoadTime.logRefreshComplete()
		return nil
	end, { sortName })

	if sortName == nil then
		return nil
	end

	local createElement = React.createElement
	local appPage

	if FFlagLuaAppSduiHomeSortDetailPageContext then
		appPage = props.pageContext or AppPage.Home
	else
		appPage = AppPage.Home
	end

	local v7 = {
		appPage = appPage,
		routeName = AppPage.GamesList,
		configKey = homeSortDetailPageKey,
		contentIdentifier = HomeSortDetailConstants.Identifier,
		pageTimer = pageTimer,
		refresh = refresh,
		additionalAnalyticsData = {
			pageContext = props.pageContext or AppPage.Home
		},
		pageTopPadding = props.pageTopPadding,
		backgroundStyle = 0
	}
	local backgroundStyle

	if FFlagAppThemeHalloween2026HomeBackground then
		backgroundStyle = props.backgroundStyle
	end

	v7.backgroundStyle = backgroundStyle
	return createElement(SduiPageWrapperEntryPoint, v7)
end

return React.memo(HomeSortDetailPage)
