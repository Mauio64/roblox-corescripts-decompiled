local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createPlayButtonStore = require(script.createPlayButtonStore)

return Signals.createComputed(createPlayButtonStore)
