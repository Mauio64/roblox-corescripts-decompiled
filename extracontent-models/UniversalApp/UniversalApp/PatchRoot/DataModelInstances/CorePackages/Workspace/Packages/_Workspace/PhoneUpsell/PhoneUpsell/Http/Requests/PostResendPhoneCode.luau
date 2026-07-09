local Parent = script:FindFirstAncestor("PhoneUpsell").Parent
local UrlBuilder = require(Parent.UrlBuilder).UrlBuilder

return function(p1) -- line: 18
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.fromString("accountinformation:phone/resend")(), "POST", {
		postBody = ""
	})
end
