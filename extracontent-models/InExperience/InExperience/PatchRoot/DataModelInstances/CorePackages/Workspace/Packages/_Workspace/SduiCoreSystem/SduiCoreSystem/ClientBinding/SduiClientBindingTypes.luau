local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent

require(parent.ServiceContractsProto)
require(parent.Signals)

require(SduiCoreSystem.SduiBuilderTypes)
require(SduiCoreSystem.SduiErrors)
require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.ClientBinding.SduiDataBindingContentType)

return {
	PropResultCategory = {
		Literal = "Literal",
		PropSignal = "PropSignal",
		NestedComponentConfig = "NestedComponentConfig",
		NestedComponentConfigListPropSignal = "NestedComponentConfigListPropSignal",
		Failed = "Failed"
	}
}
