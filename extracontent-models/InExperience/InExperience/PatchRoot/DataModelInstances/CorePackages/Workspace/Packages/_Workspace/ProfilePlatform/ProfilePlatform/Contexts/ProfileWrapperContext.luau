local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent
local React = require(parent.React)
local Enums = require(ProfilePlatform.Common.Enums)
require(parent.CurrencyTransfers)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformEnableStore = SharedFlags.FFlagProfilePlatformEnableStore
local SharedFlags2 = require(parent.SharedFlags)
local FFlagAddSocialLinksToCommunityProfile = SharedFlags2.FFlagAddSocialLinksToCommunityProfile

local SharedFlags3 = require(parent.SharedFlags)
local FFlagEnablePlatformProfileContextualMenuOption = SharedFlags3.FFlagEnablePlatformProfileContextualMenuOption
local SharedFlags4 = require(parent.SharedFlags)
local FFlagAddIEMProfilePage = SharedFlags4.FFlagAddIEMProfilePage

local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)

local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)

local SharedFlags5 = require(parent.SharedFlags)
local FFlagProfilePlatformEnableCurrencyTransfer = SharedFlags5.FFlagProfilePlatformEnableCurrencyTransfer

return React.createContext({
	profileId = "TEST_ID",
	profilePlatformId = FFlagEnablePlatformProfileContextualMenuOption and "TEST_PLATFORM_ID" or nil,
	profileType = Enums.ProfileTypes.User,
	navigateTo = {
		qRCodePage = function() end,
		previousView = function() end,
		itemDetails = function() end,
		itemOrBundleDetails = FFlagProfilePlatformEnableStore and function() end or nil,
		preparePurchaseItem = function() end,
		shopForMoreEmotes = function() end,
		promptR15Upgrade = function() end,
		catalogSearch = FFlagProfilePlatformEnableStore and function() end or nil,
		inspectAvatar = FFlagAddIEMProfilePage and function() end or nil,
		editEmotes = FFlagProfilePlatformEnableEditAppearanceMenu and function() end or nil,
		switchAvatar = FFlagProfilePlatformEnableEditAppearanceMenu and function() end or nil,
		editBackground = FFlagProfilePlatformEnableEditAppearanceMenu and FFlagProfilePlatformEditBackgroundMenuItem and function() end or nil,
		editAvatar = function() end,
		editUsername = function() end,
		openLeaveRobloxAlertUIBlox = FFlagAddSocialLinksToCommunityProfile and function() end or nil,
		closeLeaveRobloxAlert = FFlagAddSocialLinksToCommunityProfile and function() end or nil,
		navigateToTransfer = FFlagProfilePlatformEnableCurrencyTransfer and function() end or nil
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
