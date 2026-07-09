local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent
local AppPage = require(ChartsParent.RobloxAppEnums).AppPage
local SduiSurfaceLoadTimeTracker = require(ChartsParent.SduiSharedUtilities).SduiSurfaceLoadTimeTracker
local fetchChartsPage = require(Charts.ChartsPage.fetchChartsPage)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)

local function navigateToChartsPage(p1) -- line: 10
	-- upvalues: SduiSurfaceLoadTimeTracker (copy), ChartsConstants (copy), fetchChartsPage (copy), AppPage (copy)
	local v9 = SduiSurfaceLoadTimeTracker.createLoadTimerWithSurfaceLoadTime(ChartsConstants.ConfigKey, {
		eventName = ChartsConstants.SurfaceLoadTimeEventName,
		metadata = {
			page = "navigate"
		}
	})

	v9.start("navigate")
	fetchChartsPage(v9)
	p1.navigate(AppPage.Games, {
		pageTimer = v9
	})
end

return navigateToChartsPage
