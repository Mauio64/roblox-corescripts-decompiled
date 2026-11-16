local parent = script:FindFirstAncestor("UniversalAppPolicy").Parent

local Signals = require(parent.Signals)

local createAppPolicyStore = require(script.createAppPolicyStore)

return Signals.createComputed(createAppPolicyStore)
