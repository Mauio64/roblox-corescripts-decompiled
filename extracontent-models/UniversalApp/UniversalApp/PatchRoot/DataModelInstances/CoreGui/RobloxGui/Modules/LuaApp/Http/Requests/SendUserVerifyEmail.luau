local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder

return function(p1) -- line: 20
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.static.email.sendVerificationEmail(), "POST", {
		postBody = "{}"
	})
end
