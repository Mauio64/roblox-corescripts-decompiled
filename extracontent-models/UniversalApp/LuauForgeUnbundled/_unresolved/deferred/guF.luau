local module = require("@luauforge/bundled/fsq")
require("@game/CorePackages/Workspace/Packages/Http")

local module2 = require("@luauforge/deferred/guG")

return function(callback, p2, p3, p4)
	local v5 = if module2() then module.economy.purchaseWarning.getPurchaseWarning(p2, p3, p4 == false) else module.economy.purchaseWarning.getPurchaseWarning(p2)

	return callback(v5, "GET")
end
