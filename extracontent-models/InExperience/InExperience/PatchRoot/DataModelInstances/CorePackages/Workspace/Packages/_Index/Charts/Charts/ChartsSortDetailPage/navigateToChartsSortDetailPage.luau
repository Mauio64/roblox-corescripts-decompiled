local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent
local AppPage = require(ChartsParent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsSortDetailConstants = require(Charts.ChartsSortDetailPage.ChartsSortDetailConstants)
local fetchChartsSortDetail = require(Charts.ChartsSortDetailPage.fetchChartsSortDetail)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)

local function navigateToChartsSortDetailPage(p1, t1: {[any]: any}) -- line: 14
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), getChartsSortDetailPageKey (copy), SduiSurfaceLoadTimeTracker (copy), ChartsSortDetailConstants (copy), fetchChartsSortDetail (copy), AppPage (copy)
	local v15 = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	local v16 = getChartsSortDetailPageKey(t1.sortId, nil, v15)
	local v17 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v16, {
		eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
		metadata = {
			page = "navigate"
		}
	})

	v17.start("navigate")
	fetchChartsSortDetail(t1.sortId, v17)
	p1.navigate(AppPage.GamesList, {
		detail = t1.sortId,
		extraProps = {
			pageContext = t1.pageContext,
			pageTimer = v17
		}
	})
end

return navigateToChartsSortDetailPage
