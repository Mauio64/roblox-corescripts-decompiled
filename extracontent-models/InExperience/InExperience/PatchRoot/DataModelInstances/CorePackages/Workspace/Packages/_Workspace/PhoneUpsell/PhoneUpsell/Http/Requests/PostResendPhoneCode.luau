local parent = script:FindFirstAncestor("PhoneUpsell").Parent
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("accountinformation:phone/resend")(), "POST", {
		postBody = ""
	})
end
