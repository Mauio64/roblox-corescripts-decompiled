local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/CurrencyTransfers")
local fFlagProfilePlatformEnableStore = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableStore
local fFlagAddSocialLinksToCommunityProfile = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddSocialLinksToCommunityProfile

local fFlagEnablePlatformProfileContextualMenuOption = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagEnablePlatformProfileContextualMenuOption
local fFlagAddIEMProfilePage = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagAddIEMProfilePage

local FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")

local FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")

local fFlagProfilePlatformEnableCurrencyTransfer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformEnableCurrencyTransfer

return React.createContext({
	profileId = "TEST_ID",
	profilePlatformId = fFlagEnablePlatformProfileContextualMenuOption and "TEST_PLATFORM_ID" or nil,
	profileType = Enums.ProfileTypes.User,
	navigateTo = {
		qRCodePage = function() end,
		previousView = function() end,
		itemDetails = function() end,
		itemOrBundleDetails = fFlagProfilePlatformEnableStore and function() end or nil,
		preparePurchaseItem = function() end,
		shopForMoreEmotes = function() end,
		promptR15Upgrade = function() end,
		catalogSearch = fFlagProfilePlatformEnableStore and function() end or nil,
		inspectAvatar = fFlagAddIEMProfilePage and function() end or nil,
		editEmotes = FFlagProfilePlatformEnableEditAppearanceMenu and function() end or nil,
		switchAvatar = FFlagProfilePlatformEnableEditAppearanceMenu and function() end or nil,
		editBackground = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem and function() end or nil,
		editAvatar = function() end,
		editUsername = function() end,
		openLeaveRobloxAlertUIBlox = fFlagAddSocialLinksToCommunityProfile and function() end or nil,
		closeLeaveRobloxAlert = fFlagAddSocialLinksToCommunityProfile and function() end or nil,
		navigateToTransfer = fFlagProfilePlatformEnableCurrencyTransfer and function() end or nil
	},
	externalAnalytics = { catalogAnalytics = {} },
	sourceInfo = {
		isRecommendation = false,
		source = "TEST_SOURCE",
		contextualInfoType = "TEST_CONTEXTUAL_INFO_TYPE",
		contextualOverride = {},
		friendshipOriginSourceType = "TEST_FRIENDSHIP_ORIGIN_SOURCE_TYPE"
	}
})
