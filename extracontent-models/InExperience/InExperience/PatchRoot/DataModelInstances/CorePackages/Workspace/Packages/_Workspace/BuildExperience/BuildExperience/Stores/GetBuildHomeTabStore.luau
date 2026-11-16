local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local createBuildHomeTabStore = require(script.createBuildHomeTabStore)

return Signals.createComputed(createBuildHomeTabStore.createBuildHomeTabStore)
