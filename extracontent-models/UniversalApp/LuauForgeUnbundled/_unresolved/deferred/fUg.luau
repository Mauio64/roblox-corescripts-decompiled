local HttpService = game:GetService("HttpService")
local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, value, value2)
	assert(type(value) == "string", "invalid email address in UpdateUserEmail")

	assert(type(value2) == "string" or value2 == nil, "invalid password in UpdateUserEmail")

	return callback(urlBuilder.static.email.getSetEmail(), "POST", {
		postBody = HttpService:JSONEncode({ password = value2, emailAddress = value })
	})
end
