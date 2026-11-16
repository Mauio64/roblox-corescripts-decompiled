local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local Enums = require(ProfilePlatform.Common.Enums)
local SetAlias = require(parent.SetAlias)
local ProfileContextualMenu = require(ProfilePlatform.Components.ProfileContextualMenu)
local EditProfileLanding = require(parent.EditProfile.EditProfileLanding)
local EditDisplayNameErrorModal = require(parent.EditProfile.EditDisplayNameErrorModal)
local UsernameInsufficientFundsModal = require(parent.EditProfile.UsernameInsufficientFundsModal)
local Enums2 = require(parent.EditProfile.Enums)
local ProfilePlatformViewAdaptor = require(ProfilePlatform.Components.ProfilePlatformViewAdaptor)
local SetAliasModal = SetAlias.SetAliasModal
local EditProfileScreenViewAdapter = require(parent.EditProfile.EditProfileScreenViewAdapter)
local EditProfileToastScreen = require(parent.EditProfile.EditProfileToastScreen)
local EditProfileBackgroundContainer = require(ProfilePlatform.Components.EditProfileBackgroundContainer)
local CommunityVerificationModal = require(ProfilePlatform.Components.CommunityVerificationModal)
local InspectAvatarSheetContainer = require(ProfilePlatform.Components.InspectAvatar.InspectAvatarSheetContainer)
local PurchaseConfirmationModal = require(ProfilePlatform.Components.InspectAvatar.PurchaseConfirmationModal)
local InsufficientRobuxDialog = require(ProfilePlatform.Components.InspectAvatar.InsufficientRobuxDialog)
local MomentsGridPage = require(ProfilePlatform.Components.Moments.MomentsGridPage)
local MomentsFeedPage = require(ProfilePlatform.Components.Moments.MomentsFeedPage)
local SharedFlags = require(parent.SharedFlags)
local FFlagSocialEnableProfileInspectAndBuy = SharedFlags.FFlagSocialEnableProfileInspectAndBuy
local FFlagProfilePlatformEnableMoments = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableMoments)

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagEditProfileBackgroundEnabled = SharedFlags2.FFlagEditProfileBackgroundEnabled
local FFlagEnableCommunityVerificationModal = require(ProfilePlatform.Flags.FFlagEnableCommunityVerificationModal)
local SharedFlags3 = require(parent.SharedFlags)
local FFlagEditProfileImageV2Enabled = SharedFlags3.FFlagEditProfileImageV2Enabled
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAXEnableProfileTab = SharedFlags4.FFlagAXEnableProfileTab
local SharedFlags5 = require(parent.SharedFlags)
local FFlagAXHideBottomNavForEditProfileImage = SharedFlags5.FFlagAXHideBottomNavForEditProfileImage
local SharedFlags6 = require(parent.SharedFlags)
local FFlagEnableBottomNavOnMarketplace = SharedFlags6.FFlagEnableBottomNavOnMarketplace
local SharedFlags7 = require(parent.SharedFlags)
local FFlagAXSaveManagerOutsideAX = SharedFlags7.FFlagAXSaveManagerOutsideAX

local navigationOptions = { overlayEnabled = true, overlayTransparency = 0.5, absorbInput = true }

local v = { overlayEnabled = false, absorbInput = true, renderUnderlyingPage = true }

local function makeFullBleedNavigationOptions(p, p2) -- 1 equivalent call inferred from this helper
	local v2 = p2 or v
	return function(p3)
		return if p3.navigation.getParam("fullBleed") then v2 else p
	end
end

local function LazyEditProfileImageContainer(p)
	local EditProfileImageContainer = require(ProfilePlatform.Components.EditProfileImage.EditProfileImageContainer)
	return React.createElement(EditProfileImageContainer, p)
end

local v2 = {
	{ [Enums.Screens.ProfileMain] = ProfilePlatformViewAdaptor },
	{
		[Enums.Screens.EditProfilePage] = {
			screen = EditProfileLanding,
			navigationOptions = FFlagAXEnableProfileTab and function(p)
				if p.navigation.getParam("fullBleed") then
					return v
				end

				return navigationOptions
			end or navigationOptions
		}
	},
	{
		[Enums.Screens.EditDisplayNameErrorModal] = {
			screen = EditDisplayNameErrorModal,
			navigationOptions = navigationOptions
		}
	},
	{
		[Enums.Screens.UsernameInsufficientFundsModal] = {
			screen = UsernameInsufficientFundsModal,
			navigationOptions = navigationOptions
		}
	},
	{
		[Enums.Screens.SetAliasModal] = {
			screen = SetAliasModal,
			navigationOptions = navigationOptions
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

if FFlagEnableCommunityVerificationModal then
	local v3 = {
		[Enums.Screens.CommunityVerificationModal] = {
			screen = CommunityVerificationModal,
			navigationOptions = navigationOptions
		}
	}
	table.insert(v2, v3)
end

if FFlagEditProfileBackgroundEnabled then
	local v3 = {
		[Enums.Screens.EditProfileBackground] = {
			screen = EditProfileBackgroundContainer,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true,
				renderUnderlyingPage = true
			}
		}
	}
	table.insert(v2, v3)
end

local EditProfileSubScreen = Enums2.Screens.EditProfileSubScreen
local navigationOptions2

if FFlagAXEnableProfileTab then
	local v3 = { overlayEnabled = true, overlayTransparency = 0.5, absorbInput = false }

	navigationOptions2 = function(p)
		return if p.navigation.getParam("fullBleed") then v else v3
	end
else
	navigationOptions2 = { overlayEnabled = true, overlayTransparency = 0.5, absorbInput = false }
end

local v3 = {
	[EditProfileSubScreen] = {
		screen = EditProfileScreenViewAdapter,
		navigationOptions = navigationOptions2
	}
}
table.insert(v2, v3)

local v4 = {
	[Enums2.Screens.EditProfileToast] = {
		screen = EditProfileToastScreen,
		navigationOptions = { overlayEnabled = true, overlayTransparency = 1, absorbInput = false }
	}
}
table.insert(v2, v4)

if FFlagEditProfileImageV2Enabled then
	local tabBarVisible

	if FFlagAXHideBottomNavForEditProfileImage and FFlagEnableBottomNavOnMarketplace then
		tabBarVisible = false
	end

	local v5 = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = true,
		tabBarVisible = tabBarVisible
	}

	local v6 = {
		overlayEnabled = false,
		absorbInput = true,
		renderUnderlyingPage = true,
		tabBarVisible = tabBarVisible
	}

	local editProfileImageProfilePlatform = Enums2.Screens.EditProfileImageProfilePlatform
	local v7 = {
		screen = LazyEditProfileImageContainer,
		params = FFlagAXSaveManagerOutsideAX and { runAvatarSaveManager = true } or nil,
		navigationOptions = 0
	}
	local navigationOptions3

	if FFlagAXEnableProfileTab then
		navigationOptions3 = makeFullBleedNavigationOptions(v5, v6) -- inferred equivalent call
	else
		navigationOptions3 = v5
	end

	v7.navigationOptions = navigationOptions3
	local v8 = { [editProfileImageProfilePlatform] = v7 }
	table.insert(v2, v8)
end

if FFlagSocialEnableProfileInspectAndBuy then
	local v5 = {
		[Enums.Screens.InspectAvatarSheet] = {
			screen = InspectAvatarSheetContainer,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = true
			}
		}
	}
	table.insert(v2, v5)

	local v6 = {
		[Enums.Screens.PurchaseConfirmationModal] = {
			screen = PurchaseConfirmationModal,
			navigationOptions = navigationOptions
		}
	}
	table.insert(v2, v6)

	local v7 = {
		[Enums.Screens.InsufficientRobuxDialog] = {
			screen = InsufficientRobuxDialog,
			navigationOptions = navigationOptions
		}
	}
	table.insert(v2, v7)
end

if FFlagProfilePlatformEnableMoments then
	local v5 = {
		[Enums.Screens.MomentsAll] = {
			screen = MomentsGridPage,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true,
				renderUnderlyingPage = true
			}
		}
	}
	table.insert(v2, v5)

	local v6 = {
		[Enums.Screens.MomentsFeed] = {
			screen = MomentsFeedPage,
			navigationOptions = { overlayEnabled = false, absorbInput = true }
		}
	}
	table.insert(v2, v6)
end

return (RoactNavigation.createRobloxStackNavigator(v2, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = true,
		overlayTransparency = 1,
		disableBackButton = true
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
}))
