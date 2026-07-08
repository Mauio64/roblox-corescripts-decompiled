local Parent = script:FindFirstAncestor("ExpChat").Parent
local Signals = require(Parent.Signals)
local createAdorneeStore = require(script.createAdorneeStore)

return Signals.createComputed(createAdorneeStore)
