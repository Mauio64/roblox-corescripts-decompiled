local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fsq")
require("@game/CorePackages/Workspace/Packages/Http")

return function(callback)
	return callback(module.economy.paymentsGateway.checkUserPurchaseSettings(), "POST", {
		postBody = HttpService:JSONEncode({}),
		headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	})
end
