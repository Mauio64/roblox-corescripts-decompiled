local Parent = script:FindFirstAncestor("AuthenticationStatus").Parent
local Signals = require(Parent.Signals)
local createAuthenticationStatusStore = require(script.createAuthenticationStatusStore)

return Signals.createComputed(createAuthenticationStatusStore)
