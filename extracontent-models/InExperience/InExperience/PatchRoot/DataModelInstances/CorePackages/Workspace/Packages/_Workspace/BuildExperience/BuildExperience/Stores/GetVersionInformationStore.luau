local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)

local createVersionInformationStore = require(script.createVersionInformationStore)

return Signals.createComputed(createVersionInformationStore)
