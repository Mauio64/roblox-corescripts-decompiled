local Parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PolicyProvider = require(Parent.PurchasePromptDeps).PolicyProvider
local v3 = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v4 = PolicyProvider.withGetPolicyImplementation(v3)

function v4.Mapper(_) -- line: 9
	return {}
end

return v4
