local HttpService = game:GetService("HttpService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UrlBuilder").UrlBuilder

return function(callback, value)
	assert(type(value) == "string", "invalid code in verify phone code")

	assert(not string.match(value, "%D"), "invalid code in verify phone code")
	local v5 = urlBuilder.fromString("accountinformation:phone/verify")
	local jsonEncode = HttpService:JSONEncode({ code = value })

	return callback(v5(), "POST", { postBody = jsonEncode })
end
