local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createOverlayStore = require(script.createOverlayStore)

return Signals.createComputed(createOverlayStore)
