local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiSurfaceLoadTimeTracker = SduiSharedUtilities.SduiSurfaceLoadTimeTracker
local fetchChartsPage = require(Charts.ChartsPage.fetchChartsPage)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)

local function navigateToChartsPage(p)
	local loadTimerWithSurfaceLoadTime = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(
		ChartsConstants.ConfigKey,
		{
			eventName = ChartsConstants.SurfaceLoadTimeEventName,
			metadata = { page = "navigate" }
		}
	)

	loadTimerWithSurfaceLoadTime.start("navigate")

	fetchChartsPage(loadTimerWithSurfaceLoadTime)

	p.navigate(AppPage.Games, { pageTimer = loadTimerWithSurfaceLoadTime })
end

return navigateToChartsPage
