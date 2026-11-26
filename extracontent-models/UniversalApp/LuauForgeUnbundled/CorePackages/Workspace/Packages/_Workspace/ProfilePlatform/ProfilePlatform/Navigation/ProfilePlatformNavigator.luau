local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local SetAlias = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SetAlias")
local ProfileContextualMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfileContextualMenu")
local EditProfileLanding = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/EditProfileLanding")
local EditDisplayNameErrorModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/EditDisplayNameErrorModal")
local UsernameInsufficientFundsModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/UsernameInsufficientFundsModal")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/Enums")
local ProfilePlatformViewAdaptor = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/ProfilePlatformViewAdaptor")
local setAliasModal = SetAlias.SetAliasModal
local EditProfileScreenViewAdapter = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/EditProfileScreenViewAdapter")
local EditProfileToastScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/EditProfile/EditProfileToastScreen")
local EditProfileBackgroundContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/EditProfileBackgroundContainer")
local CommunityVerificationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CommunityVerificationModal")
local InspectAvatarSheetContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InspectAvatarSheetContainer")
local PurchaseConfirmationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/PurchaseConfirmationModal")
local InsufficientRobuxDialog = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/InspectAvatar/InsufficientRobuxDialog")
local MomentsGridPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentsGridPage")
local MomentsFeedPage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentsFeedPage")
local fFlagSocialEnableProfileInspectAndBuy = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagSocialEnableProfileInspectAndBuy
local FFlagProfilePlatformEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactNavigation")

local fFlagEditProfileBackgroundEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEditProfileBackgroundEnabled
local FFlagEnableCommunityVerificationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagEnableCommunityVerificationModal")
local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEditProfileImageV2Enabled
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXEnableProfileTab
local fFlagAXHideBottomNavForEditProfileImage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXHideBottomNavForEditProfileImage
local fFlagEnableBottomNavOnMarketplace = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnableBottomNavOnMarketplace
local fFlagAXSaveManagerOutsideAX = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAXSaveManagerOutsideAX

local v5 = { overlayEnabled = true, overlayTransparency = 0.5, absorbInput = true }

local v6 = { overlayEnabled = false, absorbInput = true, renderUnderlyingPage = true }

local function makeFullBleedNavigationOptions(p2, p3)
	local v7 = p3 or v6
	return function(p4)
		if p4.navigation.getParam("fullBleed") then
			return v7
		end

		return p2
	end
end

local function LazyEditProfileImageContainer(p2)
	local EditProfileImageContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/EditProfileImage/EditProfileImageContainer")
	return React.createElement(EditProfileImageContainer, p2)
end

local v12 = {
	{ [Enums.Screens.ProfileMain] = ProfilePlatformViewAdaptor },
	{
		[Enums.Screens.EditProfilePage] = {
			screen = EditProfileLanding,
			navigationOptions = fFlagAXEnableProfileTab and function(p2)
				if p2.navigation.getParam("fullBleed") then
					return v6
				end

				return v5
			end or v5
		}
	},
	{
		[Enums.Screens.EditDisplayNameErrorModal] = {
			screen = EditDisplayNameErrorModal,
			navigationOptions = v5
		}
	},
	{
		[Enums.Screens.UsernameInsufficientFundsModal] = {
			screen = UsernameInsufficientFundsModal,
			navigationOptions = v5
		}
	},
	{
		[Enums.Screens.SetAliasModal] = {
			screen = setAliasModal,
			navigationOptions = v5
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
	local v13 = {
		[Enums.Screens.CommunityVerificationModal] = {
			screen = CommunityVerificationModal,
			navigationOptions = v5
		}
	}
	table.insert(v12, v13)
end

if fFlagEditProfileBackgroundEnabled then
	local v13 = {
		[Enums.Screens.EditProfileBackground] = {
			screen = EditProfileBackgroundContainer,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true,
				renderUnderlyingPage = true
			}
		}
	}
	table.insert(v12, v13)
end

local editProfileSubScreen = module7.Screens.EditProfileSubScreen
local v15

if fFlagAXEnableProfileTab then
	local v16 = {
		overlayEnabled = true,
		overlayTransparency = 0.5,
		absorbInput = false
	}

	v15 = function(p2)
		if p2.navigation.getParam("fullBleed") then
			return v6
		end

		return v16
	end
else
	v15 = { overlayEnabled = true, overlayTransparency = 0.5, absorbInput = false }
end

local v13 = {
	[editProfileSubScreen] = { screen = EditProfileScreenViewAdapter, navigationOptions = v15 }
}
table.insert(v12, v13)

local v16 = {
	[module7.Screens.EditProfileToast] = {
		screen = EditProfileToastScreen,
		navigationOptions = {
			overlayEnabled = true,
			overlayTransparency = 1,
			absorbInput = false
		}
	}
}
table.insert(v12, v16)

if fFlagEditProfileImageV2Enabled then
	local v17

	if fFlagAXHideBottomNavForEditProfileImage and fFlagEnableBottomNavOnMarketplace then
		v17 = false
	end

	local v18 = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = true,
		tabBarVisible = v17
	}

	local v19 = {
		overlayEnabled = false,
		absorbInput = true,
		renderUnderlyingPage = true,
		tabBarVisible = v17
	}

	local editProfileImageProfilePlatform = module7.Screens.EditProfileImageProfilePlatform
	local v21 = {
		screen = LazyEditProfileImageContainer,
		params = fFlagAXSaveManagerOutsideAX and { runAvatarSaveManager = true } or nil,
		navigationOptions = 0
	}
	local v22

	if fFlagAXEnableProfileTab then
		local v23 = v19 or v6
		v22 = function(p2)
			if p2.navigation.getParam("fullBleed") then
				return v23
			end

			return v18
		end
	else
		v22 = v18
	end

	v21.navigationOptions = v22
	local v20 = { [editProfileImageProfilePlatform] = v21 }
	table.insert(v12, v20)
end

if fFlagSocialEnableProfileInspectAndBuy then
	local v17 = {
		[Enums.Screens.InspectAvatarSheet] = {
			screen = InspectAvatarSheetContainer,
			navigationOptions = {
				overlayEnabled = true,
				overlayTransparency = 1,
				absorbInput = true
			}
		}
	}
	table.insert(v12, v17)

	local v18 = {
		[Enums.Screens.PurchaseConfirmationModal] = {
			screen = PurchaseConfirmationModal,
			navigationOptions = v5
		}
	}
	table.insert(v12, v18)

	local v19 = {
		[Enums.Screens.InsufficientRobuxDialog] = {
			screen = InsufficientRobuxDialog,
			navigationOptions = v5
		}
	}
	table.insert(v12, v19)
end

if FFlagProfilePlatformEnableMoments then
	local v17 = {
		[Enums.Screens.MomentsAll] = {
			screen = MomentsGridPage,
			navigationOptions = {
				overlayEnabled = false,
				absorbInput = true,
				renderUnderlyingPage = true
			}
		}
	}
	table.insert(v12, v17)

	local v18 = {
		[Enums.Screens.MomentsFeed] = {
			screen = MomentsFeedPage,
			navigationOptions = { overlayEnabled = false, absorbInput = true }
		}
	}
	table.insert(v12, v18)
end

return (RoactNavigation.createRobloxStackNavigator(v12, {
	defaultNavigationOptions = {
		overlayEnabled = true,
		absorbInput = true,
		overlayTransparency = 1,
		disableBackButton = true
	},
	mode = RoactNavigation.StackPresentationStyle.Overlay
}))
