local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local myRoduxNetworking = require(ProfilePlatform.Networking.myRoduxNetworking)
local parent = ProfilePlatform.Parent
local Http = require(parent.Http)
require(ProfilePlatform.Common.Enums)

local FFlagProfilePlatformEnableLazyLoadingComponents = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableLazyLoadingComponents)
require(parent.SocialCommon)

require(ProfilePlatform.Types.Component)

return myRoduxNetworking.POST("GetProfile", function(callback, data)
	local path = callback(Http.Url.APIS_URL .. "profile-platform-api"):path("v1"):path("profiles"):path("get")
	local v = {
		profileType = data.profileType,
		profileId = data.profileId,
		components = data.components,
		includeComponentOrdering = data.includeComponentOrdering,
		onlyEssentialComponents = 0
	}
	local onlyEssentialComponents

	if FFlagProfilePlatformEnableLazyLoadingComponents then
		onlyEssentialComponents = data.onlyEssentialComponents
	end

	v.onlyEssentialComponents = onlyEssentialComponents
	return path:body(v)
end)
