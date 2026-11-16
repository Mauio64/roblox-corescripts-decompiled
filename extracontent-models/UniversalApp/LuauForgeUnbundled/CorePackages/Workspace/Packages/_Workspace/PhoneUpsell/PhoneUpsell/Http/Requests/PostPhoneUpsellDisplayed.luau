local HttpService = game:GetService("HttpService")
local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UrlBuilder").UrlBuilder

return function(callback, p2, p3, p4, p5)
	local jsonEncode = HttpService:JSONEncode({
		layerName = p2,
		displayTime = p3,
		userIgnored = p4
	})

	return callback(
		urlBuilder.fromString("apis:upsellcard/v1/phone-verification/display-time")(),
		"POST",
		p5 and { postBody = jsonEncode } or jsonEncode
	)
end
