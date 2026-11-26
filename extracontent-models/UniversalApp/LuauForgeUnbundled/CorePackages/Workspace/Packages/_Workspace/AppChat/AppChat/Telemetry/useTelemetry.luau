local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local createTelemetryEmitter = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/createTelemetryEmitter")

local function useTelemetry(p2)
	return createTelemetryEmitter((React.useContext(p2)))
end

return useTelemetry
