local fFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnablePlatformProfileContextualMenuOption

local getPlatformFriendsService = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Utils/getPlatformFriendsService")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

return {
	[Enums.ProfileActions.ViewPlatformProfile] = fFlagEnablePlatformProfileContextualMenuOption and function(data)
		local profilePlatformId = data.profileWrapperContext.profilePlatformId

		if not profilePlatformId or profilePlatformId == "" then
			return nil
		end

		return {
			text = data.localized[Enums.ProfileActions.ViewPlatformProfile],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.ContextualMenuButtonViewPlatformProfile, {
						buttonSurface = data.buttonSurface
					})

					getPlatformFriendsService:ShowProfile(data.profileWrapperContext.profilePlatformId)
				end
			}
		}
	end or nil
}
