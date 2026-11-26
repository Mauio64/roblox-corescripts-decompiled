local HttpService = game:GetService("HttpService")

local module = require("@luauforge/bundled/fzK")
require("@game/CorePackages/Workspace/Packages/Http")

return function(callback, p2)
	return callback(module.economy.purchaseWarning.ackPurchaseWarning(), "POST", {
		postBody = HttpService:JSONEncode({ acknowledgement = p2 })
	})
end
