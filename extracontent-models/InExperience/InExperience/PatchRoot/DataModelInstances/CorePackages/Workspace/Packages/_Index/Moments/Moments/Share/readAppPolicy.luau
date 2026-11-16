local parent = script:FindFirstAncestor("Moments").Parent

local PolicyProvider = require(parent.PolicyProvider)

local memStorageService = PolicyProvider.GetPolicyImplementations.MemStorageService("app-policy")

return function()
	return memStorageService.read()
end
