local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local SharedFlags = require(parent.SharedFlags)
local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags.FFlagEnablePlatformProfileContextualMenuOption

local getPlatformFriendsService = require(ProfilePlatform.Utils.getPlatformFriendsService)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.ViewPlatformProfile] = FFlagEnablePlatformProfileContextualMenuOption and function(data)
		local profilePlatformId = data.profileWrapperContext.profilePlatformId

		if not profilePlatformId or profilePlatformId == "" then
			return nil
		end

		return {
			text = data.localized[Enums.ProfileActions.ViewPlatformProfile],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonViewPlatformProfile, {
						buttonSurface = data.buttonSurface
					})

					getPlatformFriendsService:ShowProfile(data.profileWrapperContext.profilePlatformId)
				end
			}
		}
	end or nil
}
