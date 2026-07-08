local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent

require(ProfilePlatform.Types.Component)

local Enums = require(ProfilePlatform.Common.Enums)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)
local FFlagAddSocialLinksToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddSocialLinksToCommunityProfile
local FFlagAddVideoToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddVideoToCommunityProfile
local FFlagAddCommunityLockedToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddCommunityLockedToCommunityProfile
local FFlagAddEventsToCommunityProfile = require(ProfilePlatform.Flags.FFlagAddEventsToCommunityProfile)
local FFlagProfilePlatformCTAsRefactor = require(ProfilePlatform.Flags.FFlagProfilePlatformCTAsRefactor)

return function() -- line: 14
	-- upvalues: Enums (copy), FFlagProfilePlatformCTAsRefactor (copy), getSupportedActionsForProfileType (copy), FFlagAddSocialLinksToCommunityProfile (copy), FFlagAddVideoToCommunityProfile (copy), FFlagAddCommunityLockedToCommunityProfile (copy), FFlagAddEventsToCommunityProfile (copy)
	local t1 = {
		{
			component = Enums.Components.CommunityProfileHeader
		},
		{
			component = Enums.Components.About
		},
		{
			component = Enums.Components.Actions,
			supportedActions = if not FFlagProfilePlatformCTAsRefactor then nil else getSupportedActionsForProfileType(Enums.ProfileTypes.Community),
			isActionsV2Supported = not not FFlagProfilePlatformCTAsRefactor or nil
		},
		{
			component = Enums.Components.Experiences
		},
		{
			component = Enums.Components.Store
		},
		{
			component = Enums.Components.ViewFullProfile
		},
		{
			component = Enums.Components.CoverPhoto
		}
	}

	if FFlagAddSocialLinksToCommunityProfile then
		table.insert(t1, {
			component = Enums.Components.SocialLinks
		})
	end

	if FFlagAddVideoToCommunityProfile then
		table.insert(t1, {
			component = Enums.Components.Videos
		})
	end

	if FFlagAddCommunityLockedToCommunityProfile then
		table.insert(t1, {
			component = Enums.Components.CommunityLocked
		})
	end

	if FFlagAddEventsToCommunityProfile then
		table.insert(t1, {
			component = Enums.Components.Events
		})
	end

	return t1
end
