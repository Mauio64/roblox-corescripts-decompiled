local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UrlBuilder").UrlBuilder

return function(callback, value, value2, value3, value4)
	assert(type(value) == "string", "invalid country code in set phone number")
	assert(type(value2) == "string", "invalid prefix in set phone number")
	assert(type(value3) == "string", "invalid phone number in set phone number")

	assert(type(value4) == "string" or value4 == nil, "invalid password in set phone number")
	local v5 = urlBuilder.fromString("accountinformation:phone")
	local jsonEncode = HttpService:JSONEncode({
		password = value4,
		countryCode = value,
		prefix = value2,
		phone = value3
	})

	return callback(v5(), "POST", { postBody = jsonEncode })
end
