local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")

require(script.Parent.telemetryNewConfig)
local fireTelemetry = require(SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry)

local defineFastFlag = game:DefineFastFlag("SocialLuaAnalyticsUseTelemetryServiceAsDefault", false)

local function telemetrySetup(data)
	local shouldUseTelemetryService

	if data.shouldUseTelemetryService == nil then
		shouldUseTelemetryService = defineFastFlag
	else
		shouldUseTelemetryService = data.shouldUseTelemetryService
	end

	local function emitTelemetry(p, p2)
		return fireTelemetry({
			telemetryImpl = data.telemetryImpl,
			eventList = { defaults = data.defaultTelemetryConfig, [p.name] = p },
			loggerImpl = data.loggerImpl,
			shouldUseTelemetryService = shouldUseTelemetryService,
			telemetryServiceImpl = data.telemetryServiceImpl
		})(p.name, p2, not data.getSharedInfo and {} or data.getSharedInfo(), p.eventStreamCtx)
	end

	return {
		emit = emitTelemetry,
		fireAnalyticsEvent = emitTelemetry,
		getSharedInfo = data.getSharedInfo
	}
end

return telemetrySetup
