local parent = script:FindFirstAncestor("PeopleReactView").Parent

local Signals = require(parent.Signals)
local createVirtualizedGridStore = require(script.createVirtualizedGridStore)

return Signals.createComputed(createVirtualizedGridStore)
