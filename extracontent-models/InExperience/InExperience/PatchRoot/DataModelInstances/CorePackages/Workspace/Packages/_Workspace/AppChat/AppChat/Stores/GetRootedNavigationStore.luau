local parent = script:FindFirstAncestor("AppChat").Parent

local Signals = require(parent.Signals)

local createRootedNavigationStore = require(script.createRootedNavigationStore)

return Signals.createComputed(createRootedNavigationStore)
