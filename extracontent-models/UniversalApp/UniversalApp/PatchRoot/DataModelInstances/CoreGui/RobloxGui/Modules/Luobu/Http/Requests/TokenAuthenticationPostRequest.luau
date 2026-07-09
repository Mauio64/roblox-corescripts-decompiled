local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1, p2, p3) -- line: 13
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%s/v1/%s/token-authentication?apiKey=%s", Url.AUTH_URL, p2, "d631f3d9-fce0-4711-8cf4-6f9a9756638b"), "POST", {
		postBody = HttpService:JSONEncode(p3)
	})
end
