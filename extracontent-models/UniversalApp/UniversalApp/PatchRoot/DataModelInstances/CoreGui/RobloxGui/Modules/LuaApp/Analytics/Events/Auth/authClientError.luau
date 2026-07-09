local CorePackages = game:GetService("CorePackages")
local authClientError = require(CorePackages.Workspace.Packages.AuthAnalytics).Events.authClientError

return function(_, s1: string, s2: string, s3: string?) -- line: 5
	-- upvalues: authClientError (copy)
	authClientError(s1, s2, s3)
end
