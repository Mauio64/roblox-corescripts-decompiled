local Parent = script:FindFirstAncestor("PeopleReactView").Parent
local Signals = require(Parent.Signals)
local createVirtualizedGridStore = require(script.createVirtualizedGridStore)

return Signals.createComputed(createVirtualizedGridStore)
