local FFlagAXRootSlotBasedEditorFlag = require(script.Parent.FFlagAXRootSlotBasedEditorFlag)
local FFlagAXModeratedItemsFlow = require(script.Parent.FFlagAXModeratedItemsFlow)
local FFlagAXEnableModeratedItemsFlowForDurables = require(script.Parent.FFlagAXEnableModeratedItemsFlowForDurables)
local FFlagAXEditorSubcategoryFilters = require(script.Parent.FFlagAXEditorSubcategoryFilters)
local v5 = game:DefineFastFlag("AXInventoryDurablesSupport5", false) and (FFlagAXRootSlotBasedEditorFlag and ((FFlagAXEnableModeratedItemsFlowForDurables or FFlagAXModeratedItemsFlow) and FFlagAXEditorSubcategoryFilters))
local v6 = game:DefineFastFlag("AXStandaloneInventoryDurablesSupport", false) and (FFlagAXRootSlotBasedEditorFlag and ((FFlagAXEnableModeratedItemsFlowForDurables or FFlagAXModeratedItemsFlow) and FFlagAXEditorSubcategoryFilters))

return v5 or v6
