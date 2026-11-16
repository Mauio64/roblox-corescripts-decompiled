local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createFocusNavigationStore = require(script.createFocusNavigationStore)

return Signals.createComputed(createFocusNavigationStore)
