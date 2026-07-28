local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createVersionInformationStore = require(script.createVersionInformationStore)

return Signals.createComputed(createVersionInformationStore)
