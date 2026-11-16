local policyProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").PolicyProvider

local memStorageService = policyProvider.GetPolicyImplementations.MemStorageService("app-policy")
local v5 = policyProvider.withGetPolicyImplementation(memStorageService)

function v5.Mapper(p2)
	return {}
end

return v5
