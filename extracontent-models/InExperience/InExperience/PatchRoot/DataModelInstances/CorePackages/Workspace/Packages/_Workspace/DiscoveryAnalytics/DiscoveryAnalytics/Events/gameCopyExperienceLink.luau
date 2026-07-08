local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("GameCopyExperienceLinkThrottleHundrethsPercent", 10000)
local v6 = t.strictInterface({
	placeId = t.string,
	uid = t.string,
	ctx = t.string,
	stamp = t.optional(t.string)
})

return function(p1, s1: string) -- line: 18
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), v5 (copy), TelemetryService (copy)
	local v9, v10 = v6(p1)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("GameCopyExperienceLinkInvalidInterface", v10)
	end

	local t1 = {
		eventName = "copyExperienceLink",
		description = "User has copied an experience link",
		backends = { "EventIngest" },
		throttlingPercentage = v5,
		lastUpdated = {
			25,
			11,
			11
		}
	}

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
