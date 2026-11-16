local parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(parent.Signals)
local createToastStore = require(script.createToastStore)

return Signals.createComputed(createToastStore)
