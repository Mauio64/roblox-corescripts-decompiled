local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/dVn")
local module2 = require("@luauforge/bundled/dzO")
local t = require(CorePackages.Packages.t)
local module3 = require("@luauforge/deferred/hWu")

local tuple = t.tuple(t.callback, t.integer, module3.PurchaseDetail)

return function(callback, p2, p3)
	module2.assert(tuple(callback, p2, p3))

	return callback(("%sv1/purchases/products/%i"):format(module.ECONOMY_URL, p2), "POST", {
		postBody = HttpService:JSONEncode(p3)
	})
end
