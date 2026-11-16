local parent = script:FindFirstAncestor("AuthCommon").Parent

local Signals = require(parent.Signals)
local createCredentialsAvailabilityStore = require(script.createCredentialsAvailabilityStore)

return Signals.createComputed(createCredentialsAvailabilityStore)
