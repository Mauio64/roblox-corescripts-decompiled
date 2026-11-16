local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createTransparencyStore = require(script.createTransparencyStore)

return Signals.createComputed(createTransparencyStore)
