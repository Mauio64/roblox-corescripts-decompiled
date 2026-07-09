local CorePackages = game:GetService("CorePackages")
local authModalShown = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authModalShown

return function(_, s1: string, s2: string) -- line: 5
	-- upvalues: authModalShown (copy)
	authModalShown(s1, s2)
end
