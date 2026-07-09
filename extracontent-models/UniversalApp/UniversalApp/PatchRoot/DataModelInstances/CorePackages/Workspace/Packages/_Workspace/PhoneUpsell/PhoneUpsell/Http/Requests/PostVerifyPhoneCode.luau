local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, p2) -- line: 19
	-- upvalues: UrlBuilder (copy), HttpService (copy)
	assert(type(p2) == "string", "invalid code in verify phone code")
	assert(not string.match(p2, "%D"), "invalid code in verify phone code")

	local v6 = UrlBuilder.fromString("accountinformation:phone/verify")
	local json = HttpService:JSONEncode({
		code = p2
	})

	return p1(v6(), "POST", {
		postBody = json
	})
end
