local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

require(ProfilePlatform.Types.Component)
local Enums = require(ProfilePlatform.Common.Enums)
local getSupportedActionsForProfileType = require(ProfilePlatform.Hooks.getSupportedActionsForProfileType)
local SharedFlags = require(parent.SharedFlags)
local FFlagAddSocialLinksToCommunityProfile = SharedFlags.FFlagAddSocialLinksToCommunityProfile

local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddCommunityLockedToCommunityProfile = SharedFlags2.FFlagAddCommunityLockedToCommunityProfile
local FFlagAddEventsToCommunityProfile = require(ProfilePlatform.Flags.FFlagAddEventsToCommunityProfile)
local FFlagHideLeaveFromOpenCommunityOwner = require(ProfilePlatform.Flags.FFlagHideLeaveFromOpenCommunityOwner)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagGroupAnnouncementsSdui = SharedFlags3.FFlagGroupAnnouncementsSdui
local SharedFlags4 = require(parent.SharedFlags)
local FFlagGroupForumsDiscoverySdui = SharedFlags4.FFlagGroupForumsDiscoverySdui

return function()
	local v = {
		{ component = Enums.Components.CommunityProfileHeader },
		{ component = Enums.Components.About },
		{
			component = Enums.Components.Actions,
			supportedActions = getSupportedActionsForProfileType(Enums.ProfileTypes.Community),
			isActionsV2Supported = true
		},
		{ component = Enums.Components.Experiences },
		{ component = Enums.Components.Store },
		{ component = Enums.Components.ViewFullProfile },
		{ component = Enums.Components.CoverPhoto }
	}

	if FFlagAddSocialLinksToCommunityProfile then
		table.insert(v, { component = Enums.Components.SocialLinks })
	end

	if FFlagAddCommunityLockedToCommunityProfile then
		table.insert(v, { component = Enums.Components.CommunityLocked })
	end

	if FFlagHideLeaveFromOpenCommunityOwner then
		table.insert(v, { component = Enums.Components.CommunityDeactivated })
	end

	if FFlagAddEventsToCommunityProfile then
		table.insert(v, { component = Enums.Components.Events })
	end

	if FFlagGroupAnnouncementsSdui then
		table.insert(v, { component = Enums.Components.Announcements })
	end

	if FFlagGroupForumsDiscoverySdui then
		table.insert(v, { component = Enums.Components.GroupForumsDiscovery })
	end

	return v
end
