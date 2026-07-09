local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createProximityStore = require(script.createProximityStore)

return Signals.createComputed(createProximityStore)
