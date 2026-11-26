local HttpService = game:GetService("HttpService")

local url = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Http").Url

return function(callback, p2)
	return callback(string.format("%supsellcard/trial-opt-in", url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({ upsellCardType = p2 })
	})
end
