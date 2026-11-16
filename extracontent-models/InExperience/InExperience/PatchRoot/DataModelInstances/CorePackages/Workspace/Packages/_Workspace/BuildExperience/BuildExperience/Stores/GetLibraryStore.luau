local parent = script:FindFirstAncestor("BuildExperience").Parent

local Signals = require(parent.Signals)
local createLibraryStore = require(script.createLibraryStore)

return Signals.createComputed(createLibraryStore)
