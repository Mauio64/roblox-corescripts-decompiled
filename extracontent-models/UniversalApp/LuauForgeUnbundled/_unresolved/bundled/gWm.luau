local urlBuilder = require("@luauforge/bundled/gWj").UrlBuilder
local urlBase = require("@luauforge/bundled/gWj").UrlBase

local module = require("@luauforge/bundled/gWk")
require("@luauforge/bundled/gWf")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "subscriptions/v2/referral-links"
})

return function(p2)
	return (p2 or module.new()):post(v5(), {})
end
