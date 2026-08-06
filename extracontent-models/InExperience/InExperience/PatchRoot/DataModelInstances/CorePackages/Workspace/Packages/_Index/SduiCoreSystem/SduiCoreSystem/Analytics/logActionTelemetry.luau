local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local getSduiTelemetryHandlerNameRegistry = require(SduiCoreSystem.getSduiTelemetryHandlerNameRegistry)
local reportUnifiedLoggingAction = require(SduiCoreSystem.Analytics.reportUnifiedLoggingAction)
local FFlagSduiActionSkipUnifiedLogging = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionSkipUnifiedLogging

local function logActionTelemetry(s1: string?, p1, p2, p3, p4) -- line: 20
	-- upvalues: getSduiTelemetryHandlerNameRegistry (copy), SduiLogger (copy), SduiErrors (copy), FFlagSduiActionSkipUnifiedLogging (copy), reportUnifiedLoggingAction (copy)
	if s1 and s1 ~= "" then
		local v14 = getSduiTelemetryHandlerNameRegistry().getTelemetryHandler(s1)

		if v14 then
			v14(p2, p3, p4)
		else
			SduiLogger.reportError(SduiErrors.SduiErrorType.InvalidActionParams, {
				message = `Unknown telemetry handler name: { s1 }`,
				name = p2.actionType
			}, p4.appPage)
		end
	elseif p1.telemetryHandler then
		p1.telemetryHandler(p2, p3, p4)
	end

	if not if not FFlagSduiActionSkipUnifiedLogging then p1.skipUnifiedLogging else p1.skipUnifiedLogging or p2.skipUnifiedLogging then
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
