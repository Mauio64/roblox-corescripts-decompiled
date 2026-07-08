local Parent = script:FindFirstAncestor("InExperienceSideSheet").Parent
local Signals = require(Parent.Signals)
local createSideSheetConfigStore = require(script.createSideSheetConfigStore)

return Signals.createComputed(createSideSheetConfigStore)
