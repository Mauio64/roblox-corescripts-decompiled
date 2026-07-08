local networkRequests = script.Parent.networkRequests
local createUpdateProfileCustomization = require(networkRequests.createUpdateProfileCustomization)
local createGetProfileCustomization = require(networkRequests.createGetProfileCustomization)

return function(t1: {[any]: any}) -- line: 6
	-- upvalues: createUpdateProfileCustomization (copy), createGetProfileCustomization (copy)
	return {
		UpdateProfileCustomization = createUpdateProfileCustomization(t1),
		GetProfileCustomization = createGetProfileCustomization(t1)
	}
end
