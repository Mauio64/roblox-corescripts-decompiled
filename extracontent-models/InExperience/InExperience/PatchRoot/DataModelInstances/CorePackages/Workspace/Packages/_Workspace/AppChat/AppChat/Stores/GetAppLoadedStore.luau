local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createAppLoadedStore = require(script.createAppLoadedStore)

return Signals.createComputed(createAppLoadedStore)
