local urlBuilder = require("@luauforge/bundled/gue").UrlBuilder
local urlBase = require("@luauforge/bundled/gue").UrlBase

local module = require("@luauforge/bundled/guf")
require("@luauforge/bundled/gua")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "subscriptions/v2/referral-links"
})

return function(p2)
	return (p2 or module.new()):post(v5(), {})
end
