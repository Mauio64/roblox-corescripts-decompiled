local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local Enums = require(ProfilePlatform.Common.Enums)
local convertPrimaryActionToFriendStatus = require(ProfilePlatform.Hooks.convertPrimaryActionToFriendStatus)
local viewerRelationshipUtils = require(ProfilePlatform.Components.ProfilePlatformPage.viewerRelationshipUtils)
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local FFlagProfilePlatformUseViewerRelationshipForSocialState = require(ProfilePlatform.Flags.FFlagProfilePlatformUseViewerRelationshipForSocialState)

return function() -- line: 12
	-- upvalues: useProfileJsonComponent (copy), Enums (copy), FFlagProfilePlatformUseViewerRelationshipForSocialState (copy), viewerRelationshipUtils (copy), convertPrimaryActionToFriendStatus (copy)
	local v7 = useProfileJsonComponent(Enums.Components.UserProfileHeader) or {}

	if FFlagProfilePlatformUseViewerRelationshipForSocialState then
		local viewerRelationship = v7.viewerRelationship
		local contextualInformation = v7.contextualInformation

		return viewerRelationshipUtils.mapViewerRelationshipAndContextToAnalyticsFriendStatus(viewerRelationship, contextualInformation)
	end

	local buttons = useProfileJsonComponent(Enums.Components.Actions).buttons
	local v11 = if not buttons or not buttons[1] then nil else buttons[1].type

	return convertPrimaryActionToFriendStatus(v11)
end
