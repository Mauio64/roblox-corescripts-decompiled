local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createTopBarStore = require(script.createTopBarStore)

return Signals.createComputed(createTopBarStore)
