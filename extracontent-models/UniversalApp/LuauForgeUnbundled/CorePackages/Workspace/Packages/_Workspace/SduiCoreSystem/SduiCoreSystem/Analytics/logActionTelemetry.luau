local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local SduiErrors = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
local SduiLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiLogger")
local getSduiTelemetryHandlerNameRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiTelemetryHandlerNameRegistry")
local reportUnifiedLoggingAction = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/reportUnifiedLoggingAction")

local function logActionTelemetry(p2, p3, p4, p5, p6)
	if p2 and p2 ~= "" then
		local telemetryHandler = getSduiTelemetryHandlerNameRegistry().getTelemetryHandler(p2)

		if telemetryHandler then
			telemetryHandler(p4, p5, p6)
		else
			local v5

			if fFlagSduiErrorPaths then
				v5 = p6.dependencies and p6.dependencies.logger or SduiLogger
			else
				v5 = SduiLogger
			end

			v5.reportError(
				SduiErrors.SduiErrorType.InvalidActionParams,
				{
					message = `Unknown telemetry handler name: {p2}`,
					name = p4.actionType
				},
				p6.appPage
			)
		end
	elseif p3.telemetryHandler then
		p3.telemetryHandler(p4, p5, p6)
	end

	if not (p3.skipUnifiedLogging or p4.skipUnifiedLogging) then
		if p5 == nil then
			local v5

			if fFlagSduiErrorPaths then
				v5 = p6.dependencies and p6.dependencies.logger or SduiLogger
			else
				v5 = SduiLogger
			end

			v5.reportError(
				SduiErrors.SduiErrorType.NilAnalyticsContext,
				{
					message = `Could not reportUnifiedLoggingAction. Missing analyticsContext {p4.actionType}`,
					name = p4.actionType
				},
				p6.appPage
			)
		else
			reportUnifiedLoggingAction(p6, p4, p5)
		end
	end
end

return logActionTelemetry
