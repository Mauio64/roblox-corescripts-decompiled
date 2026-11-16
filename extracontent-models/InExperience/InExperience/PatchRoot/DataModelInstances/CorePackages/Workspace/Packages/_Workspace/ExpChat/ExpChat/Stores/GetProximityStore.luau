local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createProximityStore = require(script.createProximityStore)

return Signals.createComputed(createProximityStore)
