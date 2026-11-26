local createUpdateProfileCustomization = require("@game/CorePackages/Workspace/Packages/_Index/ProfileCustomizationNetworking/ProfileCustomizationNetworking/networkRequests/createUpdateProfileCustomization")
local createGetProfileCustomization = require("@game/CorePackages/Workspace/Packages/_Index/ProfileCustomizationNetworking/ProfileCustomizationNetworking/networkRequests/createGetProfileCustomization")

return function(p2)
	return {
		UpdateProfileCustomization = createUpdateProfileCustomization(p2),
		GetProfileCustomization = createGetProfileCustomization(p2)
	}
end
