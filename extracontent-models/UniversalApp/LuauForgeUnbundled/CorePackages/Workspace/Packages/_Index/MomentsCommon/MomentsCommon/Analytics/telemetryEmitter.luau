local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Index/MomentsCommon/LoggingProtocol")
return require("@game/CorePackages/Workspace/Packages/_Workspace/MomentsCommon/SocialLuaAnalytics").Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	shouldUseTelemetryService = false,
	defaultTelemetryConfig = { throttlingThousandths = 10000, links = "" },
	getSharedInfo = function()
		return {}
	end
})
