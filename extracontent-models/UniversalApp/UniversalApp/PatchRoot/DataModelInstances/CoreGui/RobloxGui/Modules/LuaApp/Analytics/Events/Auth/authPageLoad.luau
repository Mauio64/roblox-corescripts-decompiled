local CorePackages = game:GetService("CorePackages")
local authPageload = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authPageload

return function(_, s1: string, s2: string?, b1: boolean?) -- line: 5
	-- upvalues: authPageload (copy)
	authPageload(s1, s2, b1)
end
