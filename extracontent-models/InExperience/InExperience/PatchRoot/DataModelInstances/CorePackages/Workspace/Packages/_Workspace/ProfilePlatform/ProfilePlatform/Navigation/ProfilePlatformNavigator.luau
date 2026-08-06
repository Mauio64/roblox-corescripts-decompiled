local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local Enums = require(ProfilePlatform.Common.Enums)
local SetAlias = require(ProfilePlatformParent.SetAlias)
local ProfileContextualMenu = require(ProfilePlatform.Components.ProfileContextualMenu)
local EditProfilePage = require(ProfilePlatformParent.EditProfile.EditProfilePage)
local EditProfileLanding = require(ProfilePlatformParent.EditProfile.EditProfileLanding)
local EditDisplayNameModal = require(ProfilePlatformParent.EditProfile.EditDisplayNameModal)
local EditDisplayNameErrorModal = require(ProfilePlatformParent.EditProfile.EditDisplayNameErrorModal)
local UsernameInsufficientFundsModal = require(ProfilePlatformParent.EditProfile.UsernameInsufficientFundsModal)
local EditDescriptionModal = require(ProfilePlatformParent.EditProfile.EditDescriptionModal)
local Enums2 = require(ProfilePlatformParent.EditProfile.Enums)
local ProfilePlatformViewAdaptor = require(ProfilePlatform.Components.ProfilePlatformViewAdaptor)
local VideoFullscreenPage = require(ProfilePlatform.Components.Videos.VideoFullscreenPage)
local SetAliasModal = SetAlias.SetAliasModal
local EditProfileScreenViewAdapter = require(ProfilePlatformParent.EditProfile.EditProfileScreenViewAdapter)
local EditProfileToastScreen = require(ProfilePlatformParent.EditProfile.EditProfileToastScreen)
local EditProfileBackgroundContainer = require(ProfilePlatform.Components.EditProfileBackgroundContainer)
local CommunityVerificationModal = require(ProfilePlatform.Components.CommunityVerificationModal)
local InspectAvatarSheetContainer = require(ProfilePlatform.Components.InspectAvatar.InspectAvatarSheetContainer)
local PurchaseConfirmationModal = require(ProfilePlatform.Components.InspectAvatar.PurchaseConfirmationModal)
local InsufficientRobuxDialog = require(ProfilePlatform.Components.InspectAvatar.InsufficientRobuxDialog)
local MomentsGridPage = require(ProfilePlatform.Components.Moments.MomentsGridPage)
local MomentsFeedPage = require(ProfilePlatform.Components.Moments.MomentsFeedPage)
local FFlagSocialEnableProfileInspectAndBuy = require(ProfilePlatformParent.SharedFlags).FFlagSocialEnableProfileInspectAndBuy
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)
local RoactNavigation = require(ProfilePlatformParent.RoactNavigation)
local FFlagAddVideoToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddVideoToCommunityProfile
local FFlagEditProfileBackgroundEnabled = require(ProfilePlatformParent.SharedFlags).FFlagEditProfileBackgroundEnabled
local FFlagEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagEnableCommunityVerificationModal)
local FFlagEditProfileMigration = require(ProfilePlatformParent.EditProfile.Flags).FFlagEditProfileMigration
local FFlagAXEnableProfileTab = require(ProfilePlatformParent.SharedFlags).FFlagAXEnableProfileTab
local t1 = {
	overlayEnabled = true,
	overlayTransparency = 0.5,
	absorbInput = true
}
local t2 = {
	overlayEnabled = false,
	absorbInput = true,
	renderUnderlyingPage = true
}

local function makeFullBleedNavigationOptions(t3: {[any]: any}) -- line: 56
	-- upvalues: t2 (copy)
	return function(p1) -- line: 57
		-- upvalues: t2 (copy), t3 (copy)
		if p1.navigation.getParam("fullBleed") then
			return t2
		end

		return t3
	end
end

local t4 = {
	{
		[Enums.Screens.ProfileMain] = ProfilePlatformViewAdaptor
	},
	{
		[Enums.Screens.EditProfilePage] = {
			screen = if not FFlagEditProfileMigration then EditProfilePage else EditProfileLanding,
			navigationOptions = if not FFlagAXEnableProfileTab then t1 else function(p2) -- line: 57
				-- upvalues: t2 (copy), t1 (copy)
				if p2.navigation.getParam("fullBleed") then
					return t2
				end

				return t1
			end
		}
	},
	{
		[Enums.Screens.EditDisplayNameModal] = {
			screen = EditDisplayNameModal,
			navigationOptions = t1
		}
	},
	{
		[Enums.Screens.EditDescriptionModal] = {
			screen = EditDescriptionModal,
			navigationOptions = t1
		}
	},
	{
		[Enums.Screens.EditDisplayNameErrorModal] = {
			screen = EditDisplayNameErrorModal,
			navigationOptions = t1
		}
	},
	{
		[Enums.Screens.UsernameInsufficientFundsModal] = {
			screen = UsernameInsufficientFundsModal,
			navigationOptions = t1
		}
	},
	{
		[Enums.Screens.SetAliasModal] = {
			screen = SetAliasModal,
			navigationOptions = t1
		}
	},
	{
		[Enums.Screens.ContextualMenu] = {
			screen = ProfileContextualMenu,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = false
			}
		}
	}
}

if FFlagAddVideoToCommunityProfile then
	table.insert(t4, {
		[Enums.Screens.VideoFullscreen] = {
			screen = VideoFullscreenPage,
			navigationOptions = t1
		}
	})
end

if FFlagEnableCommunityVerificationModal then
	table.insert(t4, {
		[Enums.Screens.CommunityVerificationModal] = {
			screen = CommunityVerificationModal,
			navigationOptions = t1
		}
	})
end

if FFlagEditProfileBackgroundEnabled then
	table.insert(t4, {
		[Enums.Screens.EditProfileBackground] = {
			screen = EditProfileBackgroundContainer,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true,
				renderUnderlyingPage = true
			}
		}
	})
end

if FFlagEditProfileMigration then
	local t5 = {}
	local EditProfileSubScreen = Enums2.Screens.EditProfileSubScreen
	local t6 = {
		screen = EditProfileScreenViewAdapter
	}
	local t8

	if FFlagAXEnableProfileTab then
		local t7 = {
			overlayEnabled = true,
			overlayTransparency = 0.5,
			absorbInput = false
		}

		function t8(p3) -- line: 57
			-- upvalues: t2 (copy), t7 (copy)
			if p3.navigation.getParam("fullBleed") then
				return t2
			end

			return t7
		end
	else
		t8 = {
			overlayEnabled = true,
			overlayTransparency = 0.5,
			absorbInput = false
		}
	end

	t6.navigationOptions = t8
	t5[EditProfileSubScreen] = t6
	table.insert(t4, t5)
	table.insert(t4, {
		[Enums2.Screens.EditProfileToast] = {
			screen = EditProfileToastScreen,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = false
			}
		}
	})
end

if FFlagSocialEnableProfileInspectAndBuy then
	table.insert(t4, {
		[Enums.Screens.InspectAvatarSheet] = {
			screen = InspectAvatarSheetContainer,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = true
			}
		}
	})
	table.insert(t4, {
		[Enums.Screens.PurchaseConfirmationModal] = {
			screen = PurchaseConfirmationModal,
			navigationOptions = t1
		}
	})
	table.insert(t4, {
		[Enums.Screens.InsufficientRobuxDialog] = {
			screen = InsufficientRobuxDialog,
			navigationOptions = t1
		}
	})
end

if FFlagProfilePlatformEnableMoments then
	table.insert(t4, {
		[Enums.Screens.MomentsAll] = {
			screen = MomentsGridPage,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true,
				renderUnderlyingPage = true
			}
		}
	})
	table.insert(t4, {
		[Enums.Screens.MomentsFeed] = {
			screen = MomentsFeedPage,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true
			}
		}
	})
end

return (RoactNavigation.createRobloxStackNavigator(t4, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = true,
		overlayTransparency = 1,
		disableBackButton = true
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
}))
