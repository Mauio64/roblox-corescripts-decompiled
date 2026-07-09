local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local SduiCoreSystemParent = SduiCoreSystem.Parent

require(SduiCoreSystemParent.React)
require(SduiCoreSystemParent.UnifiedLogging)
require(SduiCoreSystemParent.Foundation)
require(SduiCoreSystemParent.CollectionViews)
require(SduiCoreSystemParent.Signals)
require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiErrors)
require(SduiCoreSystem.SduiConfigTypes)
require(SduiCoreSystem.SduiDataStoreTypes)
require(SduiCoreSystemParent.DataHydration)

return {
	SduiBuilderProcessingPhase = {
		Eager = "Eager",
		Render = "Render",
		Lazy = "Lazy"
	}
}
