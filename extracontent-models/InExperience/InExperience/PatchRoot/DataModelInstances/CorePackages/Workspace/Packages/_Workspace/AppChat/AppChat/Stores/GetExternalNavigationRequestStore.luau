local parent = script:FindFirstAncestor("AppChat").Parent
local Signals = require(parent.Signals)

local createExternalNavigationRequestStore = require(script.createExternalNavigationRequestStore)

return Signals.createComputed(createExternalNavigationRequestStore)
