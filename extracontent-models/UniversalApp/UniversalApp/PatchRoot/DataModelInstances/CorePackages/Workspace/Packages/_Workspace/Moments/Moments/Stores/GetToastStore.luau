local Parent = script:FindFirstAncestor("Moments").Parent
local Signals = require(Parent.Signals)
local createToastStore = require(script.createToastStore)

return Signals.createComputed(createToastStore)
