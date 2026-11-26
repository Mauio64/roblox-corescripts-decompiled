local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/InExperienceShop/LoggingProtocol")

local function logCounter(p2, value, options)
	LoggingProtocol.default:logRobloxTelemetryCounter(p2, value or 1, options or {})
end

return logCounter
