local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UrlBuilder").UrlBuilder

return function(callback)
	return callback(urlBuilder.fromString("accountinformation:phone/resend")(), "POST", {
		postBody = ""
	})
end
