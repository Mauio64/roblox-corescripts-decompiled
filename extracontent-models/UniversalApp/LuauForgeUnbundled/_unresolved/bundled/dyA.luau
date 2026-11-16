local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

require("@luauforge/bundled/dyB")

return makeActionCreator("SetSubscriptionStatuses", function(p2)
	return { subscriptionStatuses = p2 }
end)
