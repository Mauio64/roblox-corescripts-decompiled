local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)

local viewerRelationshipUtils = require(ProfilePlatform.Components.ProfilePlatformPage.viewerRelationshipUtils)

local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)

return function()
	local v = useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}
	local viewerRelationship = v.viewerRelationship
	local contextualInformation = v.contextualInformation
	return viewerRelationshipUtils.mapViewerRelationshipAndContextToAnalyticsFriendStatus(
		viewerRelationship,
		contextualInformation
	)
end
