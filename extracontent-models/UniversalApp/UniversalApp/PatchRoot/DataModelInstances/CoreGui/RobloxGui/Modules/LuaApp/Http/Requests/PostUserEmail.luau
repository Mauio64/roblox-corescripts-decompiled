local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder

return function(p1, p2, p3) -- line: 21
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid email address in UpdateUserEmail")
	assert(type(p3) == "string" or p3 == nil, "invalid password in UpdateUserEmail")

	return p1(UrlBuilder.static.email.getSetEmail(), "POST", {
		postBody = HttpService:JSONEncode({
			password = p3,
			emailAddress = p2
		})
	})
end
