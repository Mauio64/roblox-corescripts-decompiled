local module = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/ProfileWrapperContext")
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local Types = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Types")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/getProfilePlatform")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Networking/refreshProfilePlatformActionInfo")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags")
local fFlagMoveInExperienceModeToEditProfile = SharedFlags.FFlagMoveInExperienceModeToEditProfile
local fFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage
local fFlagTCUpdateProfileCTAButton = SharedFlags.FFlagTCUpdateProfileCTAButton
local fFlagEnableRecentActivityInspectAndBuy = SharedFlags.FFlagEnableRecentActivityInspectAndBuy
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")

local v5 = {
	RoduxKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Constants").RODUX_KEY,
	installReducer = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Rodux/installReducer"),
	EnableCommunityProfilePageIXP = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/EnableCommunityProfilePageIXP"),
	EventNames = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames"),
	LoadingStagesExtension = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/LoadingStagesExtension"),
	initializeProfileAnalytics = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/initializeProfileAnalytics"),
	ProfilePlatformNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Navigation/ProfilePlatformNavigatorWithProviders"),
	ProfileWrapperContext = module,
	ProfileTypes = Enums.ProfileTypes,
	Components = Enums.Components,
	CurrentlyWearing = 0,
	UserLists = 0,
	AvatarHeadshotComponent = 0,
	SocialChipCountsRow = 0,
	AboutDetailsSheet = 0,
	RecentActivityInspectAndBuy = 0,
	MomentsFeedPage = 0,
	useDynamicSizeMargin = 0,
	useProfileJsonComponent = 0,
	Screens = 0,
	Sources = 0,
	DisabledReasons = 0,
	ProfileActions = 0,
	getProfilePlatform = 0,
	refreshProfilePlatformActionInfo = 0,
	ProfilePlatformTypes = 0,
	FFlagProfilePlatformEnableEditAppearanceMenu = 0,
	FFlagProfilePlatformEditBackgroundMenuItem = 0,
	FFlagProfilePlatformEnableMoments = 0,
	FFlagProfilePlatformGracefulVisibility = 0
}
local v6 = if fFlagAddIEMProfilePage then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/CurrentlyWearing") else nil
v5.CurrentlyWearing = v6
v5.UserLists = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow/UserLists")

local v7 = if fFlagAddIEMProfilePage then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/AvatarHeadshotComponent") else nil
v5.AvatarHeadshotComponent = v7

local v8 = if fFlagAddIEMProfilePage then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/UserProfileHeader/SocialChipCountsRow").SocialChipCountsRowContainer else nil
v5.SocialChipCountsRow = v8

v5.AboutDetailsSheet = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/AboutDetailsSheet")

local v9 = if fFlagEnableRecentActivityInspectAndBuy then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/RecentActivityInspectAndBuy/RecentActivityInspectAndBuyContainer") else nil
v5.RecentActivityInspectAndBuy = v9

local v10 = if module7 then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Components/Moments/MomentsFeedPage") else nil
v5.MomentsFeedPage = v10

local v11 = if fFlagAddIEMProfilePage then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useDynamicSizeMargin") else nil
v5.useDynamicSizeMargin = v11

local v12 = if fFlagAddIEMProfilePage then require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent") else nil
v5.useProfileJsonComponent = v12

v5.Screens = Enums.Screens
v5.Sources = Enums.Sources
v5.DisabledReasons = Enums.DisabledReasons
v5.ProfileActions = Enums.ProfileActions

if not (fFlagMoveInExperienceModeToEditProfile or fFlagAddIEMProfilePage) then
	module4 = nil
end

v5.getProfilePlatform = module4

if not fFlagTCUpdateProfileCTAButton then
	module5 = nil
end

v5.refreshProfilePlatformActionInfo = module5

if not fFlagMoveInExperienceModeToEditProfile then
	Types = nil
end

v5.ProfilePlatformTypes = Types
v5.FFlagProfilePlatformEnableEditAppearanceMenu = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableEditAppearanceMenu")
v5.FFlagProfilePlatformEditBackgroundMenuItem = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEditBackgroundMenuItem")
v5.FFlagProfilePlatformEnableMoments = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformEnableMoments")
v5.FFlagProfilePlatformGracefulVisibility = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfilePlatformGracefulVisibility")
return v5
