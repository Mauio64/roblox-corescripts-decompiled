require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Types/Component")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local getSupportedActionsForProfileType = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/getSupportedActionsForProfileType")
local fFlagAddSocialLinksToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddSocialLinksToCommunityProfile

local fFlagAddCommunityLockedToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddCommunityLockedToCommunityProfile
local FFlagAddEventsToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagAddEventsToCommunityProfile")
local FFlagHideLeaveFromOpenCommunityOwner = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagHideLeaveFromOpenCommunityOwner")
local fFlagGroupAnnouncementsSdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagGroupAnnouncementsSdui
local fFlagGroupForumsDiscoverySdui = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagGroupForumsDiscoverySdui

return function()
	local v5 = {
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

	if fFlagAddSocialLinksToCommunityProfile then
		table.insert(v5, { component = Enums.Components.SocialLinks })
	end

	if fFlagAddCommunityLockedToCommunityProfile then
		table.insert(v5, { component = Enums.Components.CommunityLocked })
	end

	if FFlagHideLeaveFromOpenCommunityOwner then
		table.insert(v5, { component = Enums.Components.CommunityDeactivated })
	end

	if FFlagAddEventsToCommunityProfile then
		table.insert(v5, { component = Enums.Components.Events })
	end

	if fFlagGroupAnnouncementsSdui then
		table.insert(v5, { component = Enums.Components.Announcements })
	end

	if fFlagGroupForumsDiscoverySdui then
		table.insert(v5, { component = Enums.Components.GroupForumsDiscovery })
	end

	return v5
end
