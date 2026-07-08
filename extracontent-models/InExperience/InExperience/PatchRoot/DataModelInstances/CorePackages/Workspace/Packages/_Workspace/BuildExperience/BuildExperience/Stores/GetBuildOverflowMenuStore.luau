local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createBuildOverflowMenuStore = require(script.createBuildOverflowMenuStore)

return Signals.createComputed(createBuildOverflowMenuStore)
