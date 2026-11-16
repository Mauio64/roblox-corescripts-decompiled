local SduiCoreSystem = script:FindFirstAncestor("SduiCoreSystem")
local parent = SduiCoreSystem.Parent
require(parent.React)
require(parent.UnifiedLogging)
require(parent.Foundation)
require(parent.CollectionViews)
require(parent.Signals)

require(SduiCoreSystem.SduiActionType)
require(SduiCoreSystem.SduiComponentType)
require(SduiCoreSystem.SduiErrors)
require(SduiCoreSystem.SduiConfigTypes)
require(SduiCoreSystem.SduiDataStoreTypes)
require(parent.DataHydration)

return {
	SduiBuilderProcessingPhase = { Eager = "Eager", Render = "Render", Lazy = "Lazy" }
}
