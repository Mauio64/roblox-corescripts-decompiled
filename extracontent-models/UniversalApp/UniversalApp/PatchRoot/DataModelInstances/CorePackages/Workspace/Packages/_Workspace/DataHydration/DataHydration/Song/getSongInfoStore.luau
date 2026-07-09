local Parent = script:FindFirstAncestor("DataHydration").Parent
local Signals = require(Parent.Signals)
local createSongInfoStore = require(script.Parent.createSongInfoStore)

return Signals.createComputed(createSongInfoStore)
