local memStorageService = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/PolicyProvider").GetPolicyImplementations.MemStorageService("app-policy")

return function()
	return memStorageService.read()
end
