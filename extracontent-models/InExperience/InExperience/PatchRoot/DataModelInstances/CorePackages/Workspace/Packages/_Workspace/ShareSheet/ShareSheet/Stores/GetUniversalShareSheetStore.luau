local parent = script:FindFirstAncestor("ShareSheet").Parent

local Signals = require(parent.Signals)

local createUniversalShareSheetStore = require(script.Parent.createUniversalShareSheetStore)

return Signals.createComputed(createUniversalShareSheetStore)
