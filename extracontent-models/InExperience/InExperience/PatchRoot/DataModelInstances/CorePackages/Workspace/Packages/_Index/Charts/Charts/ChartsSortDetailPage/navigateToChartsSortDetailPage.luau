local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsSortDetailConstants = require(Charts.ChartsSortDetailPage.ChartsSortDetailConstants)
local fetchChartsSortDetail = require(Charts.ChartsSortDetailPage.fetchChartsSortDetail)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)

local function navigateToChartsSortDetailPage(p, p2)
	local v = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	local chartsSortDetailPageKey = getChartsSortDetailPageKey(p2.sortId, nil, v)
	local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
		chartsSortDetailPageKey,
		{
			eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
			metadata = { page = "navigate" }
		}
	)

	loadTimerWithSurfaceLoadTime.start("navigate")

	fetchChartsSortDetail(p2.sortId, loadTimerWithSurfaceLoadTime)

	p.navigate(AppPage.GamesList, {
		detail = p2.sortId,
		extraProps = { pageContext = p2.pageContext, pageTimer = loadTimerWithSurfaceLoadTime }
	})
end

return navigateToChartsSortDetailPage
