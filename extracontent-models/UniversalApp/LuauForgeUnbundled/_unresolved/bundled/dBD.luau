local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

require("@luauforge/bundled/dBE")

return makeActionCreator("SetSubscriptionStatuses", function(p2)
	return { subscriptionStatuses = p2 }
end)
