local networkRequests = script.Parent.networkRequests
local createUpdateProfileCustomization = require(networkRequests.createUpdateProfileCustomization)
local createGetProfileCustomization = require(networkRequests.createGetProfileCustomization)

return function(p)
	return {
		UpdateProfileCustomization = createUpdateProfileCustomization(p),
		GetProfileCustomization = createGetProfileCustomization(p)
	}
end
