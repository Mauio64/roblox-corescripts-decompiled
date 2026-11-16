local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
local SharedFlags = require(parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
local SduiErrors = require(SduiCoreSystem.SduiErrors)
local SduiLogger = require(SduiCoreSystem.SduiLogger)
local getSduiTelemetryHandlerNameRegistry = require(SduiCoreSystem.getSduiTelemetryHandlerNameRegistry)
local reportUnifiedLoggingAction = require(SduiCoreSystem.Analytics.reportUnifiedLoggingAction)

local function logActionTelemetry(p: string?, p2, p3, p4, p5)
	if p and p ~= "" then
		local telemetryHandler = getSduiTelemetryHandlerNameRegistry().getTelemetryHandler(p)

		if telemetryHandler then
			telemetryHandler(p3, p4, p5)
		else
			local v

			if FFlagSduiErrorPaths then
				v = p5.dependencies and p5.dependencies.logger or SduiLogger
			else
				v = SduiLogger
			end

			v.reportError(
				SduiErrors.SduiErrorType.InvalidActionParams,
				{
					message = `Unknown telemetry handler name: {p}`,
					name = p3.actionType
				},
				p5.appPage
			)
		end
	elseif p2.telemetryHandler then
		p2.telemetryHandler(p3, p4, p5)
	end

	if not (p2.skipUnifiedLogging or p3.skipUnifiedLogging) then
		if p4 == nil then
			local v

			if FFlagSduiErrorPaths then
				v = p5.dependencies and p5.dependencies.logger or SduiLogger
			else
				v = SduiLogger
			end

			v.reportError(
				SduiErrors.SduiErrorType.NilAnalyticsContext,
				{
					message = `Could not reportUnifiedLoggingAction. Missing analyticsContext {p3.actionType}`,
					name = p3.actionType
				},
				p5.appPage
			)
		else
			reportUnifiedLoggingAction(p5, p3, p4)
		end
	end
end

return logActionTelemetry
