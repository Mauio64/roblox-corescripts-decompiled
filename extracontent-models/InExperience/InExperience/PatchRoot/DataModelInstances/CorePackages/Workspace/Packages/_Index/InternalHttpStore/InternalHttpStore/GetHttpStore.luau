local parent = script.Parent
local parent2 = parent.Parent
local Signals = require(parent2.Signals)

local createHttpStore = require(parent.createHttpStore)

return Signals.createComputed(createHttpStore)
