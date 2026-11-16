local parent = script:FindFirstAncestor("AppChatNetworking").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
return SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = game:DefineFastInt("AppChatNetworkingTelemetryThrottlingThousandths", 800),
		links = ""
	},
	getSharedInfo = function()
		return {}
	end
})
