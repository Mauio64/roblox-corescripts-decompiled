local myRoduxNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/myRoduxNetworking")

local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Http")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")

local FFlagProfilePlatformEnableLazyLoadingComponents = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableLazyLoadingComponents")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SocialCommon")

require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")

return myRoduxNetworking.POST("GetProfile", function(callback, data)
	local path = callback(Http.Url.APIS_URL .. "profile-platform-api"):path("v1"):path("profiles"):path("get")
	local v5 = {
		profileType = data.profileType,
		profileId = data.profileId,
		components = data.components,
		includeComponentOrdering = data.includeComponentOrdering,
		onlyEssentialComponents = 0
	}

	local v6 = if FFlagProfilePlatformEnableLazyLoadingComponents then data.onlyEssentialComponents else nil
	v5.onlyEssentialComponents = v6
	return path:body(v5)
end)
