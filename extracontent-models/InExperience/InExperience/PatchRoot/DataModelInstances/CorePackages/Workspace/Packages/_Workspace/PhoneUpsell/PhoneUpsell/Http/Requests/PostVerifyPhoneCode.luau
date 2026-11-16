local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("PhoneUpsell").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, code)
	assert(type(code) == "string", "invalid code in verify phone code")

	assert(not string.match(code, "%D"), "invalid code in verify phone code")
	local v = urlBuilder.fromString("accountinformation:phone/verify")
	local jsonEncode = HttpService:JSONEncode({ code = code })

	return callback(v(), "POST", { postBody = jsonEncode })
end
