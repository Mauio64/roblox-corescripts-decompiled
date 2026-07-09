local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createTopBarStore = require(script.createTopBarStore)

return Signals.createComputed(createTopBarStore)
