local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol").default

local defineFastInt = game:DefineFastInt("AXPointsEventHundredthsPercent", 0)

local function generateEventConfig(p2)
	return {
		eventName = "AvatarExperience" .. p2,
		backends = { default.TelemetryBackends.Points },
		throttlingPercentage = defineFastInt
	}
end

return {
	sendTelemetryEvent = function(p2, p3)
		default:logRobloxTelemetryEvent({
			eventName = "AvatarExperience" .. p2,
			backends = { default.TelemetryBackends.Points },
			throttlingPercentage = defineFastInt
		}, nil, p3)
	end
}
