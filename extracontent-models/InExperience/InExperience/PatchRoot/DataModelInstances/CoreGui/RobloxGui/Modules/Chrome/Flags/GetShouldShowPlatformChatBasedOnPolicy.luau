local CorePackages = game:GetService("CorePackages")

local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

return function()
	return (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab())
end
