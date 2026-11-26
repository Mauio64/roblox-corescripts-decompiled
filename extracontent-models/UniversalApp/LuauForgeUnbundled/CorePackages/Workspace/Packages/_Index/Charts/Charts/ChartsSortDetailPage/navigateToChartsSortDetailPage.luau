local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")
local sduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local ChartsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsConstants")
local ChartsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsPageScopeFields")
local ChartsSortDetailConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/ChartsSortDetailConstants")
local fetchChartsSortDetail = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/fetchChartsSortDetail")
local getChartsSortDetailPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/getChartsSortDetailPageKey")

local function navigateToChartsSortDetailPage(p2, p3)
	local v5 = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	local v6 = getChartsSortDetailPageKey(p3.sortId, nil, v5)
	local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(v6, {
		eventName = ChartsSortDetailConstants.SurfaceLoadTimeEventName,
		metadata = { page = "navigate" }
	})

	loadTimerWithSurfaceLoadTime.start("navigate")

	fetchChartsSortDetail(p3.sortId, loadTimerWithSurfaceLoadTime)

	p2.navigate(appPage.GamesList, {
		detail = p3.sortId,
		extraProps = {
			pageContext = p3.pageContext,
			pageTimer = loadTimerWithSurfaceLoadTime
		}
	})
end

return navigateToChartsSortDetailPage
