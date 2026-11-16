local parent = script:FindFirstAncestor("DataHydration").Parent

local Signals = require(parent.Signals)

local createSongInfoStore = require(script.Parent.createSongInfoStore)

return Signals.createComputed(createSongInfoStore)
