local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent
local logActionTelemetry = require(SduiCoreSystem.Analytics.logActionTelemetry)
local reportUnifiedLoggingAction = require(SduiCoreSystem.Analytics.reportUnifiedLoggingAction)

require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)

local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)
local FFlagSduiChartsSupport = require(SduiCoreSystemParent.SharedFlags).FFlagSduiChartsSupport
local FFlagSduiActionTelemetryHandler = require(SduiCoreSystemParent.SharedFlags).FFlagSduiActionTelemetryHandler

local function executeAction(p1, p2, p3, p4) -- line: 22
	-- upvalues: getSduiActionHandlerRegistry (copy), FFlagSduiActionTelemetryHandler (copy), logActionTelemetry (copy), reportUnifiedLoggingAction (copy), FFlagSduiChartsSupport (copy)
	if not p1 then
		return
	end

	assert(p1, "actionConfig must exist")

	local v13 = getSduiActionHandlerRegistry().getActionHandlerConfig(p1.actionType)

	if not v13 then
		return
	end

	assert(v13, "actionHandlerConfig must exist")

	if FFlagSduiActionTelemetryHandler then
		logActionTelemetry(p1.telemetryHandler, v13, p1, p2, p3)
	elseif not v13.skipUnifiedLogging then
		reportUnifiedLoggingAction(p3, p1, p2)
	end

	if v13.handler then
		if FFlagSduiChartsSupport then
			return v13.handler(p1, p2, p3, p4)
		end

		v13.handler(p1, p2, p3, p4)
	end
end

return executeAction
