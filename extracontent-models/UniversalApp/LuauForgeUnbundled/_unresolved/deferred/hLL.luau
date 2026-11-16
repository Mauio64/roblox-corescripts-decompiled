local CorePackages = game:GetService("CorePackages")
local HttpService = game:GetService("HttpService")

local Url = require("@game/CoreGui/RobloxGui/Modules/InGameMenu/Network/Url")
local module2 = require("@luauforge/bundled/dwL")
local t = require(CorePackages.Packages.t)
local module3 = require("@luauforge/deferred/hLM")

local tuple = t.tuple(t.callback, t.integer, module3.PurchaseDetail)

return function(callback, p2, p3)
	module2.assert(tuple(callback, p2, p3))

	return callback(("%sv1/purchases/products/%i"):format(Url.ECONOMY_URL, p2), "POST", {
		postBody = HttpService:JSONEncode(p3)
	})
end
