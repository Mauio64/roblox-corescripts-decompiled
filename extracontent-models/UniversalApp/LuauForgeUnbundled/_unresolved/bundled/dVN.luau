local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local module = require("@luauforge/bundled/dzP")

return Rodux.makeActionCreator("SetResellerCursor", function(p2)
	module.isTypeOrNil(p2, "string", "cursor")

	return { cursor = p2 }
end)
