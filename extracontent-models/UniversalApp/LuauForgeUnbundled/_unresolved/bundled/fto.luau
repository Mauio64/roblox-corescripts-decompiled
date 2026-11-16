local module = require("@luauforge/bundled/fsq")
require("@game/CorePackages/Workspace/Packages/Http")

return function(callback)
	return callback(module.economy.vngPayments.getVngShopUrl(), "GET")
end
