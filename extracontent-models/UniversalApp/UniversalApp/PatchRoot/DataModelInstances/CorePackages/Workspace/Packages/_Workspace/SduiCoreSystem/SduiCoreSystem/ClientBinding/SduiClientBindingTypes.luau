local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.ServiceContractsProto)
require(SduiCoreSystemParent.Signals)
require(SduiCoreSystem.SduiBuilderTypes)
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
