local parent = script.Parent.Parent
local PolicyProvider = require(parent.PolicyProvider)

local UniversalAppGetPolicy = require(script.Parent.UniversalAppGetPolicy)

return (PolicyProvider.withGetPolicyImplementation(UniversalAppGetPolicy))
