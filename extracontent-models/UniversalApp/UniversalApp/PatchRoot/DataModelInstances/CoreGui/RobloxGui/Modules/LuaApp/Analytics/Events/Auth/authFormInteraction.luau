local CorePackages = game:GetService("CorePackages")
local authFormInteraction = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authFormInteraction

return function(_, p2, s1: string?, s2: string?, s3: string?, s4: string?) -- line: 11
	-- upvalues: authFormInteraction (copy)
	authFormInteraction(p2, s1, s2, s3, s4)
end
