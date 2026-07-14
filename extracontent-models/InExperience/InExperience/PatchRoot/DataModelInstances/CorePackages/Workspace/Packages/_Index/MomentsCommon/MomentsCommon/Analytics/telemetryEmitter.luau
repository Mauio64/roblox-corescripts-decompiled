local MomentsCommon = script:FindFirstAncestor("MomentsCommon")
local MomentsCommonParent = MomentsCommon.Parent
local LoggingProtocol = require(MomentsCommonParent.LoggingProtocol)
local SocialLuaAnalytics = require(MomentsCommonParent.SocialLuaAnalytics)
local GetFFlagMomentsAnalyticsProducerPrereqs = require(MomentsCommon.Flags.GetFFlagMomentsAnalyticsProducerPrereqs)

return SocialLuaAnalytics.Telemetry.createEmitter({
	telemetryImpl = LoggingProtocol.default,
	shouldUseTelemetryService = GetFFlagMomentsAnalyticsProducerPrereqs(),
	defaultTelemetryConfig = {
		throttlingThousandths = 10000,
		links = ""
	},
	getSharedInfo = function() -- line: 40
		return {}
	end
})
