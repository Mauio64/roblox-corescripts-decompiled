local SocialLuaAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SocialLuaAnalytics")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LoggingProtocol")

local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Logger")

return function(p2)
	return SocialLuaAnalytics.Telemetry.createEmitter({
		telemetryImpl = LoggingProtocol.default,
		loggerImpl = Logger,
		defaultTelemetryConfig = {
			throttlingThousandths = 10000,
			links = "example.com"
		},
		getSharedInfo = p2,
		shouldUseTelemetryService = true
	})
end
