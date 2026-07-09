local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local getSduiTelemetryHandlerNameRegistry = require(SduiCoreSystem.getSduiTelemetryHandlerNameRegistry)
local reportUnifiedLoggingAction = require(SduiCoreSystem.Analytics.reportUnifiedLoggingAction)

local function logActionTelemetry(s1: string?, p1, p2, p3, p4) -- line: 16
	-- upvalues: getSduiTelemetryHandlerNameRegistry (copy), SduiLogger (copy), SduiErrors (copy), reportUnifiedLoggingAction (copy)
	if s1 and s1 ~= "" then
		local v12 = getSduiTelemetryHandlerNameRegistry().getTelemetryHandler(s1)

		if v12 then
			v12(p2, p3, p4)
		else
			SduiLogger.reportError(SduiErrors.SduiErrorType.InvalidActionParams, {
				message = `Unknown telemetry handler name: { s1 }`,
				name = p2.actionType
			}, p4.appPage)
		end
	elseif p1.telemetryHandler then
		p1.telemetryHandler(p2, p3, p4)
	end

	if not p1.skipUnifiedLogging then
		if p3 == nil then
			SduiLogger.reportError(SduiErrors.SduiErrorType.NilAnalyticsContext, {
				message = `Could not reportUnifiedLoggingAction. Missing analyticsContext { p2.actionType }`,
				name = p2.actionType
			}, p4.appPage)

			return
		end

		reportUnifiedLoggingAction(p4, p2, p3)
	end
end

return logActionTelemetry
