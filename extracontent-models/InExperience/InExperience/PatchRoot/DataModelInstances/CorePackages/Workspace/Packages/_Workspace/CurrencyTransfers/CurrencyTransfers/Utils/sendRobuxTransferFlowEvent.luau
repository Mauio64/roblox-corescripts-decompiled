local CurrencyTransfers = script:FindFirstAncestor("CurrencyTransfers")
local CurrencyTransfersParent = CurrencyTransfers.Parent
local default = require(CurrencyTransfersParent.LoggingProtocol).default
local RobuxTransferFlowTelemetry = require(CurrencyTransfers.Events.RobuxTransferFlowTelemetry)

function sendRobuxTransferFlowEvent(t1: {[any]: any}) -- line: 7
	-- upvalues: default (copy), RobuxTransferFlowTelemetry (copy)
	default:logRobloxTelemetryEvent(RobuxTransferFlowTelemetry.RobuxTransferFlowEvent, {
		default.StandardizedFields.addOsInfo,
		default.StandardizedFields.addSessionId,
		"addSessionInfo"
	}, t1, "RobuxTransferFlow")
end

return sendRobuxTransferFlowEvent
