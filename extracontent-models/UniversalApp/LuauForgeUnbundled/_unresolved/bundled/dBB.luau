local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
return Rodux.makeActionCreator("SetSubscriptionProductsThumbnails", function(p2)
	return { subscriptionProductsThumbnails = p2 }
end)
