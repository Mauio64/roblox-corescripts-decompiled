local parent = script:FindFirstAncestor("AuthenticationStatus").Parent

local Signals = require(parent.Signals)
local createAuthenticationStatusStore = require(script.createAuthenticationStatusStore)

return Signals.createComputed(createAuthenticationStatusStore)
