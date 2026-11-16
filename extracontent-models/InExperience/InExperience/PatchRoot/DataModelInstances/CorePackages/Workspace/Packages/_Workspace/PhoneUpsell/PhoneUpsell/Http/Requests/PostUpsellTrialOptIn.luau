local HttpService = game:GetService("HttpService")
local parent = script:FindFirstAncestor("PhoneUpsell").Parent
local Http = require(parent.Http)
local Url = Http.Url

return function(callback, upsellCardType: string)
	return callback(string.format("%supsellcard/trial-opt-in", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({ upsellCardType = upsellCardType })
	})
end
