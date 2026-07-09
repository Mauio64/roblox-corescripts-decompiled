local Parent = script:FindFirstAncestor("InExperienceShop").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

local function logCounter(p1, n1: number?) -- line: 18
	-- upvalues: LoggingProtocol (copy)
	LoggingProtocol.default:logRobloxTelemetryCounter(p1, n1 or 1, {})
end

return logCounter
