local Parent = script:FindFirstAncestor("AppChat").Parent
local SocialLuaAnalytics = require(Parent.SocialLuaAnalytics)
local LoggingProtocol = require(Parent.LoggingProtocol)
local Logger = require(script.Parent.Logger)
local v5 = game:DefineFastFlag("AppChatAnalyticsUseTelemetryService", false)

return function(p1: ((...any) -> ...any)) -- line: 10
	-- upvalues: SocialLuaAnalytics (copy), LoggingProtocol (copy), Logger (copy), v5 (copy)
	return SocialLuaAnalytics.Telemetry.createEmitter({
		telemetryImpl = LoggingProtocol.default,
		loggerImpl = Logger,
		defaultTelemetryConfig = {
			throttlingThousandths = 10000,
			links = "example.com"
		},
		getSharedInfo = p1,
		shouldUseTelemetryService = v5
	})
end
