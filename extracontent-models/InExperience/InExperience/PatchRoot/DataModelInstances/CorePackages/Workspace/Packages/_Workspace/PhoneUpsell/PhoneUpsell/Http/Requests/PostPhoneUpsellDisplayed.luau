local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local HttpService = game:GetService("HttpService")
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1, s1: string, n1: number, b1: boolean, b2: boolean) -- line: 7
	-- upvalues: HttpService (copy), UrlBuilder (copy)
	local json = HttpService:JSONEncode({
		layerName = s1,
		displayTime = n1,
		userIgnored = b1
	})

	return p1(UrlBuilder.fromString("apis:upsellcard/v1/phone-verification/display-time")(), "POST", if not b2 then json else {
		postBody = json
	})
end
