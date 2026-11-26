local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/Home/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Navigation")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/React")
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")
local sortDeeplinkFailureCounter = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/DiscoveryAnalytics").Events.sortDeeplinkFailureCounter

local buildHomeSortDetailPageEntry = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/buildHomeSortDetailPageEntry")
local fetchHomeSortDetail = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/fetchHomeSortDetail")
local getHomeSortDetailPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/getHomeSortDetailPageKey")
local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")
local HomeSortDetailConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/HomeSortDetailConstants")
local HomeSortDetailScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeSortDetailPage/HomeSortDetailScopeFields")
local fetchHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/fetchHomePage")
local refreshHomePage = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/refreshHomePage")

local sduiPageWrapperEntryPoint = SduiSharedUtilities.SduiPageWrapperEntryPoint
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local uiStatus = SduiSharedUtilities.UiStatus
local useInputData = SduiSharedUtilities.useInputData
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local useUiStatus = SduiSharedUtilities.useUiStatus

local fFlagLuaAppSduiHomeSortDetailPageContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagLuaAppSduiHomeSortDetailPageContext
local fFlagAppThemeHalloween2026HomeBackground = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags").FFlagAppThemeHalloween2026HomeBackground

local v5 = {
	InvalidSort = "InvalidSort",
	SortTokenFetchFailed = "SortTokenFetchFailed"
}

local function getFromPropsOrNavigationParams(p2, p3)
	return p2[p3] or p2.navigation and p2.navigation.getParam(p3)
end

local function HomeSortDetailPage(props)
	local sortId = props.sortId or props.navigation and props.navigation.getParam("sortId")
	local sortIndex = props.sortIndex or props.navigation and props.navigation.getParam("sortIndex")

	local v6 = getHomeSortDetailPageKey(sortId, sortIndex)
	local pageTimer = props.pageTimer or props.navigation and props.navigation.getParam("pageTimer")

	local v7 = useInputData(HomeConstants.ConfigKey, HomeConstants.ContentIdentifier)
	local v8 = useUiStatus(HomeConstants.ConfigKey)
	local v9 = useUiStatus(v6)
	local ref = React.useRef(nil)
	local ref2 = React.useRef(false)

	usePageScopeRef(v6)

	React.useMemo(function()
		local sduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope(v6)
		sduiClientPageScope.set(HomeSortDetailScopeFields.SelectedSortId, sortId)
		sduiClientPageScope.set(HomeSortDetailScopeFields.SelectedSortIndex, sortIndex)
	end, { v6, sortId, sortIndex })

	local v10 = React.useMemo(function()
		local v11 = pageTimer
			or sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(HomeSortDetailConstants.SurfaceKey, {
				eventName = HomeSortDetailConstants.SurfaceLoadTimeEventName,
				metadata = { page = "mount" }
			})

		SduiSharedUtilities.getSduiClientPageScope(v6).set(
			sduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY,
			v11
		)
		return v11
	end, { v6, pageTimer })

	local v11 = React.useCallback(function(p2)
		if ref2.current then
			return
		end

		ref2.current = true
		LoggingProtocol.default:logRobloxTelemetryCounter(sortDeeplinkFailureCounter, 1, {
			reason = p2,
			sortName = sortId,
			isOmni = true
		})

		if props.onSortUnavailable then
			props.onSortUnavailable()
		end
	end, { props.onSortUnavailable, sortId })

	React.useEffect(function()
		fetchHomePage(SduiSharedUtilities.SduiLoadTimer.createLoadTimer(HomeConstants.ConfigKey))
	end, {})

	React.useEffect(function()
		if sortId == nil then
			v11("InvalidSort")
			return
		end

		if v8 == uiStatus.Error then
			v11("SortTokenFetchFailed")
			return
		end

		if v8 ~= uiStatus.Resolved or v7 == nil then
			return
		end

		if buildHomeSortDetailPageEntry(sortId, sortIndex) == nil then
			v11("InvalidSort")
		elseif ref.current ~= v6 then
			ref.current = v6

			if fetchHomeSortDetail(sortId, sortIndex, v10) == nil then
				v11("SortTokenFetchFailed")
			end
		end
	end, { v6, v7, v8, v10, v11, sortId, sortIndex })

	React.useEffect(function()
		if v9 == uiStatus.Error then
			v11("SortTokenFetchFailed")
			return
		end

		if v9 ~= uiStatus.Resolved or v8 ~= uiStatus.Resolved or v7 == nil or sortId == nil then
			return
		end

		local v12 = buildHomeSortDetailPageEntry(sortId, sortIndex)
		local v13 = SduiSharedUtilities.getSduiApiStore().getRootConfig(v6, false) ~= nil

		if v12 == nil or not v13 then
			v11("InvalidSort")
		end
	end, { v6, v9, v7, v8, v11, sortId, sortIndex })

	local v12 = React.useCallback(function()
		if sortId == nil then
			return nil
		end

		local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
			HomeSortDetailConstants.SurfaceKey,
			{
				eventName = HomeSortDetailConstants.SurfaceLoadTimeEventName,
				metadata = { page = "refresh" }
			}
		)

		loadTimerWithSurfaceLoadTime.start("refresh")

		local v13 = refreshHomePage()

		if v13 then
			return v13:finally(function()
				loadTimerWithSurfaceLoadTime.logRefreshComplete()
			end)
		end

		loadTimerWithSurfaceLoadTime.logRefreshComplete()
		return nil
	end, { sortId })

	if sortId == nil then
		return nil
	end

	local createElement = React.createElement

	local v15 = if fFlagLuaAppSduiHomeSortDetailPageContext then props.pageContext or appPage.Home else appPage.Home
	local v14 = {
		appPage = v15,
		routeName = appPage.GamesList,
		configKey = v6,
		contentIdentifier = HomeSortDetailConstants.Identifier,
		pageTimer = v10,
		refresh = v12,
		additionalAnalyticsData = {
			pageContext = props.pageContext or appPage.Home
		},
		pageTopPadding = props.pageTopPadding,
		backgroundStyle = 0
	}
	local v16 = if fFlagAppThemeHalloween2026HomeBackground then props.backgroundStyle else nil
	v14.backgroundStyle = v16
	return createElement(sduiPageWrapperEntryPoint, v14)
end

return React.memo(HomeSortDetailPage)
