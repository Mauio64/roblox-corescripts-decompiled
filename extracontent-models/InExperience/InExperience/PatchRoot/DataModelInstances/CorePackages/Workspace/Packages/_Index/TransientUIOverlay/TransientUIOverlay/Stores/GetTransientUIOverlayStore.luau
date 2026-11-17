local parent = script:FindFirstAncestor("TransientUIOverlay").Parent

local Signals = require(parent.Signals)
local createTransientUIOverlayStore = require(script.createTransientUIOverlayStore)

return Signals.createComputed(createTransientUIOverlayStore)
