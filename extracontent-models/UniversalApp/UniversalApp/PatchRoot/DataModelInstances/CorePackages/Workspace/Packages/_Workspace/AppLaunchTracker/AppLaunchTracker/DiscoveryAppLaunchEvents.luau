local Parent = script:FindFirstAncestor("AppLaunchTracker").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

require(script.Parent.AppLaunchTrackerTypes)

local v3 = game:DefineFastInt("DiscoveryAppLaunchMilestonesHundredthsPercent", 0)
local v4 = game:DefineFastInt("DiscoveryAppLaunchErrorHundredthsPercent", 0)
local t1 = {
	eventName = "DiscoveryAppLaunch_Milestones",
	description = "App launch rodux actions",
	links = "",
	backends = {
		LoggingProtocol.TelemetryBackends.Points,
		LoggingProtocol.TelemetryBackends.EventIngest
	},
	throttlingPercentage = v3,
	lastUpdated = {
		24,
		11,
		4
	}
}
local t2 = {
	eventName = "DiscoveryAppLaunch_Error",
	description = "Error related to discovery app launch metric tracking",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = v4,
	lastUpdated = {
		24,
		11,
		4
	}
}

return {
	reportStatsforMilestone = function(p1, s1: string, s2: string, n1: number, p2, n2: number, n3: number, n4: number, n5: number, n6: number) -- line: 37
		-- upvalues: v3 (copy), t1 (copy)
		assert(p1, "LoggingProtocol must exist")

		if v3 > 0 then
			local t3 = {
				milestone = s1,
				milestoneSpan = `{ s2 }-{ s1 }`,
				durationMs = n1,
				numTilesInit = n2,
				numTileRenders = n3,
				numFeedItems = n4,
				numFeedRenders = n5,
				totalSduiDurationMs = n6
			}

			for v18, v19 in p2 do
				t3[v18] = v19
			end

			p1:logRobloxTelemetryEvent(t1, { p1.StandardizedFields.addOsInfo }, t3)
		end
	end,
	reportError = function(p3, s3: string) -- line: 72
		-- upvalues: t2 (copy)
		p3:logRobloxTelemetryCounter(t2, 1, {
			errorTag = s3
		})
	end
}
