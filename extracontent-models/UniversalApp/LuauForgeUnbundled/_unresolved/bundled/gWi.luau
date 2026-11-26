local urlBuilder = require("@luauforge/bundled/gWj").UrlBuilder
local urlBase = require("@luauforge/bundled/gWj").UrlBase

local module = require("@luauforge/bundled/gWk")
require("@luauforge/bundled/gWf")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "roblox-subscriptions/v1/roblox-plus/benefits"
})

return function(p2)
	return (p2 or module.new()):get(v5())
end
