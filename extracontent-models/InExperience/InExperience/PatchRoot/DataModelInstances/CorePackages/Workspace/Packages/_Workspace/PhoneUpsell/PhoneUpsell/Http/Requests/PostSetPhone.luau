local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("PhoneUpsell").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, countryCode, value, value2, value3)
	assert(type(countryCode) == "string", "invalid country code in set phone number")
	assert(type(value) == "string", "invalid prefix in set phone number")
	assert(type(value2) == "string", "invalid phone number in set phone number")

	assert(type(value3) == "string" or value3 == nil, "invalid password in set phone number")
	local v = urlBuilder.fromString("accountinformation:phone")
	local jsonEncode = HttpService:JSONEncode({
		password = value3,
		countryCode = countryCode,
		prefix = value,
		phone = value2
	})

	return callback(v(), "POST", { postBody = jsonEncode })
end
