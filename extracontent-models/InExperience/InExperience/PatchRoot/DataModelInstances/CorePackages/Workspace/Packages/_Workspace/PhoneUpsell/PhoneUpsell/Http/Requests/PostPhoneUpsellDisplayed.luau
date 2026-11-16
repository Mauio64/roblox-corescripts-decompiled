local parent = script:FindFirstAncestor("PhoneUpsell").Parent

local HttpService = game:GetService("HttpService")
local UrlBuilder = require(parent.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback, layerName: string, displayTime: number, userIgnored: boolean, flag: boolean)
	local jsonEncode = HttpService:JSONEncode({
		layerName = layerName,
		displayTime = displayTime,
		userIgnored = userIgnored
	})

	return callback(
		urlBuilder.fromString("apis:upsellcard/v1/phone-verification/display-time")(),
		"POST",
		flag and { postBody = jsonEncode } or jsonEncode
	)
end
