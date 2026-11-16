local parent = script:FindFirstAncestor("MomentsCommon").Parent

local LoggingProtocol = require(parent.LoggingProtocol)
local SocialLuaAnalytics = require(parent.SocialLuaAnalytics)

return SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	shouldUseTelemetryService = true,
	defaultTelemetryConfig = { throttlingThousandths = 10000, links = "" },
	getSharedInfo = function()
		return {}
	end
})
