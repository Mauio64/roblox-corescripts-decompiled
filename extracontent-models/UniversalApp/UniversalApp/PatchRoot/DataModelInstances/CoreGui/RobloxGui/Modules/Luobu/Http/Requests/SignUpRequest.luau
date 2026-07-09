local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.Http)

local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1, p2, p3) -- line: 15
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%s/v1/%s/signupwithoutpassword?apiKey=%s", Url.AUTH_URL, p2, "d631f3d9-fce0-4711-8cf4-6f9a9756638b"), "POST", {
		postBody = HttpService:JSONEncode(p3)
	})
end
