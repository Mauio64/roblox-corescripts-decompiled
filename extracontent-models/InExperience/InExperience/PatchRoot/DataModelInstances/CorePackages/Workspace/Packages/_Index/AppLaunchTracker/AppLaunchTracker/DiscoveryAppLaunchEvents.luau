local parent = script:FindFirstAncestor("AppLaunchTracker").Parent
local LoggingProtocol = require(parent.LoggingProtocol)
require(script.Parent.AppLaunchTrackerTypes)

local defineFastInt = game:DefineFastInt("DiscoveryAppLaunchMilestonesHundredthsPercent", 0)
local defineFastInt2 = game:DefineFastInt("DiscoveryAppLaunchErrorHundredthsPercent", 0)

local v = {
	eventName = "DiscoveryAppLaunch_Milestones",
	backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 24, 11, 4 },
	description = "App launch rodux actions",
	links = ""
}

local v2 = {
	eventName = "DiscoveryAppLaunch_Error",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = defineFastInt2,
	lastUpdated = { 24, 11, 4 },
	description = "Error related to discovery app launch metric tracking"
}
local DiscoveryAppLaunchEvents = {}

function DiscoveryAppLaunchEvents.reportStatsforMilestone(object, milestone: string, p: string, durationMs: number, items, numTilesInit: number, numTileRenders: number, numFeedItems: number, numFeedRenders: number, totalSduiDurationMs: number)
	assert(object, "LoggingProtocol must exist")

	if defineFastInt > 0 then
		local v3 = {}
		v3.milestone = milestone
		v3.milestoneSpan = `{p}-{milestone}`
		v3.durationMs = durationMs
		v3.numTilesInit = numTilesInit
		v3.numTileRenders = numTileRenders
		v3.numFeedItems = numFeedItems
		v3.numFeedRenders = numFeedRenders
		v3.totalSduiDurationMs = totalSduiDurationMs

		for k, item in items do
			v3[k] = item
		end

		object:logRobloxTelemetryEvent(v, { object.StandardizedFields.addOsInfo }, v3)
	end
end

function DiscoveryAppLaunchEvents.reportError(object, errorTag: string)
	object:logRobloxTelemetryCounter(v2, 1, { errorTag = errorTag })
end

return DiscoveryAppLaunchEvents
