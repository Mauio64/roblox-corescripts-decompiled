local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/LoggingProtocol").default

local RobuxTransferFlowTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/CurrencyTransfers/CurrencyTransfers/Events/RobuxTransferFlowTelemetry")

function LUAUFORGE_MODULE_GLOBALS_ene_sendRobuxTransferFlowEvent(p2)
	default:logRobloxTelemetryEvent(
		RobuxTransferFlowTelemetry.RobuxTransferFlowEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p2,
		"RobuxTransferFlow"
	)
end

return LUAUFORGE_MODULE_GLOBALS_ene_sendRobuxTransferFlowEvent
