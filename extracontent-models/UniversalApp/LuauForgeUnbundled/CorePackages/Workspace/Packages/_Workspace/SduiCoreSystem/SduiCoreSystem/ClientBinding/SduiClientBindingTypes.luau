require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/ServiceContractsProto")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/Signals")

require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiBuilderTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiErrors")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiActionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/SduiComponentType")
require("@game/CorePackages/Workspace/Packages/_Workspace/SduiCoreSystem/SduiCoreSystem/ClientBinding/SduiDataBindingContentType")

return {
	PropResultCategory = {
		Literal = "Literal",
		PropSignal = "PropSignal",
		NestedComponentConfig = "NestedComponentConfig",
		NestedComponentConfigListPropSignal = "NestedComponentConfigListPropSignal",
		Failed = "Failed"
	}
}
