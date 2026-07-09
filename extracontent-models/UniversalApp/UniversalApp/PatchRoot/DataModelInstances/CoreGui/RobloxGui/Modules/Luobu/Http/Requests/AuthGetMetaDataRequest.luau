game:GetService("HttpService")

local CorePackages = game:GetService("CorePackages")
local Url = require(CorePackages.Workspace.Packages.Http).Url

return function(p1, p2) -- line: 11
	-- upvalues: Url (copy)
	return p1(string.format("%s/v1/%s/metadata?appType=PlayerApplication", Url.AUTH_URL, p2), "GET", {
		headers = {
			Referer = "https://roblox.cn/"
		}
	})
end
