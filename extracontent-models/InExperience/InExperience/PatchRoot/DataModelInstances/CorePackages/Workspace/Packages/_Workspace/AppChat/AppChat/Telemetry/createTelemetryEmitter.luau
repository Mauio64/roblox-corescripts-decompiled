local parent = script:FindFirstAncestor("AppChat").Parent
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)
local LoggingProtocol = require(parent.LoggingProtocol)

local Logger = require(script.Parent.Logger)

return function(getSharedInfo)
	return SocialLuaAnalytics.Telemetry.createEmitter({
		telemetryImpl = LoggingProtocol.default,
		loggerImpl = Logger,
		defaultTelemetryConfig = { throttlingThousandths = 10000, links = "example.com" },
		getSharedInfo = getSharedInfo,
		shouldUseTelemetryService = true
	})
end
