local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local ProfilePlatformParent = ProfilePlatform.Parent
local React = require(ProfilePlatformParent.React)
local Enums = require(ProfilePlatform.Common.Enums)

require(ProfilePlatformParent.CurrencyTransfers)

local FFlagProfilePlatformEnableStore = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableStore
local FFlagAddSocialLinksToCommunityProfile = require(ProfilePlatformParent.SharedFlags).FFlagAddSocialLinksToCommunityProfile
local FFlagEnablePlatformProfileContextualMenuOption = require(ProfilePlatformParent.SharedFlags).FFlagEnablePlatformProfileContextualMenuOption
local FFlagAddIEMProfilePage = require(ProfilePlatformParent.SharedFlags).FFlagAddIEMProfilePage
local FFlagProfilePlatformEnableEditAppearanceMenu = require(ProfilePlatform.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
local FFlagProfilePlatformEditBackgroundMenuItem = require(ProfilePlatform.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
local FFlagProfilePlatformEnableCurrencyTransfer = require(ProfilePlatformParent.SharedFlags).FFlagProfilePlatformEnableCurrencyTransfer

return React.createContext({
	profileId = "TEST_ID",
	profilePlatformId = if not FFlagEnablePlatformProfileContextualMenuOption then nil else "TEST_PLATFORM_ID",
	profileType = Enums.ProfileTypes.User,
	navigateTo = {
		qRCodePage = function() -- line: 123
		end,
		previousView = function() -- line: 124
		end,
		itemDetails = function() -- line: 125
		end,
		itemOrBundleDetails = if not FFlagProfilePlatformEnableStore then nil else function() -- line: 126
		end,
		catalogSearch = if not FFlagProfilePlatformEnableStore then nil else function() -- line: 127
		end,
		inspectAvatar = if not FFlagAddIEMProfilePage then nil else function() -- line: 128
		end,
		editEmotes = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function() -- line: 129
		end,
		switchAvatar = if not FFlagProfilePlatformEnableEditAppearanceMenu then nil else function() -- line: 130
		end,
		editBackground = if not FFlagProfilePlatformEnableEditAppearanceMenu or not FFlagProfilePlatformEditBackgroundMenuItem then nil else function() -- line: 133
		end,
		editAvatar = function() -- line: 135
		end,
		editUsername = function() -- line: 136
		end,
		openLeaveRobloxAlertUIBlox = if not FFlagAddSocialLinksToCommunityProfile then nil else function() -- line: 137
		end,
		closeLeaveRobloxAlert = if not FFlagAddSocialLinksToCommunityProfile then nil else function() -- line: 138
		end,
		navigateToTransfer = if not FFlagProfilePlatformEnableCurrencyTransfer then nil else function() -- line: 139
		end
	},
	externalAnalytics = {
		catalogAnalytics = {}
	},
	sourceInfo = {
		isRecommendation = false,
		source = "TEST_SOURCE",
		contextualInfoType = "TEST_CONTEXTUAL_INFO_TYPE",
		friendshipOriginSourceType = "TEST_FRIENDSHIP_ORIGIN_SOURCE_TYPE",
		contextualOverride = {}
	}
})
