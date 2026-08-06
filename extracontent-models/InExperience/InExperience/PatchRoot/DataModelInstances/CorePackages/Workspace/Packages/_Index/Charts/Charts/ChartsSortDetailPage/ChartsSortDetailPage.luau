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
local ChartsSortDetailScopeFields = require(Charts.ChartsSortDetailPage.ChartsSortDetailScopeFields)
local fetchChartsSortDetail = require(Charts.ChartsSortDetailPage.fetchChartsSortDetail)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)
local FFlagLuaAppSduiGameSortDropDown = require(ChartsParent.SharedFlags).FFlagLuaAppSduiGameSortDropDown

local function getFromPropsOrNavigationParams(t1: {[any]: any}, s1: string) -- line: 36
	return t1[s1] or t1.navigation and t1.navigation.getParam(s1)
end
local function ChartsSortDetailPage(t2: {[any]: any}) -- line: 40
	-- upvalues: React (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), getChartsSortDetailPageKey (copy), usePageScopeRef (copy), FFlagLuaAppSduiGameSortDropDown (copy), ChartsSortDetailScopeFields (copy), SduiSurfaceLoadTimeTracker (copy), ChartsSortDetailConstants (copy), fetchChartsSortDetail (copy), SduiPageEntryPoint (copy), AppPage (copy), CompositionTags (copy)
	local v24 = t2.sortId or t2.navigation and t2.navigation.getParam("sortId")
	local v25 = React.useMemo(function() -- line: 45
		-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
		return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	end, {})
	local v26 = getChartsSortDetailPageKey(v24, nil, v25)
	local v27 = t2.pageTimer or t2.navigation and t2.navigation.getParam("pageTimer")

	usePageScopeRef(v26)

	if FFlagLuaAppSduiGameSortDropDown then
		React.useMemo(function() -- line: 56
			-- upvalues: getSduiClientPageScope (copy), v26 (copy), ChartsSortDetailScopeFields (copy), v24 (copy)
			getSduiClientPageScope(v26).set(ChartsSortDetailScopeFields.SelectedSortId, v24)
		end, {
			v26,
			v24
		})
	end

	local v28 = React.useMemo(function() -- line: 61
		-- upvalues: v27 (copy), SduiSurfaceLoadTimeTracker (copy), v26 (copy), ChartsSortDetailConstants (copy), getSduiClientPageScope (copy)
		local v31 = v27 or SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v26, {
			eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
			metadata = {
				page = "mount"
			}
		})

		getSduiClientPageScope(v26).set(SduiSurfaceLoadTimeTracker.SURFACE_LOAD_TIME_PAGE_SCOPE_KEY, v31)

		return v31
	end, {
		v26,
		v27
	})

	React.useEffect(function() -- line: 73
		-- upvalues: v24 (copy), fetchChartsSortDetail (copy), v28 (copy)
		if v24 then
			fetchChartsSortDetail(v24, v28)
		end
	end, {
		v24,
		v28
	})

	local v29 = React.useCallback(function() -- line: 79
		-- upvalues: v24 (copy), SduiSurfaceLoadTimeTracker (copy), v26 (copy), ChartsSortDetailConstants (copy), fetchChartsSortDetail (copy)
		if v24 then
			local v32 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v26, {
				eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
				metadata = {
					page = "refresh"
				}
			})

			v32.start("refresh")
			fetchChartsSortDetail(v24, v32)
		end
	end, {
		v24,
		v26
	})
	local v30 = React.useMemo(function() -- line: 92
		-- upvalues: t2 (copy)
		if t2.pageContext then
			return {
				pageContext = t2.pageContext
			}
		end

		return nil
	end, { t2.pageContext })

	if v24 == nil then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		includeNavigationHeaderBar = false,
		appPage = t2.pageContext or AppPage.Games,
		routeName = AppPage.GamesList,
		configKey = v26,
		pageTimer = v28,
		refresh = v29,
		contentTag = CompositionTags.ContentRegion.Body,
		stickyContentTag = CompositionTags.ContentRegion.Header,
		additionalAnalyticsData = v30,
		pageTopPadding = t2.pageTopPadding
	})
end

return React.memo(ChartsSortDetailPage)
