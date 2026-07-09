local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent

require(ChartsParent.Navigation)

local React = require(ChartsParent.React)
local RobloxAppEnums = require(ChartsParent.RobloxAppEnums)
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local CompositionTags = require(ChartsParent.AppComposition).CompositionTags
local AppPage = RobloxAppEnums.AppPage
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local usePageScopeRef = SduiSharedUtilities.usePageScopeRef
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsSortDetailConstants = require(Charts.ChartsSortDetailPage.ChartsSortDetailConstants)
local fetchChartsSortDetail = require(Charts.ChartsSortDetailPage.fetchChartsSortDetail)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 33
	return t1[s1] or t1.navigation and t1.navigation.getParam(s1)
end
local function ChartsSortDetailPage(t2: {[any]: any}) -- line: 37
	-- upvalues: React (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), getChartsSortDetailPageKey (copy), usePageScopeRef (copy), SduiSurfaceLoadTimeTracker (copy), ChartsSortDetailConstants (copy), fetchChartsSortDetail (copy), SduiPageEntryPoint (copy), AppPage (copy), CompositionTags (copy)
	local v22 = t2.sortId or t2.navigation and t2.navigation.getParam("sortId")
	local v23 = React.useMemo(function() -- line: 42
		-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
		return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	end, {})
	local v24 = getChartsSortDetailPageKey(v22, nil, v23)
	local v25 = t2.pageTimer or t2.navigation and t2.navigation.getParam("pageTimer")

	usePageScopeRef(v24)

	local v26 = React.useMemo(function() -- line: 49
		-- upvalues: v25 (copy), SduiSurfaceLoadTimeTracker (copy), v24 (copy), ChartsSortDetailConstants (copy), getSduiClientPageScope (copy)
		local v29 = v25 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v24, {
			eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
			metadata = {
				page = "mount"
			}
		})

		getSduiClientPageScope(v24).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v29)

		return v29
	end, {
		v24,
		v25
	})

	React.useEffect(function() -- line: 61
		-- upvalues: v22 (copy), fetchChartsSortDetail (copy), v26 (copy)
		if v22 then
			fetchChartsSortDetail(v22, v26)
		end
	end, {
		v22,
		v26
	})

	local v27 = React.useCallback(function() -- line: 67
		-- upvalues: v22 (copy), SduiSurfaceLoadTimeTracker (copy), v24 (copy), ChartsSortDetailConstants (copy), fetchChartsSortDetail (copy)
		if v22 then
			local v30 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v24, {
				eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
				metadata = {
					page = "refresh"
				}
			})

			v30.start("refresh")
			fetchChartsSortDetail(v22, v30)
		end
	end, {
		v22,
		v24
	})
	local v28 = React.useMemo(function() -- line: 80
		-- upvalues: t2 (copy)
		if t2.pageContext then
			return {
				pageContext = t2.pageContext
			}
		end

		return nil
	end, { t2.pageContext })

	if v22 == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		includeNavigationHeaderBar = false,
		appPage = t2.pageContext or AppPage.Games,
		routeName = AppPage.GamesList,
		configKey = v24,
		pageTimer = v26,
		refresh = v27,
		contentTag = CompositionTags.ContentRegion.Body,
		stickyContentTag = CompositionTags.ContentRegion.Header,
		additionalAnalyticsData = v28,
		pageTopPadding = t2.pageTopPadding
	})
end

return React.memo(ChartsSortDetailPage)
