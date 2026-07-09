local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createTransparencyStore = require(script.createTransparencyStore)

return Signals.createComputed(createTransparencyStore)
