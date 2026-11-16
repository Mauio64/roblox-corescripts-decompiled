local parent = script:FindFirstAncestor("PurchasePrompt").Parent
local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local PolicyProvider = PurchasePromptDeps.PolicyProvider

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v = PolicyProvider.withGetPolicyImplementation(memStorageService)

function v.Mapper(_)
	return {}
end

return v
