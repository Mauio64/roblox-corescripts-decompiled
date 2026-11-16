local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")

local buttonVariant = Foundation.Enums.ButtonVariant

local refreshProfilePlatformUserInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformUserInfo")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CTARow/Types")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local profileTypes = Enums.ProfileTypes

local fFlagMoveInExperienceModeToEditProfile = SharedFlags.FFlagMoveInExperienceModeToEditProfile
local fFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

return {
	[Enums.ProfileActions.EditProfile] = function(data)
		return {
			variant = buttonVariant.Standard,
			text = data.localized[Enums.ProfileActions.EditProfile],
			onActivated = {
				[profileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonOpenEditProfilePage, {
						buttonSurface = data.buttonSurface
					})

					local navigate = data.navigation.navigate
					local editProfilePage = Enums.Screens.EditProfilePage

					local v9 = if fFlagAXEnableProfileTab then data.profileWrapperContext.forceFullView == true else nil
					navigate(editProfilePage, {
						fullBleed = v9,
						navigateToEditUsername = function(p2)
							data.navigateTo.editUsername({
								showToast = p2,
								onUsernameChanged = function()
									data.dispatch(refreshProfilePlatformUserInfo(data.profileId))
								end
							})
						end,
						onIdentityChange = function()
							data.dispatch(refreshProfilePlatformUserInfo(data.profileId))
						end,
						onToggleInExperienceMode = fFlagMoveInExperienceModeToEditProfile and function()
							data.dispatch(refreshProfilePlatformUserInfo(data.profileId))
							data.analytics.fireAnalyticsEvent(EventNames.ToggleInExperienceModeButton, {})
						end or nil
					})
				end
			}
		}
	end
}
