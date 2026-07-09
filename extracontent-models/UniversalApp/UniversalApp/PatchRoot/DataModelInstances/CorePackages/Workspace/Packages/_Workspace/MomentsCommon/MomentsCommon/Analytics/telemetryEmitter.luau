local Parent = script:FindFirstAncestor("MomentsCommon").Parent
local LoggingProtocol = require(Parent.LoggingProtocol)

return require(Parent.SocialLuaAnalytics).Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	defaultTelemetryConfig = {
		throttlingThousandths = 10000,
		links = ""
	},
	getSharedInfo = function() -- line: 31
		return {}
	end
})
