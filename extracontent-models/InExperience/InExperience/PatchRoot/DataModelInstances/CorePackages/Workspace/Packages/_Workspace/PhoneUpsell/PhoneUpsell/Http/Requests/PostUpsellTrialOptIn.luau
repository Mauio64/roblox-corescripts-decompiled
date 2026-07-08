local HttpService = game:GetService("HttpService")
local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local Url = require(Parent.Http).Url

return function(p1, s1: string) -- line: 6
	-- upvalues: Url (copy), HttpService (copy)
	return p1(string.format("%supsellcard/trial-opt-in", Url.APIS_URL), "POST", {
		postBody = HttpService:JSONEncode({
			upsellCardType = s1
		})
	})
end
