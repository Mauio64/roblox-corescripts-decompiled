local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Foundation = require(ProfilePlatformParent.Foundation)
local SharedFlags = require(ProfilePlatformParent.SharedFlags)
local SocialStopwatch = require(ProfilePlatformParent.SocialStopwatch)
local ButtonVariant = Foundation.Enums.ButtonVariant
local refreshProfilePlatformUserInfo = require(ProfilePlatform.Networking.refreshProfilePlatformUserInfo)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatform.Components.CTARow.Types)

local EventNames = require(ProfilePlatform.Analytics.EventNames)
local ProfileTypes = Enums.ProfileTypes
local FFlagMoveInExperienceModeToEditProfile = SharedFlags.FFlagMoveInExperienceModeToEditProfile
local FFlagAXEnableProfileTab = SharedFlags.FFlagAXEnableProfileTab

return {
	[Enums.ProfileActions.EditProfile] = function(p1) -- line: 20
		-- upvalues: ButtonVariant (copy), Enums (copy), ProfileTypes (copy), SocialStopwatch (copy), EventNames (copy), FFlagAXEnableProfileTab (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy)
		return {
			variant = ButtonVariant.Standard,
			text = p1.localized[Enums.ProfileActions.EditProfile],
			onActivated = {
				[ProfileTypes.User] = function() -- line: 25
					-- upvalues: SocialStopwatch (copy), p1 (copy), EventNames (copy), Enums (copy), FFlagAXEnableProfileTab (copy), refreshProfilePlatformUserInfo (copy), FFlagMoveInExperienceModeToEditProfile (copy)
					SocialStopwatch.Stopwatch.start(SocialStopwatch.Events.EditProfileOpened)
					p1.analytics.fireAnalyticsEvent(EventNames.CTAButtonOpenEditProfilePage, {
						buttonSurface = p1.buttonSurface
					})
					p1.navigation.navigate(Enums.Screens.EditProfilePage, {
						profileScreens = Enums.Screens,
						fullBleed = if not FFlagAXEnableProfileTab then nil else p1.profileWrapperContext.forceFullView == true,
						navigateToEditUsername = function(p2) -- line: 39
							-- upvalues: p1 (copy), refreshProfilePlatformUserInfo (copy)
							p1.navigateTo.editUsername({
								showToast = p2,
								onUsernameChanged = function() -- line: 42
									-- upvalues: p1 (copy), refreshProfilePlatformUserInfo (copy)
									p1.dispatch(refreshProfilePlatformUserInfo(p1.profileId))
								end
							})
						end,
						onIdentityChange = function() -- line: 47
							-- upvalues: p1 (copy), refreshProfilePlatformUserInfo (copy)
							p1.dispatch(refreshProfilePlatformUserInfo(p1.profileId))
						end,
						onToggleInExperienceMode = if not FFlagMoveInExperienceModeToEditProfile then nil else function() -- line: 51
							-- upvalues: p1 (copy), refreshProfilePlatformUserInfo (copy), EventNames (copy)
							p1.dispatch(refreshProfilePlatformUserInfo(p1.profileId))
							p1.analytics.fireAnalyticsEvent(EventNames.ToggleInExperienceModeButton, {})
						end
					})
				end
			}
		}
	end
}
