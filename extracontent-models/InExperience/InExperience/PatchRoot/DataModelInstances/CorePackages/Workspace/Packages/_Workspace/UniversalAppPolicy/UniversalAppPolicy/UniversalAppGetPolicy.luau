local parent = script.Parent.Parent
local PolicyProvider = require(parent.PolicyProvider)

return (PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy"))
