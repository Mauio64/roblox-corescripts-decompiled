local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryUtils").Parent
local Cryo = require(Parent.Cryo)
local v4 = game:DefineFastFlag("UpdateDiscoveryEventErrorDetailsLogging", false)
local v5 = game:DefineFastInt("DiscoveryEventErrorDetailsHundredthsPercent", 0)
local t1 = {
	eventName = "DiscoveryEventErrorLogger_ErrorDetails",
	description = "Error messages related to discovery events",
	links = "https://roblox.atlassian.net/browse/CLIGROW-2890",
	lastUpdated = {
		25,
		10,
		14
	},
	backends = {
		"Points",
		if not v4 then nil else "EventIngest"
	},
	throttlingPercentage = v5
}
local t2 = {
	eventName = "DiscoveryEventErrorLogger_ErrorCounter",
	description = "Counter related to discovery event errors",
	links = "https://roblox.atlassian.net/browse/CLIGROW-2890",
	lastUpdated = {
		25,
		10,
		14
	},
	backends = { "RobloxTelemetryCounter" }
}

return {
	reportError = function(s1: string, s2: string, t3: {[any]: any}?) -- line: 33
		-- upvalues: TelemetryService (copy), t2 (copy), t1 (copy), v4 (copy), Cryo (copy)
		if not _G.__TESTEZ_RUNNING_TEST__ then
			warn(`[DiscoveryEventErrorLogger]\nError Type: { s1 }\nError Message: { s2 }`)
		end

		TelemetryService:LogCounter(t2, {
			customFields = {
				errorType = s1
			}
		}, 1)
		TelemetryService:LogEvent(t1, {
			standardizedFields = if not v4 then nil else { "addSessionInfo" },
			customFields = Cryo.Dictionary.join(t3 or {}, {
				errorType = s1,
				errorMessage = s2
			})
		})
	end
}
