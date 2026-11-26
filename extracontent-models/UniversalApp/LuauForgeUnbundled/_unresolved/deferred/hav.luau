local CorePackages = game:GetService("CorePackages")

local RoactNavigation = require(CorePackages.Packages.RoactNavigation)

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local v5 = require("@luauforge/deferred/haw")
local module = require("@luauforge/deferred/hfG")

local module2 = require("@luauforge/deferred/hgZ")
local module3 = require("@luauforge/deferred/hhj")
local module4 = require("@luauforge/deferred/hak")
local module5 = require("@luauforge/deferred/hhk")
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local module6 = require("@luauforge/deferred/hhs")
local module7 = require("@luauforge/deferred/hhA")

local module8 = require("@luauforge/bundled/dPR")
local module9 = require("@luauforge/bundled/gVh")

local module10 = require("@luauforge/deferred/hfm")

local module11 = require("@luauforge/bundled/gVi")

local module12 = require("@luauforge/deferred/hhH")
local module13 = require("@luauforge/deferred/hhI")
local axPrefetchMarketplaceIXP = require("@luauforge/bundled/gZJ").AXPrefetchMarketplaceIXP
local v6

if axPrefetchMarketplaceIXP.isEnabled() then
	v6 = module8.readTestVariable(axPrefetchMarketplaceIXP.EnabledForUser)
end

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXUnifiedMarketplaceResultsFetcher = AvatarExperienceFlags.FFlagAXUnifiedMarketplaceResultsFetcher
local fFlagAXEnableProfileTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableProfileTab
local fFlagAXUseProfileIconEntryPoint = AvatarExperienceFlags.FFlagAXUseProfileIconEntryPoint

local v7 = if fFlagAXEnableProfileTab then require("@luauforge/deferred/hhK") else nil

local fFlagEnableBottomNavOnMarketplace = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableBottomNavOnMarketplace
local fFlagAXFavoritesManagerNavEntry = AvatarExperienceFlags.FFlagAXFavoritesManagerNavEntry

local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEditProfileImageV2Enabled

local fFlagAXHideBottomNavForEditProfileImage = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXHideBottomNavForEditProfileImage
local module15 = require("@luauforge/deferred/ham")

function LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser(): boolean
	return not module8.readTestVariable(module10.DisableAlwaysRenderedScreen)
end

local v8 = {}

local v9 = { alwaysRendered = 0, tabBarVisible = 0 }
local v10 = if module10.isEnabled() then LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser() else not isVRAppBuild()
v9.alwaysRendered = v10

v9.tabBarVisible = not fFlagAXUseProfileIconEntryPoint and fFlagEnableBottomNavOnMarketplace and true or nil

local fn = fFlagAXHideBottomNavForEditProfileImage and fFlagEnableBottomNavOnMarketplace and function(p2)
	local success, result = pcall(module15, p2.navigation)
	local tabBarVisible = if success and typeof(result) == "table" then result.tabBarVisible else nil
	local v11 = { alwaysRendered = v9.alwaysRendered, tabBarVisible = 0 }

	if tabBarVisible == nil then
		tabBarVisible = v9.tabBarVisible
	end

	v11.tabBarVisible = tabBarVisible
	return v11
end or v9
local v11

if fFlagAXEnableProfileTab then
	v11 = {}
	v11[avatarScreen.Profile] = { screen = v7, navigationOptions = fn }
end

if v6 or fFlagAXUnifiedMarketplaceResultsFetcher then
	local avatarEditor = avatarScreen.AvatarEditor

	if module12() then
		v5 = module6
	end

	local v15 = if module10.isEnabled() then LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser() else not isVRAppBuild()
	local v12 = {
		[avatarEditor] = {
			screen = v5,
			navigationOptions = {
				alwaysRendered = v15,
				tabBarVisible = fFlagEnableBottomNavOnMarketplace and true or nil
			}
		}
	}

	local catalog = avatarScreen.Catalog

	local v19 = if module10.isEnabled() then LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser() else not isVRAppBuild()
	local v16 = {
		[catalog] = {
			screen = module,
			navigationOptions = {
				alwaysRendered = v19,
				tabBarVisible = fFlagEnableBottomNavOnMarketplace and true or nil
			}
		}
	}

	local modulesByProfilePictureEditorEmotes = {
		[avatarScreen.ProfilePictureEditorEmotes] = module2
	}

	table.insert(v8, v16)
	table.insert(v8, v12)

	if v11 then
		table.insert(v8, v11)
	end

	table.insert(v8, modulesByProfilePictureEditorEmotes)
else
	v8 = { nil, nil, nil, nil }

	local avatarExperienceLandingPage = avatarScreen.AvatarExperienceLandingPage

	local v15 = if module10.isEnabled() then LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser() else not isVRAppBuild()
	local v12 = {
		[avatarExperienceLandingPage] = {
			screen = module5,
			navigationOptions = {
				alwaysRendered = v15,
				tabBarVisible = true,
				backButtonAction = module4.Unhandled
			}
		}
	}

	local avatarEditor = avatarScreen.AvatarEditor

	if module12() then
		v5 = module6
	end

	local v19 = if module10.isEnabled() then LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser() else not isVRAppBuild()
	local v16 = {
		[avatarEditor] = {
			screen = v5,
			navigationOptions = {
				alwaysRendered = v19,
				tabBarVisible = fFlagEnableBottomNavOnMarketplace and true or nil
			}
		}
	}

	local catalog = avatarScreen.Catalog

	local v23 = if module10.isEnabled() then LUAUFORGE_MODULE_GLOBALS_hav_shouldEnableAlwaysRenderedScreensForUser() else not isVRAppBuild()
	v8[1], v8[2], v8[3], v8[4] = v12, v16, {
	[catalog] = {
		screen = module,
		navigationOptions = {
alwaysRendered = v23,
tabBarVisible = fFlagEnableBottomNavOnMarketplace and true or nil
		}
	}
}, { [avatarScreen.ProfilePictureEditorEmotes] = module2 }

	if v11 then
		table.insert(v8, v11)
	end
end

if fFlagEditProfileImageV2Enabled then
	local modulesByEditProfileImage = { [avatarScreen.EditProfileImage] = module3 }
	table.insert(v8, modulesByEditProfileImage)
end

if fFlagAXFavoritesManagerNavEntry then
	local v12 = {
		[avatarScreen.FavoritesSaved] = {
			screen = module7,
			navigationOptions = {
				alwaysRendered = false,
				tabBarVisible = fFlagEnableBottomNavOnMarketplace and true or nil
			}
		}
	}
	table.insert(v8, v12)
end

local function navigationOptions(p2)
	local v12 = {
		overlayEnabled = true,
		overlayTransparency = 1,
		absorbInput = false,
		hasSelectionGroup = false
	}

	if module11() or module9 and module8.readTestVariable(module9.EnabledForUser) then
		local key = p2.navigation.state.key
		local noOp = module4.NoOp

		if
			key ~= "AvatarEditor"
			and key ~= "Catalog"
			and (not fFlagAXEnableProfileTab or key ~= "Profile")
		then
			noOp = nil
		end

		v12.backButtonAction = noOp
	end

	return v12
end

return module13(v8, {
	backBehavior = RoactNavigation.BackBehavior.InitialRoute,
	defaultNavigationOptions = navigationOptions,
	keepVisitedScreensMounted = not isVRAppBuild()
})
