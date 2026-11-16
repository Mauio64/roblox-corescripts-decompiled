local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/LoggingProtocol")
return require("@game/CorePackages/Workspace/Packages/_Workspace/AppChatNetworking/SocialLuaAnalytics").Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = game:DefineFastInt("AppChatNetworkingTelemetryThrottlingThousandths", 800),
		links = ""
	},
	getSharedInfo = function()
		return {}
	end
})
