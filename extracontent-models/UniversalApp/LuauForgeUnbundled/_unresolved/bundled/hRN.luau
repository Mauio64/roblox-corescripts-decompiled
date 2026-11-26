local CorePackages = game:GetService("CorePackages")
local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

return function(callback)
	return callback(urlBuilder.static.email.getSetEmail(), "GET")
end
