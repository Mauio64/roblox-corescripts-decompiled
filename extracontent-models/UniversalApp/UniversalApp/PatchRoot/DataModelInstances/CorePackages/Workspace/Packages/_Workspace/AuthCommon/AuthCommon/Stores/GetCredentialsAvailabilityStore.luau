local Parent = script:FindFirstAncestor("AuthCommon").Parent
local Signals = require(Parent.Signals)
local createCredentialsAvailabilityStore = require(script.createCredentialsAvailabilityStore)

return Signals.createComputed(createCredentialsAvailabilityStore)
