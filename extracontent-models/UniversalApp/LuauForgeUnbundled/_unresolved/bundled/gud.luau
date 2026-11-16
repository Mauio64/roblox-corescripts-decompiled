local urlBuilder = require("@luauforge/bundled/gue").UrlBuilder
local urlBase = require("@luauforge/bundled/gue").UrlBase

local module = require("@luauforge/bundled/guf")
require("@luauforge/bundled/gua")

local v5 = urlBuilder.new({
	base = urlBase.APIS,
	path = "roblox-subscriptions/v1/roblox-plus/benefits"
})

return function(p2)
	return (p2 or module.new()):get(v5())
end
