local Parent = script:FindFirstAncestor("BuildExperience").Parent
local Signals = require(Parent.Signals)
local createPlayButtonStore = require(script.createPlayButtonStore)

return Signals.createComputed(createPlayButtonStore)
