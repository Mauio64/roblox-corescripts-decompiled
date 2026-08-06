local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createRootedNavigationStore = require(script.createRootedNavigationStore)

return Signals.createComputed(createRootedNavigationStore)
