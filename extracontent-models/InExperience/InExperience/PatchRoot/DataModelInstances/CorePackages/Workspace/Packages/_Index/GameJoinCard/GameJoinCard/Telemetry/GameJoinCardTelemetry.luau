local Parent = script:FindFirstAncestor("GameJoinCard").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)
local v3 = game:DefineFastInt("MobileGameJoinCardBannerLoadCounterThrottleHundredthsPercent", 10000)
local t1 = {
	eventName = "mobileGameJoinCardBannerLoad",
	description = "MobileGameJoinCard banner image resolution outcomes; status custom field is one of Success / NotFound / Fallback / Failed.",
	backends = { LoggingProtocol.TelemetryBackends.Counter },
	throttlingPercentage = v3,
	lastUpdated = {
		2026,
		5,
		14
	}
}
local t2 = {
	Success = true,
	NotFound = true,
	Fallback = true,
	Failed = true
}

return {
	logBannerLoadResult = function(s1: string) -- line: 44
		-- upvalues: t2 (copy), LoggingProtocol (copy), t1 (copy)
		if not t2[s1] then
			return
		end

		LoggingProtocol.default:logRobloxTelemetryCounter(t1, nil, {
			status = s1
		})
	end
}
