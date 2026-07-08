local Parent = script:FindFirstAncestor("AuthCommon").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2) -- line: 8
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	local v6 = UrlBuilder.fromString("apis:account-switcher/v1/logoutAllLoggedInUsers")
	local json = HttpService:JSONEncode({
		encrypted_users_data_blob = p2
	})

	return p1(v6(), "POST", {
		postBody = json
	})
end
