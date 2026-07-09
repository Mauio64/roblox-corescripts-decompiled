local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder

return function(p1) -- line: 15
	-- upvalues: UrlBuilder (copy)
	return p1(UrlBuilder.static.email.getSetEmail(), "GET")
end
