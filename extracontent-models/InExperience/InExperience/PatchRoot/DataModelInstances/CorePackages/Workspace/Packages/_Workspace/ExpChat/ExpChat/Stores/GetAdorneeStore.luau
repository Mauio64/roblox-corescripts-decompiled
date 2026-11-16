local parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(parent.Signals)
local createAdorneeStore = require(script.createAdorneeStore)

return Signals.createComputed(createAdorneeStore)
