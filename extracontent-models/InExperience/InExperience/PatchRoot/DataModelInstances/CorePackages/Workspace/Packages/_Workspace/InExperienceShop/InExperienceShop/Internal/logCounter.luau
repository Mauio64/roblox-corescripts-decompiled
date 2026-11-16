local parent = script:FindFirstAncestor("InExperienceShop").Parent

local LoggingProtocol = require(parent.LoggingProtocol)

local function logCounter(p, value: number?)
	LoggingProtocol.default:logRobloxTelemetryCounter(p, value or 1, {})
end

return logCounter
