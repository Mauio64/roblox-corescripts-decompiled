local Parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(Parent.Signals)
local createOverlayStore = require(script.createOverlayStore)

return Signals.createComputed(createOverlayStore)
