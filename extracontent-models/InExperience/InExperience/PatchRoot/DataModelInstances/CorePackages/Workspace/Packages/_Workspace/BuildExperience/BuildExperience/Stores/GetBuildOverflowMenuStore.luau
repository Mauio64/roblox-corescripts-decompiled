local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createBuildOverflowMenuStore = require(script.createBuildOverflowMenuStore)

return Signals.createComputed(createBuildOverflowMenuStore)
