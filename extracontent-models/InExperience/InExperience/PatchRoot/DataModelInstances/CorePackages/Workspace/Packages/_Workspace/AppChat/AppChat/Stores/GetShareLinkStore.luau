local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createShareLinkStore = require(script.createShareLinkStore)

return Signals.createComputed(createShareLinkStore)
