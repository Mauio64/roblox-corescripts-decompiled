local SocialLuaAnalytics = script:FindFirstAncestor("SocialLuaAnalytics")

require(script.Parent.telemetryNewConfig)

local fireTelemetry = require(SocialLuaAnalytics.Analytics.FireEvent.fireTelemetry)
local v3 = game:DefineFastFlag("SocialLuaAnalyticsUseTelemetryServiceAsDefault", false)

local function telemetrySetup(t1: {[any]: any}) -- line: 34
	-- upvalues: v3 (copy), fireTelemetry (copy)
	local v6 = if t1.shouldUseTelemetryService == nil then v3 else t1.shouldUseTelemetryService

	local function emitTelemetry(p1, p2) -- line: 39
		-- upvalues: fireTelemetry (copy), t1 (copy), v6 (copy)
		return fireTelemetry({
			telemetryImpl = t1.telemetryImpl,
			eventList = {
				defaults = t1.defaultTelemetryConfig,
				[p1.name] = p1
			},
			loggerImpl = t1.loggerImpl,
			shouldUseTelemetryService = v6,
			telemetryServiceImpl = t1.telemetryServiceImpl
		})(p1.name, p2, if not t1.getSharedInfo then {} else t1.getSharedInfo(), p1.eventStreamCtx)
	end

	return {
		emit = emitTelemetry,
		fireAnalyticsEvent = emitTelemetry,
		getSharedInfo = t1.getSharedInfo
	}
end

return telemetrySetup
