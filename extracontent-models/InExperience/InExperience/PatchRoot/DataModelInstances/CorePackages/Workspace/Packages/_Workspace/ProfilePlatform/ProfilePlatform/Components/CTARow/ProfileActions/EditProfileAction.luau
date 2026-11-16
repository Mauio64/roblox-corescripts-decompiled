local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local Foundation = require(parent.Foundation)
local SharedFlags = require(parent.SharedFlags)

local ButtonVariant = Foundation.Enums.ButtonVariant

local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local Enums = require(ProfilePlatform.Common.Enums)
require(ProfilePlatform.Components.CTARow.Types)
local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes

local FFlagMoveInExperienceModeToEditProfile = SharedFlags.FFlagMoveInExperienceModeToEditProfile
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

return {
	[Enums.ProfileActions.EditProfile] = function(data)
		return {
			variant = ButtonVariant.Standard,
			text = data.localized[Enums.ProfileActions.EditProfile],
			onActivated = {
				[ProfileTypes.User] = function()
					data.analytics.fireAnalyticsEvent(EventNames.CTAButtonOpenEditProfilePage, {
						buttonSurface = data.buttonSurface
					})

					local navigate = data.navigation.navigate
					local editProfilePage = Enums.Screens.EditProfilePage
					local fullBleed

					if FFlagAXEnableProfileTab then
						fullBleed = data.profileWrapperContext.forceFullView == true
					end

					navigate(editProfilePage, {
						fullBleed = fullBleed,
						navigateToEditUsername = function(showToast)
							data.navigateTo.editUsername({
								showToast = showToast,
								onUsernameChanged = function()
									data.dispatch(refreshProfilePlatformUserInfo(data.profileId))
								end
							})
						end,
						onIdentityChange = function()
							data.dispatch(refreshProfilePlatformUserInfo(data.profileId))
						end,
						onToggleInExperienceMode = FFlagMoveInExperienceModeToEditProfile and function()
							data.dispatch(refreshProfilePlatformUserInfo(data.profileId))
							data.analytics.fireAnalyticsEvent(EventNames.ToggleInExperienceModeButton, {})
						end or nil
					})
				end
			}
		}
	end
}
