local ProfileWrapperContext = require(script.Contexts.ProfileWrapperContext)
local Enums = require(script.Common.Enums)
local Types = require(script.Common.Types)
local getProfilePlatform = require(script.Networking.getProfilePlatform)
local refreshProfilePlatformActionInfo = require(script.Networking.refreshProfilePlatformActionInfo)
local SharedFlags = require(script.Parent.SharedFlags)
local FFlagMoveInExperienceModeToEditProfile = SharedFlags.FFlagMoveInExperienceModeToEditProfile
local FFlagAddIEMProfilePage = SharedFlags.FFlagAddIEMProfilePage
local FFlagTCUpdateProfileCTAButton = SharedFlags.FFlagTCUpdateProfileCTAButton
local FFlagEnableRecentActivityInspectAndBuy = SharedFlags.FFlagEnableRecentActivityInspectAndBuy
local FFlagProfilePlatformEnableMoments = require(script.Flags.FFlagProfilePlatformEnableMoments)

local ProfilePlatform = {
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"]
}
local Constants = require(script.Common.Constants)
ProfilePlatform.RoduxKey = Constants.RODUX_KEY
ProfilePlatform.installReducer = require(script.Rodux.installReducer)
ProfilePlatform.EnableCommunityProfilePageIXP = require(script.Flags.EnableCommunityProfilePageIXP)
ProfilePlatform.EventNames = require(script.Analytics.EventNames)
ProfilePlatform.LoadingStagesExtension = require(script.Analytics.LoadingStagesExtension)
ProfilePlatform.initializeProfileAnalytics = require(script.Analytics.initializeProfileAnalytics)
ProfilePlatform.ProfilePlatformNavigator = require(script.Navigation.ProfilePlatformNavigatorWithProviders)
ProfilePlatform.ProfileWrapperContext = ProfileWrapperContext
ProfilePlatform.ProfileTypes = Enums.ProfileTypes
ProfilePlatform.Components = Enums.Components
local currentlyWearing

if FFlagAddIEMProfilePage then
	currentlyWearing = require(script.Components.CurrentlyWearing)
end

ProfilePlatform.CurrentlyWearing = currentlyWearing
ProfilePlatform.UserLists = require(script.Components.UserProfileHeader.SocialChipCountsRow.UserLists)
local avatarHeadshotComponent

if FFlagAddIEMProfilePage then
	avatarHeadshotComponent = require(script.Components.UserProfileHeader.AvatarHeadshotComponent)
end

ProfilePlatform.AvatarHeadshotComponent = avatarHeadshotComponent
local socialChipCountsRowContainer

if FFlagAddIEMProfilePage then
	local SocialChipCountsRow = require(script.Components.UserProfileHeader.SocialChipCountsRow)
	socialChipCountsRowContainer = SocialChipCountsRow.SocialChipCountsRowContainer
end

ProfilePlatform.SocialChipCountsRow = socialChipCountsRowContainer

ProfilePlatform.AboutDetailsSheet = require(script.Components.AboutDetailsSheet)
local recentActivityInspectAndBuy

if FFlagEnableRecentActivityInspectAndBuy then
	recentActivityInspectAndBuy = require(script.Components.RecentActivityInspectAndBuy.RecentActivityInspectAndBuyContainer)
end

ProfilePlatform.RecentActivityInspectAndBuy = recentActivityInspectAndBuy
local momentsFeedPage

if FFlagProfilePlatformEnableMoments then
	momentsFeedPage = require(script.Components.Moments.MomentsFeedPage)
end

ProfilePlatform.MomentsFeedPage = momentsFeedPage
local useDynamicSizeMargin

if FFlagAddIEMProfilePage then
	useDynamicSizeMargin = require(script.Hooks.useDynamicSizeMargin)
end

ProfilePlatform.useDynamicSizeMargin = useDynamicSizeMargin
local useProfileJsonComponent

if FFlagAddIEMProfilePage then
	useProfileJsonComponent = require(script.Hooks.useProfileJsonComponent)
end

ProfilePlatform.useProfileJsonComponent = useProfileJsonComponent

ProfilePlatform.Screens = Enums.Screens
ProfilePlatform.Sources = Enums.Sources
ProfilePlatform.DisabledReasons = Enums.DisabledReasons
ProfilePlatform.ProfileActions = Enums.ProfileActions

if not (FFlagMoveInExperienceModeToEditProfile or FFlagAddIEMProfilePage) then
	getProfilePlatform = nil
end

ProfilePlatform.getProfilePlatform = getProfilePlatform

if not FFlagTCUpdateProfileCTAButton then
	refreshProfilePlatformActionInfo = nil
end

ProfilePlatform.refreshProfilePlatformActionInfo = refreshProfilePlatformActionInfo

if not FFlagMoveInExperienceModeToEditProfile then
	Types = nil
end

ProfilePlatform.ProfilePlatformTypes = Types
ProfilePlatform.FFlagProfilePlatformEnableEditAppearanceMenu = require(script.Flags.FFlagProfilePlatformEnableEditAppearanceMenu)
ProfilePlatform.FFlagProfilePlatformEditBackgroundMenuItem = require(script.Flags.FFlagProfilePlatformEditBackgroundMenuItem)
ProfilePlatform.FFlagProfilePlatformEnableMoments = require(script.Flags.FFlagProfilePlatformEnableMoments)
ProfilePlatform.FFlagProfilePlatformGracefulVisibility = require(script.Flags.FFlagProfilePlatformGracefulVisibility)
return ProfilePlatform
