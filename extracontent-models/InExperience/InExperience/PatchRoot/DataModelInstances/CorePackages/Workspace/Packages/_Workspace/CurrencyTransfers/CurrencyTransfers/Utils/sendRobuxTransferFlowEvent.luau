local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local parent = CurrencyTransfers.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local RobuxTransferFlowTelemetry = require(CurrencyTransfers.Events.RobuxTransferFlowTelemetry)

function sendRobuxTransferFlowEvent(p)
	default:logRobloxTelemetryEvent(
		RobuxTransferFlowTelemetry.RobuxTransferFlowEvent,
		{ default.StandardizedFields.addOsInfo, default.StandardizedFields.addSessionId, "addSessionInfo" },
		p,
		"RobuxTransferFlow"
	)
end

return sendRobuxTransferFlowEvent
