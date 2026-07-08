local Parent = script:FindFirstAncestor("AppChatNetworking").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return require(Parent.SocialLuaAnalytics).Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		links = "",
		throttlingThousandths = game:DefineFastInt("AppChatNetworkingTelemetryThrottlingThousandths", 800)
	},
	getSharedInfo = function() -- line: 13
		return {}
	end
})
