local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")

local logActionTelemetry = require(SduiCoreSystem.Analytics.logActionTelemetry)

require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiConfigTypes)
local getSduiActionHandlerRegistry = require(SduiCoreSystem.getSduiActionHandlerRegistry)
local createSduiErrorLogger = require(SduiCoreSystem.createSduiErrorLogger)
local SharedFlags = require(SduiCoreSystem.Parent.SharedFlags)
local FFlagSduiErrorPaths = SharedFlags.FFlagSduiErrorPaths

local function executeAction(p, p2, p3, p4)
	if not p then
		return
	end

	assert(p, "actionConfig must exist")

	local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(p.actionType)

	if not actionHandlerConfig then
		return
	end

	assert(actionHandlerConfig, "actionHandlerConfig must exist")

	if FFlagSduiErrorPaths then
		p3 = table.clone(p3)
		p3.dependencies = table.clone(p3.dependencies)
		p3.dependencies.logger = createSduiErrorLogger(p3.dependencies.logger, nil, p.actionType)
	end

	logActionTelemetry(p.telemetryHandler, actionHandlerConfig, p, p2, p3)

	if actionHandlerConfig.handler then
		return actionHandlerConfig.handler(p, p2, p3, p4)
	end
end

return executeAction
