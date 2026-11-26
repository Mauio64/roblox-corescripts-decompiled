local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/LoggingProtocol")
require("@game/CorePackages/Workspace/Packages/_Index/AppLaunchTracker/AppLaunchTracker/AppLaunchTrackerTypes")

local defineFastInt = game:DefineFastInt("DiscoveryAppLaunchMilestonesHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("DiscoveryAppLaunchErrorHundredthsPercent", 0)

local v5 = {
	eventName = "DiscoveryAppLaunch_Milestones",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 11, 4 },
	description = "App launch rodux actions",
	links = ""
}

local v6 = {
	eventName = "DiscoveryAppLaunch_Error",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 24, 11, 4 },
	description = "Error related to discovery app launch metric tracking"
}

return {
	reportStatsforMilestone = function(object, milestone, p2, durationMs, items, numTilesInit, numTileRenders, numFeedItems, numFeedRenders, totalSduiDurationMs)
		assert(object, "LoggingProtocol must exist")

		if defineFastInt > 0 then
			local v7 = {}
			v7.milestone = milestone
			v7.milestoneSpan = `{p2}-{milestone}`
			v7.durationMs = durationMs
			v7.numTilesInit = numTilesInit
			v7.numTileRenders = numTileRenders
			v7.numFeedItems = numFeedItems
			v7.numFeedRenders = numFeedRenders
			v7.totalSduiDurationMs = totalSduiDurationMs

			for k, item in items do
				v7[k] = item
			end

			object:logRobloxTelemetryEvent(v5, { object.StandardizedFields.addOsInfo }, v7)
		end
	end,
	reportError = function(object, p2)
		object:logRobloxTelemetryCounter(v6, 1, { errorTag = p2 })
	end
}
