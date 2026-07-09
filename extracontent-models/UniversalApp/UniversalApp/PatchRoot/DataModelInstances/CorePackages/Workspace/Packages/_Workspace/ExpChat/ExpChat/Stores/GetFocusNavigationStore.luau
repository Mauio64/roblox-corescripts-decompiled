local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createFocusNavigationStore = require(script.createFocusNavigationStore)

return Signals.createComputed(createFocusNavigationStore)
