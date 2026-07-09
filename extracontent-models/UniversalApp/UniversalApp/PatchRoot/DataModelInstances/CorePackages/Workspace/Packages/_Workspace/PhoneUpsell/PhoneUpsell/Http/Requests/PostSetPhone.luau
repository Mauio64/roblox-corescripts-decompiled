local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2, p3, p4, p5) -- line: 19
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid country code in set phone number")
	assert(type(p3) == "string", "invalid prefix in set phone number")
	assert(type(p4) == "string", "invalid phone number in set phone number")
	assert(type(p5) == "string" or p5 == nil, "invalid password in set phone number")

	local v9 = UrlBuilder.fromString("accountinformation:phone")
	local json = HttpService:JSONEncode({
		password = p5,
		countryCode = p2,
		prefix = p3,
		phone = p4
	})

	return p1(v9(), "POST", {
		postBody = json
	})
end
