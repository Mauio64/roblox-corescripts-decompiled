require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Telemetry/telemetryNewConfig")
local fireTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/FireEvent/fireTelemetry")

local defineFastFlag = game:DefineFastFlag("SocialLuaAnalyticsUseTelemetryServiceAsDefault", false)

local function telemetrySetup(data)
	local v5

	if data.shouldUseTelemetryService == nil then
		v5 = defineFastFlag
	else
		v5 = data.shouldUseTelemetryService
	end

	local function emitTelemetry(p2, p3)
		return fireTelemetry({
			telemetryImpl = data.telemetryImpl,
			eventList = { defaults = data.defaultTelemetryConfig, [p2.name] = p2 },
			loggerImpl = data.loggerImpl,
			shouldUseTelemetryService = v5,
			telemetryServiceImpl = data.telemetryServiceImpl
		})(p2.name, p3, not data.getSharedInfo and {} or data.getSharedInfo(), p2.eventStreamCtx)
	end

	return {
		emit = emitTelemetry,
		fireAnalyticsEvent = emitTelemetry,
		getSharedInfo = data.getSharedInfo
	}
end

return telemetrySetup
