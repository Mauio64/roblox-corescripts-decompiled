local parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(parent.Signals)
local createSideSheetConfigStore = require(script.createSideSheetConfigStore)

return Signals.createComputed(createSideSheetConfigStore)
