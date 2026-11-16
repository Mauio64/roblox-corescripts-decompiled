local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/RobloxAppEnums").AppPage
local sduiSurfaceLoadTimeTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities").SduiSurfaceLoadTimeTracker
local fetchChartsPage = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/fetchChartsPage")
local ChartsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsConstants")

local function navigateToChartsPage(p2)
	local loadTimerWithSurfaceLoadTime = sduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
		ChartsConstants.ConfigKey,
		{
			eventName = ChartsConstants.SurfaceLoadTimeEventName,
			metadata = { page = "navigate" }
		}
	)

	loadTimerWithSurfaceLoadTime.start("navigate")

	fetchChartsPage(loadTimerWithSurfaceLoadTime)

	p2.navigate(appPage.Games, { pageTimer = loadTimerWithSurfaceLoadTime })
end

return navigateToChartsPage
