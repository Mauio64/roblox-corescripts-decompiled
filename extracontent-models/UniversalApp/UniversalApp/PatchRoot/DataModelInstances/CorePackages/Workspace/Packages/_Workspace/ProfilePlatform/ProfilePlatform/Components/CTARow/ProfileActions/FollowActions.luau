local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local ButtonVariant = require(ProfilePlatformParent.Foundation).Enums.ButtonVariant
local GroupsNetworking = require(ProfilePlatform.Networking.GroupsNetworking)
local getProfilePlatform = require(ProfilePlatform.Networking.getProfilePlatform)
local getAvailableCommunityComponents = require(ProfilePlatform.Hooks.getAvailableCommunityComponents)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagProfilePlatformUpdateUXForNonSocialCommunities = require(ProfilePlatform.Flags.FFlagProfilePlatformUpdateUXForNonSocialCommunities)

return {
	[Enums.ProfileActions.Follow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else function(p1) -- line: 21
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
		return {
			variant = ButtonVariant.Standard,
			text = p1.localized[Enums.ProfileActions.Follow],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 26
					-- upvalues: p1 (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonFollow, {
						buttonSurface = p1.buttonSurface
					})

					return p1.dispatch(GroupsNetworking.JoinGroup.API({
						groupId = p1.profileId
					})):andThen(function() -- line: 34
						-- upvalues: p1 (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
						p1.dispatch(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = p1.profileType,
							profileId = p1.profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			}
		}
	end,
	[Enums.ProfileActions.Unfollow] = if not FFlagProfilePlatformUpdateUXForNonSocialCommunities then nil else function(p2) -- line: 49
		-- upvalues: Enums (copy), ProfileTypes (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
		return {
			text = p2.localized[Enums.ProfileActions.Unfollow],
			onActivated = {
				[ProfileTypes.Community] = function() -- line: 53
					-- upvalues: p2 (copy), EventNames (copy), GroupsNetworking (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
					p2.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonUnfollow, {
						buttonSurface = p2.buttonSurface
					})

					return p2.dispatch(GroupsNetworking.LeaveGroup.API({
						groupId = p2.profileId,
						userId = p2.localUserId
					})):andThen(function() -- line: 63
						-- upvalues: p2 (copy), getProfilePlatform (copy), getAvailableCommunityComponents (copy)
						p2.dispatch(getProfilePlatform.API({
							includeComponentOrdering = true,
							profileType = p2.profileType,
							profileId = p2.profileId,
							components = getAvailableCommunityComponents()
						}))
					end)
				end
			}
		}
	end
}
