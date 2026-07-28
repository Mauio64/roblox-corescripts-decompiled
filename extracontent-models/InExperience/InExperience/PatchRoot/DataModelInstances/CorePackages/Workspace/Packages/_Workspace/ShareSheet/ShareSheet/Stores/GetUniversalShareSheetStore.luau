local Parent = script:FindFirstAncestor("ShareSheet").Parent
local Signals = require(Parent.Signals)
local createUniversalShareSheetStore = require(script.Parent.createUniversalShareSheetStore)

return Signals.createComputed(createUniversalShareSheetStore)
