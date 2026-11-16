local parent = script:FindFirstAncestor("SduiSharedContent").Parent

local Signals = require(parent.Signals)

local createContentReactionsStore = require(script.Parent.createContentReactionsStore)

return Signals.createComputed(createContentReactionsStore)
