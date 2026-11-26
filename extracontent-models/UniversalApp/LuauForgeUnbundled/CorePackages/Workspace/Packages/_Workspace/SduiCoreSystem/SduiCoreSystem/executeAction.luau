local logActionTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/Analytics/logActionTelemetry")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiActionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiConfigTypes")
local getSduiActionHandlerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/getSduiActionHandlerRegistry")
local createSduiErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/createSduiErrorLogger")
local fFlagSduiErrorPaths = require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SharedFlags").FFlagSduiErrorPaths

local function executeAction(p2, p3, p4, p5)
	if not p2 then
		return
	end

	assert(p2, "actionConfig must exist")

	local actionHandlerConfig = getSduiActionHandlerRegistry().getActionHandlerConfig(p2.actionType)

	if not actionHandlerConfig then
		return
	end

	assert(actionHandlerConfig, "actionHandlerConfig must exist")

	if fFlagSduiErrorPaths then
		p4 = table.clone(p4)
		p4.dependencies = table.clone(p4.dependencies)
		p4.dependencies.logger = createSduiErrorLogger(p4.dependencies.logger, nil, p2.actionType)
	end

	logActionTelemetry(p2.telemetryHandler, actionHandlerConfig, p2, p3, p4)

	if actionHandlerConfig.handler then
		return actionHandlerConfig.handler(p2, p3, p4, p5)
	end
end

return executeAction
