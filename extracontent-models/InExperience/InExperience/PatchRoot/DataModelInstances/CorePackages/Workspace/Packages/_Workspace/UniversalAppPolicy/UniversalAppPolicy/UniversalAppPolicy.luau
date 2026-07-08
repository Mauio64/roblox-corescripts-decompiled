local ParentParent = script.Parent.Parent
local PolicyProvider = require(ParentParent.PolicyProvider)
local UniversalAppGetPolicy = require(script.Parent.UniversalAppGetPolicy)

return (PolicyProvider.withGetPolicyImplementation(UniversalAppGetPolicy))
