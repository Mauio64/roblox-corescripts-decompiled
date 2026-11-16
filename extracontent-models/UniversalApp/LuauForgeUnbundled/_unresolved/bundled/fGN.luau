local module = require("@luauforge/bundled/fGi")
local HttpService = game:GetService("HttpService")
local urlBuilder = module.UrlBuilder.UrlBuilder
local urlBase = module.UrlBuilder.UrlBase
require("@luauforge/bundled/fGz")

local v5 = urlBuilder.new({ base = urlBase.APIS, path = "otp-service/v1/resendCode" })

return function(callback, data)
	local jsonEncode = HttpService:JSONEncode({
		origin = data.origin,
		contactType = data.contactType,
		otpSessionToken = data.otpSessionToken
	})

	return callback(v5(), "POST", { postBody = jsonEncode })
end
