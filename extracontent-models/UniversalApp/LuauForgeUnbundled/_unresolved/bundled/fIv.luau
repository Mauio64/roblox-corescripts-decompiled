local module = require("@luauforge/bundled/ecs")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")

local fireTelemetry = module.Analytics.FireEvent.fireTelemetry

require("@luauforge/bundled/fIu")
local module3 = require("@luauforge/bundled/fIw")

local v5 = fireTelemetry({ telemetryImpl = LoggingProtocol.default, eventList = module3 })

return function(p2, p3)
	if module3[p2] then
		v5(p2, p3)
	end
end
