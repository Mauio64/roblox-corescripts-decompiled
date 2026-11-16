local TelemetryService = game:GetService("TelemetryService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryUtils/Cryo")

local defineFastFlag = game:DefineFastFlag("UpdateDiscoveryEventErrorDetailsLogging", false)

local v5 = {
	eventName = "DiscoveryEventErrorLogger_ErrorDetails",
	description = "Error messages related to discovery events",
	lastUpdated = { 25, 10, 14 },
	backends = { "Points", defineFastFlag and "EventIngest" or nil },
	links = "https://roblox.atlassian.net/browse/CLIGROW-2890",
	throttlingPercentage = game:DefineFastInt("DiscoveryEventErrorDetailsHundredthsPercent", 0)
}

local v6 = {
	eventName = "DiscoveryEventErrorLogger_ErrorCounter",
	description = "Counter related to discovery event errors",
	lastUpdated = { 25, 10, 14 },
	backends = { "RobloxTelemetryCounter" },
	links = "https://roblox.atlassian.net/browse/CLIGROW-2890"
}

return {
	reportError = function(p2, p3, options)
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(`[DiscoveryEventErrorLogger]\nError Type: {p2}\nError Message: {p3}`)
		end

		TelemetryService:LogCounter(v6, {
			customFields = { errorType = p2 }
		}, 1)

		TelemetryService:LogEvent(v5, {
			standardizedFields = defineFastFlag and { "addSessionInfo" } or nil,
			customFields = Cryo.Dictionary.join(options or {}, {
				errorType = p2,
				errorMessage = p3
			})
		})
	end
}
