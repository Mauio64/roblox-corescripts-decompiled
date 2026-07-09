local CorePackages = game:GetService("CorePackages")
local authButtonClick = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authButtonClick

return function(_, s1: string, s2: string, s3: string?, s4: string?, b1: boolean?, s5: string?, s6: string?) -- line: 5
	-- upvalues: authButtonClick (copy)
	authButtonClick(s1, s2, s3, s4, b1, s5, s6)
end
