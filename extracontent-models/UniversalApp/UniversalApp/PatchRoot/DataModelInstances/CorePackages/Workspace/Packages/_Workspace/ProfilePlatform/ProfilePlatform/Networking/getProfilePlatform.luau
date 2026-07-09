local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local ProfilePlatformParent = ProfilePlatform.Parent
local Http = require(ProfilePlatformParent.Http)

require(ProfilePlatform.Common.Enums)

local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)

require(ProfilePlatformParent.SocialCommon)
require(ProfilePlatform.Types.Component)

return myRoduxNetworking.POST({
	Name = "GetProfile"
}, function(p1, t1: {[any]: any}) -- line: 27
	-- upvalues: Http (copy), FFlagProfilePlatformEnableLazyLoadingComponents (copy)
	return p1(Http.Url.APIS_URL .. "profile-platform-api"):path("v1"):path("profiles"):path("get"):body({
		profileType = t1.profileType,
		profileId = t1.profileId,
		components = t1.components,
		includeComponentOrdering = t1.includeComponentOrdering,
		onlyEssentialComponents = if not FFlagProfilePlatformEnableLazyLoadingComponents then nil else t1.onlyEssentialComponents
	})
end)
