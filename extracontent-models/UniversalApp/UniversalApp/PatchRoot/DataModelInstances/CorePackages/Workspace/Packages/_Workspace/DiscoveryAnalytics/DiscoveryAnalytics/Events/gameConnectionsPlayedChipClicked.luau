local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("GameConnectionsPlayedChipClickedThrottleHundredthsPercent", 10000)
local v6 = t.strictInterface({
	universeId = t.string,
	placeId = t.string,
	uid = t.string,
	totalConnections = t.number
})

return function(p1, s1: string) -- line: 18
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), v5 (copy), TelemetryService (copy)
	local v9, v10 = v6(p1)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("GameConnectionsPlayedChipClickedInvalidInterface", v10)
	end

	local t1 = {
		eventName = "gameConnectionsPlayedChipClicked",
		description = "User has clicked the connections played chip to open the user list",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			26,
			2,
			10
		}
	}

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
