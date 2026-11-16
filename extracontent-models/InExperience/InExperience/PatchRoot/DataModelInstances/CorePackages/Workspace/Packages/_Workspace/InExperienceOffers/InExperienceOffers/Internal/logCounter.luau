local parent = script:FindFirstAncestor("InExperienceOffers").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local function logCounter(p, value: number?, options)
	LoggingProtocol.default:logRobloxTelemetryCounter(p, value or 1, options or {})
end

return logCounter
