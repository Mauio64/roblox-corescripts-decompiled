local CorePackages = game:GetService("CorePackages")
local UniversalAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy)

return function() -- line: 5
	-- upvalues: UniversalAppPolicy (copy)
	return (UniversalAppPolicy.getAppFeaturePolicies().getCanSeeChatTab())
end
