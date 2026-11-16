local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryUtils").Parent

local Cryo = require(parent.Cryo)

local defineFastFlag = game:DefineFastFlag("UpdateDiscoveryEventErrorDetailsLogging", false)

local v = {
	eventName = "DiscoveryEventErrorLogger_ErrorDetails",
	description = "Error messages related to discovery events",
	lastUpdated = { 25, 10, 14 },
	backends = { "Points", defineFastFlag and "EventIngest" or nil },
	links = "https://roblox.atlassian.net/browse/CLIGROW-2890",
	throttlingPercentage = game:DefineFastInt("DiscoveryEventErrorDetailsHundredthsPercent", 0)
}

local v2 = {
	eventName = "DiscoveryEventErrorLogger_ErrorCounter",
	description = "Counter related to discovery event errors",
	lastUpdated = { 25, 10, 14 },
	backends = { "RobloxTelemetryCounter" },
	links = "https://roblox.atlassian.net/browse/CLIGROW-2890"
}

return {
	reportError = function(errorType: string, errorMessage: string, options)
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(`[DiscoveryEventErrorLogger]\nError Type: {errorType}\nError Message: {errorMessage}`)
		end

		TelemetryService:LogCounter(v2, {
			customFields = { errorType = errorType }
		}, 1)

		TelemetryService:LogEvent(v, {
			standardizedFields = defineFastFlag and { "addSessionInfo" } or nil,
			customFields = Cryo.Dictionary.join(options or {}, {
				errorType = errorType,
				errorMessage = errorMessage
			})
		})
	end
}
