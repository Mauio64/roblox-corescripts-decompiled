local _script = script
local PurchaseFlowUUIDTelemetry = require(_script.PurchaseFlowUUIDTelemetry)
local FocusNavigationOptimizationTelemetry = require(_script.FocusNavigationOptimizationTelemetry)

return {
	PurchaseFlowUUIDTelemetry = PurchaseFlowUUIDTelemetry,
	FocusNavigationOptimizationTelemetry = FocusNavigationOptimizationTelemetry
}
