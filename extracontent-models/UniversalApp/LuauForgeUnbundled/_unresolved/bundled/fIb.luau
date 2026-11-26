local CorePackages = game:GetService("CorePackages")
local AppStorageService = game:GetService("AppStorageService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

local Cryo = require(CorePackages.Packages.Cryo)
local module = require("@luauforge/bundled/fIc")
local fFlagEnableAmpV2Wizard = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpV2Wizard

local experienceService = require("@luauforge/bundled/bZg").ExperienceService

local gamesMultigetPlaceDetails = require("@luauforge/bundled/dBl").GamesByPlaceId.GamesMultigetPlaceDetails
local default = require("@luauforge/bundled/bZe").LinkingProtocol.default

local chatEntryPointNames = require("@luauforge/bundled/eoT").Enums.ChatEntryPointNames
local ixpServiceWrapper = require("@luauforge/bundled/fwW").IXPServiceWrapper

local module2 = require("@luauforge/bundled/dFu")
local module3 = require("@luauforge/bundled/fId")
local module4 = require("@luauforge/bundled/dzO")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local navigationParams = require("@luauforge/bundled/fCn").Enums.NavigationParams

local fFlagAXBackgroundGenerationDeepLink = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXBackgroundGenerationDeepLink

local fFlagAXCustomizeTabDeepLink = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXCustomizeTabDeepLink
local module5 = require("@luauforge/bundled/dPN")
local createConversation = module3.http.CreateConversation
local module6 = require("@luauforge/bundled/fIe")
local module7 = require("@luauforge/bundled/fIg")
local module8 = require("@luauforge/bundled/fIh")
local module9 = require("@luauforge/bundled/fIi")
require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux")
local module10 = require("@luauforge/bundled/ehC")
local searchTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").SearchTypes
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local module11 = require("@luauforge/bundled/fIj")
local module12 = require("@luauforge/bundled/fBF")
local UrlBuilder = require("@game/CorePackages/Packages/_Index/UrlBuilder/UrlBuilder")
local module14 = require("@luauforge/bundled/fzK")
local useGameDetailsPeekView = require("@luauforge/bundled/dCK").PeekView.UseGameDetailsPeekView
local module15 = require("@luauforge/bundled/dRg")
local module16 = require("@luauforge/bundled/dRz")
local module17 = require("@luauforge/bundled/fCI")
local module18 = require("@luauforge/bundled/fIl")
local constants = require("@luauforge/bundled/cqW").Constants

local upsellEntrySurfaceType = require("@luauforge/bundled/fDy").Analytics.Enum.UpsellEntrySurfaceType

local contactImporterModalInfo = require("@luauforge/bundled/cqW").Utils.contactImporterModalInfo
local module19 = require("@luauforge/bundled/fIm")
local module20 = require("@luauforge/bundled/fIn")
local hardwareSafeAreaInsets = require("@game/CorePackages/Workspace/Packages/Responsive").HardwareSafeAreaInsets
local streamNotificationStore = require("@luauforge/bundled/fBn").StreamNotificationStore
local module21 = require("@luauforge/bundled/fHh")
local surfaceContext = module21.SurfaceContext
local surfaceName = module21.SurfaceName

local module22 = require("@luauforge/bundled/fIo")
local module23 = require("@luauforge/bundled/fIR")
local module24 = require("@luauforge/bundled/fIW")

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local defineFastFlag = game:DefineFastFlag("EnablePrivacySettingsDeeplinks", false)
local defineFastFlag2 = game:DefineFastFlag("EnableParentalControlsDeeplinks", false)
local defineFastFlag3 = game:DefineFastFlag("EnableAccountInfoDeeplinks", false)
local defineFastFlag4 = game:DefineFastFlag("EnableRobuxSettingsDeeplink", false)
local defineFastFlag5 = game:DefineFastFlag("EnableSecuritySettingsDeeplink", false)
local defineFastFlag6 = game:DefineFastFlag("EnableSubscriptionsSettingsDeeplink", false)
game:SetFlagVersion("EnableDevicePreferencesDeeplink", 2)
local defineFastFlag7 = game:DefineFastFlag("EnableDevicePreferencesDeeplink", false)
local module25 = require("@luauforge/bundled/fJk")
local defineFastFlag8 = game:DefineFastFlag("LuaAppLaunchDestinationDeepLink", false)
local defineFastFlag9 = game:DefineFastFlag("EnableSettingSubpageDeeplinks", false)
local defineFastFlag10 = game:DefineFastFlag("EnableNotificationSettingsTypeDeeplink", false)
local defineFastFlag11 = game:DefineFastFlag("NotificationsDeeplinkNavigateToHome", false)

local getFFlagEnableSecurityAlertDeeplink = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableSecurityAlertDeeplink

local getFFlagGenerateLinkWithChannel = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagGenerateLinkWithChannel
local module26 = require("@luauforge/bundled/dVo")

local module27 = require("@luauforge/bundled/fJl")
local module28 = require("@luauforge/bundled/fJm")
local module29 = require("@luauforge/bundled/fJn")
local defineFastFlag12 = game:DefineFastFlag("EnableBuyRobuxDeepLink", false)

local fFlagEnableCurrencyTransferDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableCurrencyTransferDeepLink

local fFlagCurrencyTransferDeepLinkValidateSender = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCurrencyTransferDeepLinkValidateSender

local fFlagSduiOpenIncomingTransferUpsellAction = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSduiOpenIncomingTransferUpsellAction
local fFlagEnablePlusUpsellDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlusUpsellDeepLink

local fFlagEnablePlusReferralDashboardDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlusReferralDashboardDeepLink

local fFlagEnablePlusReferralLandingSheet = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlusReferralLandingSheet

local fFlagEnablePlusReferralEntrypointTelemetry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlusReferralEntrypointTelemetry

local module30 = require("@luauforge/bundled/fJo")

local fFlagPlusSubscribeDeepLinkIncludeUpgrades = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPlusSubscribeDeepLinkIncludeUpgrades

local module31 = require("@luauforge/bundled/fJp")
local fFlagLuaAppForumsDeeplinkFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppForumsDeeplinkFix

local fFlagEnablePlusWebviewDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnablePlusWebviewDeepLink

local defineFastFlag13 = game:DefineFastFlag("EnableBundleItemDetailHttpLink", false)
local defineFastFlag14 = game:DefineFastFlag("EnableEmptyContainerWidgetDeepLink", false)
local module32 = require("@luauforge/bundled/fIH")
local module33 = require("@luauforge/bundled/fJq")
local module34 = require("@luauforge/bundled/fJr")

local fFlagEditProfileImageV2Enabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEditProfileImageV2Enabled
local fFlagEditProfileFramesEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEditProfileFramesEnabled
local fFlagNavigationCallbackParam = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagNavigationCallbackParam

local fFlagEnableShareLinksInGameDetailEvent = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableShareLinksInGameDetailEvent

local fFlagLuaAppSupportDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSupportDeviceSafeInsets

local getFFlagUseCommunitiesTranslation = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseCommunitiesTranslation
local getFFlagEnableSupportCenter = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableSupportCenter
local module35 = require("@luauforge/bundled/fJs")

local fFlagEnableSquadDeeplinkWithChatId = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSquadDeeplinkWithChatId
local fFlagLuaAppSortDeeplinkFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSortDeeplinkFix
local fFlagEnableAmpWizardDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpWizardDeepLink

local fFlagEnableAccountUnlockDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAccountUnlockDeepLink

local fFlagAccountUnlockAllowMissingUserId = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAccountUnlockAllowMissingUserId

local fFlagEnableAmpWizardDeepLinkValidateUserId = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAmpWizardDeepLinkValidateUserId
local module36 = require("@luauforge/bundled/dKL")

local fFlagCiDeprecateFindFriendsModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagCiDeprecateFindFriendsModal

local fFlagEnableNotificationsDeeplink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableNotificationsDeeplink

local fFlagStreamNotificationDropdownSingleOwner = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagStreamNotificationDropdownSingleOwner
local fFlagTCParentChildAutoUpgrade = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCParentChildAutoUpgrade

local fFlagLuaAppSduiLandingPageEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppSduiLandingPageEnabled
local fFlagAppNavMyStatsTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppNavMyStatsTab
local fFlagBuildExperienceLibrary = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagBuildExperienceLibrary

local fFlagBuildAdsNotificationRouting = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagBuildAdsNotificationRouting
local fFlagBuildAdUpsell = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagBuildAdUpsell

local fFlagLuaEnableGenreLandingDeeplink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaEnableGenreLandingDeeplink
local fFlagEnableSchoolEntry = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSchoolEntry

local fFlagSchoolDeepLinkUseConnectionsHub = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSchoolDeepLinkUseConnectionsHub

local fFlagFriendsDeepLinkInitialFilter = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFriendsDeepLinkInitialFilter
local fFlagEnableArgus = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableArgus

local fFlagAppIaHomeCampaignDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaHomeCampaignDeepLink
local fFlagAppIaHomeSubTab = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaHomeSubTab
local defineFastFlag15 = game:DefineFastFlag("EnableMomentsDeepLink", false)
local fFlagMomentsCommentDeepLinks = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagMomentsCommentDeepLinks

local fFlagEnableCommunitiesHttpDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableCommunitiesHttpDeepLink
local defineFastFlag16 = game:DefineFastFlag("PinnedShortcutDeepLinkTelemetry", false)
local defineFastFlag17 = game:DefineFastFlag("FixGameDetailsDeepLinkHomeRootRoute", false)
local defineFastFlag18 = game:DefineFastFlag("GameDetailsHomeRootTelemetry", false)
local defineFastFlag19 = game:DefineFastFlag("CommunitiesHttpDeepLinkIxpEnabled", false)

local defineFastString = game:DefineFastString(
	"CommunitiesHttpDeepLinkIxpLayer",
	"Social.CommunityProfileView"
)

game:DefineFastString("SearchDeepLinkPattern", "roblox.*://navigation/search.*")
game:DefineFastString("GamesPageDeepLinkPattern", "roblox.*://navigation/games")
game:DefineFastString("HomePageDeepLinkPattern", "roblox.*://navigation/home")
game:DefineFastString("CampaignPageDeepLinkPattern", "roblox.*://navigation/campaign")
game:DefineFastString("BuildPageDeepLinkPattern", "roblox.*://navigation/build.*")
game:DefineFastString("AvatarClothingSortingView", "roblox.*://navigation/avatar_clothing_sort")
game:DefineFastString("AvatarProfilePictureEditor", "roblox.*://navigation/avatar_profile_picture_editor")
game:DefineFastString("AvatarProfileFramesEditor", "roblox.*://navigation/avatar_profile_frames")
game:DefineFastString("AvatarBackgroundGeneration", "roblox.*://navigation/avatar_background_generation")
game:DefineFastString("AvatarDeepLinkPattern", "roblox.*://navigation/avatar.*")
game:DefineFastString("AvatarHttpPattern", "/my/avatar")
game:DefineFastString("MorePageDeepLinkPattern", "roblox.*://navigation/more")
game:DefineFastString("NotificationsDeepLinkPattern", "roblox.*://navigation/notifications")
game:DefineFastString(
	"NotificationSettingsDeepLinkPattern",
	"roblox.*://navigation/notification_settings.*"
)
game:DefineFastString("RoactChatDeepLinkPattern", "roblox.*://navigation/chat.*")
game:DefineFastString("GameDetailsDeepLinkPattern", "roblox.*://navigation/game_details.*")
game:DefineFastString("GameDetailsHttpPattern", "/games/(%d+)/?[%w_-]*%??r?e?f?P?a?g?e?I?d?=?[%w%-]*")
game:DefineFastString("GameDetailsReferralHttpPattern", "/games/refer.*")
game:DefineFastString("ProfileCardDeepLinkPattern", "roblox.*://navigation/profile_card.*")
game:DefineFastString(
	"ProfileTrustedFriendsDeepLinkPattern",
	"roblox.*://navigation/profile_trustedfriends.*"
)
game:DefineFastString("ProfileDeepLinkPattern", "roblox.*://navigation/profile.*")
game:DefineFastString("CatalogSearchDeepLinkPattern", "roblox.*://navigation/catalog?.+")
game:DefineFastString("CatalogEquipDeepLinkPattern", "roblox.*://navigation/catalog/equip?.+")
game:DefineFastString("CatalogDeepLinkPattern", "roblox.*://navigation/catalog")
game:DefineFastString("CatalogHttpPattern", "/catalog[^/]*")
game:DefineFastString("ItemDetailsDeepLinkPattern", "roblox.*://navigation/item_details.*")
game:DefineFastString("ItemDetailsHttpPattern", "/catalog/(%d+)/.*")
game:DefineFastString("BundleItemDetailsHttpPattern", "/bundles/(%d+)/.*")
game:DefineFastString("LookItemDetailsHttpPattern", "/looks/(%d+)/.*")
game:DefineFastString("ItemRedemptionDeepLinkPattern", "roblox.*://navigation/qr_code_redemption.*")

if defineFastFlag9 then
	game:DefineFastString("FriendsPageDeepLinkPattern", "roblox.*://navigation/friends$")
else
	game:DefineFastString("FriendsPageDeepLinkPattern", "roblox.*://navigation/friends")
end

game:DefineFastString("FriendsPageWithQueryDeepLinkPattern", "roblox.*://navigation/friends%?.*")
game:DefineFastString("GiftCardsPageDeepLinkPattern", "roblox.*://navigation/gift_cards")
game:DefineFastString("BuyRobuxDeepLinkPattern", "roblox.*://navigation/buy_robux")
game:DefineFastString("PlusUpsellDeepLinkPattern", "roblox.*://navigation/plus_upsell")
game:DefineFastString(
	"RobloxSubscriptionOnboardingSheetDeepLinkPattern",
	"roblox.*://navigation/plus_onboarding"
)
game:DefineFastString(
	"PlusReferralDashboardDeepLinkPattern",
	"roblox.*://navigation/plus_referral_dashboard"
)
game:DefineFastString("PlusSubscribeDeepLinkPattern", "roblox.*://navigation/plus_subscribe.*")
game:DefineFastString("CurrencyTransferDeepLinkPattern", "roblox.*://navigation/currency_transfer.*")
game:DefineFastString("PlusWebviewDeepLinkPattern", "roblox.*://navigation/plus_webview")
game:DefineFastString("GroupsDeepLinkPattern", "roblox.*://navigation/group.*")
game:DefineFastString("CommunitiesHttpPattern", "/communities/(%d+)(.*)")
game:DefineFastString("GroupsHttpPattern", "/groups/(%d+)(.*)")
game:DefineFastString("CrossDeviceLoginDeepLinkPattern", "roblox.*://navigation/crossdevice.*")
game:DefineFastString("EventDetailsPageDeepLinkPattern", "roblox.*://navigation/event_details.*")
game:DefineFastString("ShareLinkDeepLinkPattern", "roblox.*://navigation/share_links.*")
game:DefineFastString(
	"StaticShareLinkDeepLinkPattern",
	"roblox.*://navigation/share_links/(%w)/([%w%-]+).*"
)
game:DefineFastString("JoinLinkHttpPattern", "/join/([%w]+).*")
game:DefineFastString("ShareLinkHttpPattern", "/share.*")
game:DefineFastString("StaticShareLinkHttpPattern", "/share/(%w)/([%w%-]+).*")
game:DefineFastString("ShortShareLinkHttpPattern", "/shortlink.*")
game:DefineFastString("ContentPostDeepLinkPattern", "roblox.*://navigation/content_post.*")
game:DefineFastString("AddSchoolDeepLinkPattern", "roblox.*://navigation/add_school.*")
game:DefineFastString("ContactsDeepLinkPattern", "roblox.*://navigation/contacts.*")
game:DefineFastString("AppealsPortalDeepLinkPattern", "roblox.*://navigation/appeals.*")
game:DefineFastString("SupportCenterDeepLinkPattern", "roblox.*://navigation/support_center.*")
game:DefineFastString("PrivacySettingsDeepLinkPattern", "roblox.*://navigation/privacy_settings")
game:DefineFastString(
	"AppPermissionsSettingsDeepLinkPattern",
	"roblox.*://navigation/app_permissions_settings"
)
game:DefineFastString("ScreentimeSettingsDeepLinkPattern", "roblox.*://navigation/screentime_subsettings")
game:DefineFastString(
	"CommunicationSettingsDeepLinkPattern",
	"roblox.*://navigation/communication_subsettings"
)
game:DefineFastString(
	"BlockedUsersSettingsDeepLinkPattern",
	"roblox.*://navigation/blocked_users_subsettings"
)
game:DefineFastString(
	"BlockedExpSettingsDeepLinkPattern",
	"roblox.*://navigation/blocked_experiences_subsettings"
)
game:DefineFastString(
	"ExperienceChatSettingsDeepLinkPattern",
	"roblox.*://navigation/experience_chat_subsettings"
)
game:DefineFastString("PartySettingsDeepLinkPattern", "roblox.*://navigation/party_subsettings")
game:DefineFastString("VoiceSettingsDeepLinkPattern", "roblox.*://navigation/voice_subsettings")
game:DefineFastString(
	"TradingInventorySettingsDeepLinkPattern",
	"roblox.*://navigation/trading_inventory_subsettings"
)
game:DefineFastString(
	"PrivateServerSettingsDeepLinkPattern",
	"roblox.*://navigation/private_server_subsettings"
)
game:DefineFastString(
	"FriendsContactsSettingsDeepLinkPattern",
	"roblox.*://navigation/friends_contacts_subsettings"
)
game:DefineFastString("VisibilitySettingsDeepLinkPattern", "roblox.*://navigation/visibility_subsettings")
game:DefineFastString("ParentalControlsDeepLinkPattern", "roblox.*://navigation/parental_controls")
game:DefineFastString("AccountInfoDeepLinkPattern", "roblox.*://navigation/account_info")
game:DefineFastString("SpendingSettingsDeepLinkPattern", "roblox.*://navigation/spending_settings")
game:DefineFastString("RobuxSettingsDeepLinkPattern", "roblox.*://navigation/robux_settings")
game:DefineFastString("SecuritySettingsDeepLinkPattern", "roblox.*://navigation/security_settings")
game:DefineFastString(
	"SubscriptionsSettingsDeepLinkPattern",
	"roblox.*://navigation/subscriptions_settings"
)
game:DefineFastString("ExternalWebUrlDeepLinkPattern", "roblox.*://navigation/external_web_link.*")
game:DefineFastString("SecurityAlertDeepLinkPattern", "roblox.*://navigation/security_alert.*")
game:DefineFastString("ExperienceSortDeepLinkPattern", "roblox.*://navigation/experience_sort.*")
game:DefineFastString("SquadLobbyDeepLinkPattern", "roblox.*://navigation/party.*")
game:DefineFastString("EnterAppFromWidget", "roblox.*://open/widget.*")
game:DefineFastString("EnterAppFromLockScreenWidget", "roblox.*://open/lock_screen_widget")
game:DefineFastString("DevicePreferencesDeepLinkPattern", "roblox.*://navigation/device_preferences")
game:DefineFastString("LaunchDestinationDeepLinkPattern", "roblox.*://navigation/launch_destination")
game:DefineFastString("FAEDeepLinkPattern", "roblox.*://navigation/fae.*")
game:DefineFastString("FAEUpsellOverlayDeepLinkPattern", "roblox.*://navigation/fae_upsell_overlay.*")
game:DefineFastString("AmpWizardDeepLinkPattern", "roblox.*://navigation/amp_wizard.*")
game:DefineFastString("AccountUnlockDeepLinkPattern", "roblox.*://navigation/account_unlock.*")
game:DefineFastString("SystemMessageDeepLinkPattern", "roblox.*://navigation/messages.*")
game:DefineFastString("MomentsDeepLinkPattern", "roblox.*://navigation/moments.*")

game:DefineFastString("LuaExtraHttpLinkBases", "")

game:DefineFastFlag("EnableExternalWebDeeplink", false)
game:DefineFastFlag("EnableJoinLinkWebDeepLink", false)

local v5 = string.split(game:GetFastString("LuaExtraHttpLinkBases"), ",")

local result = {}

local v6 = {
	notifstream = upsellEntrySurfaceType.NotifStream,
	notifpush = upsellEntrySurfaceType.NotifPush
}

local v7 = {
	androidpinnedshortcut = "AndroidPinnedShortcut",
	iospinnedshortcut = "IosPinnedShortcut",
	windowspinnedshortcut = "WindowsPinnedShortcut",
	androidsearch = "AndroidSearch",
	iossearch = "iOSSearch",
	iossearchappintents = "iOSSearchAppIntents"
}

local function acceptedNavigationCallback(p2)
	if not fFlagNavigationCallbackParam or p2 == nil then
		return nil
	end

	if require("@luauforge/bundled/fHX")(result, p2) then
		return p2
	end

	return nil
end

local function addMapping(value, p2, p3)
	table.insert(result, { value, p2 })
	default:registerURL(value:gsub("%%", "\\"), p3)
end

local function addHttpMapping(fastString, fn, p2)
	for k, v8 in pairs({ "www", "web", "" }) do
		local v9 = UrlBuilder.new(v8)
		local v10 = UrlBuilder.new(v8, { secure = false })

		local v11 = v9 .. "(/[A-Za-z][A-Za-z](%-[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?)?)?" .. fastString
		table.insert(result, { v11, fn })
		default:registerURL(v11:gsub("%%", "\\"), p2)

		local v13 = v10 .. "(/[A-Za-z][A-Za-z](%-[A-Za-z0-9][A-Za-z0-9][A-Za-z0-9]?)?)?" .. fastString
		table.insert(result, { v13, fn })
		default:registerURL(v13:gsub("%%", "\\"), p2)
	end

	for i, v8 in ipairs(v5) do
		local v9 = v8 .. fastString
		table.insert(result, { v9, fn })
		default:registerURL(v9:gsub("%%", "\\"), p2)
	end
end

local function addConnectionsHttpMapping(fastString, fn)
	local connections = UrlBuilder.new("connections")
	local connections2 = UrlBuilder.new("connections", { secure = false })
	local v8 = connections .. fastString
	table.insert(result, { v8, fn })
	default:registerURL(v8:gsub("%%", "\\"), nil)

	local v10 = connections2 .. fastString
	table.insert(result, { v10, fn })
	default:registerURL(v10:gsub("%%", "\\"), nil)
end

local function buildHistoryFromRoute(list)
	local historyFromRoute = {}

	for i = 1, #list do
		local v8 = {}

		for j = 1, i do
			table.insert(v8, list[j])
		end

		table.insert(historyFromRoute, v8)
	end

	return historyFromRoute
end

local v8 = {
	games = searchTypes.Games,
	players = searchTypes.Players,
	topresults = searchTypes.TopResults
}

addMapping(game:GetFastString("SearchDeepLinkPattern"), function(p2)
	local v9 = searchUuid()
	local v10 = searchUuid()
	local keyword = p2.keyword or ""
	local v11 = v8[string.lower(p2.type or "")] or searchTypes.Games

	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{
				name = module2.SearchPage,
				detail = v9,
				extraProps = {
					searchKeyword = keyword,
					searchType = v11,
					omniSearchInfo = { omniSearchUuid = v10, searchKeyword = keyword }
				}
			}
		}
	}
end)

addMapping(game:GetFastString("GamesPageDeepLinkPattern"), function()
	return {
		{
			{ name = module2.Games }
		}
	}
end)

addMapping(game:GetFastString("HomePageDeepLinkPattern"), function()
	return {
		{
			{ name = module2.Home }
		}
	}
end)

if fFlagAppIaHomeCampaignDeepLink then
	local campaignEligibility = require("@luauforge/bundled/fJt").CampaignEligibility
	local flyoutSidePanelIXP = require("@luauforge/bundled/dKM").FlyoutSidePanelIXP

	addMapping(game:GetFastString("CampaignPageDeepLinkPattern"), function(p2, p3)
		if fFlagAppIaHomeSubTab and flyoutSidePanelIXP.isHomeSubTabEnabled() then
			return campaignEligibility.awaitIsEligible(p3.network):andThen(function(p4)
				if p4 then
					return {
						{
							{ name = module2.Campaign }
						}
					}
				end

				return {
					{
						{ name = module2.Home }
					}
				}
			end)
		end

		return {
			{
				{ name = module2.Home }
			}
		}
	end)
end

if fFlagAppNavMyStatsTab then
	local function isOnBuildChat(universeid, sessionid, history): boolean
		local v9 = if type(history) == "table" then history[#history] else nil
		local v10 = if type(v9) == "table" then v9[#v9] else nil

		if universeid == nil or v10 == nil or v10.name ~= module2.Build then
			return false
		end

		local activeTarget = require("@luauforge/bundled/fKd").GetCreatorAgentResumeStore().getActiveTarget(false)

		if activeTarget == nil or activeTarget.universeId ~= universeid then
			return false
		end

		return sessionid == nil
			or activeTarget.sessionId == nil
			or string.lower(activeTarget.sessionId) == sessionid
	end

	addMapping(game:GetFastString("BuildPageDeepLinkPattern"), function(data, p2)
		local universeid = tonumber(data.universeid)
		local sessionid = if data.sessionid ~= "" then data.sessionid else nil
		local v9 = fFlagBuildAdsNotificationRouting

		if v9 then
			v9 = data.type == "ads" and universeid ~= nil and universeid > 0 and universeid % 1 == 0
		end

		if v9 then
			local module37 = require("@luauforge/bundled/fKd")

			if module37.GetAdsCampaignDeepLinkStore(false).hasVisibleChat(universeid) then
				module37.requestAdsCampaign(universeid)
				return nil
			end
		end

		if
			fFlagBuildExperienceLibrary
			and isOnBuildChat(universeid, sessionid, p2 and p2.history)
			and not v9
		then
			return nil
		end

		local v10 = (universeid ~= nil or sessionid ~= nil)
			and {
				universeId = universeid,
				sessionId = sessionid,
				resumeRequestId = HttpService:GenerateGUID(false)
			}
			or nil

		if
			fFlagBuildAdUpsell
			and data.type == "ads"
			and universeid ~= nil
			and universeid > 0
			and universeid % 1 == 0
			and v10 ~= nil
		then
			v10.adsCampaignIntent = true
		end

		return {
			{
				{ name = module2.Build, extraProps = v10 }
			}
		}
	end)
end

if defineFastFlag15 and fFlagEnableArgus then
	local module37 = require("@luauforge/bundled/gev")
	local getMomentsCapabilities = require("@luauforge/bundled/fIP").Stores.GetMomentsCapabilities
	local shareLinkTargetIdType = require("@luauforge/bundled/fIQ").Enums.ShareLinkTargetIdType

	addMapping(game:GetFastString("MomentsDeepLinkPattern"), function(data)
		if not module37((getMomentsCapabilities(false).getHasMomentsAccess(false))) then
			return nil
		end

		local v9 = { source = "deeplink" }
		local feeditemid = data.feeditemid

		if feeditemid ~= nil and feeditemid ~= "" then
			v9.postId = feeditemid
			v9.targetIdType = shareLinkTargetIdType.FeedItemId

			if fFlagMomentsCommentDeepLinks then
				local commentid = data.commentid

				if commentid == nil or commentid == "" then
					if data.opencomments == "1" or data.opencomments == "true" then
						v9.openComments = true
					end
				else
					v9.commentId = commentid
					v9.openComments = true
				end
			end
		end

		return {
			{
				{ name = module2.Moments, extraProps = v9 }
			}
		}
	end)
end

if fFlagLuaAppSduiLandingPageEnabled then
	game:DefineFastString("SduiLandingPageDeepLinkPattern", "roblox.*://navigation/landing.*")

	addMapping(game:GetFastString("SduiLandingPageDeepLinkPattern"), function(p2)
		local page = p2.page

		if page == nil or page == "" then
			return
		end

		return {
			{
				{ name = module2.Home },
				{
					name = module2.SduiLandingPage,
					detail = page,
					extraProps = { pageIdentifier = page }
				}
			}
		}
	end)
end

if fFlagLuaAppSduiLandingPageEnabled and fFlagLuaEnableGenreLandingDeeplink then
	game:DefineFastString("GenreLandingDeepLinkPattern", "roblox.*://navigation/genre.*")

	addMapping(game:GetFastString("GenreLandingDeepLinkPattern"), function(data)
		if data.sortid then
			local v9, v10 = module20(data.sortid)

			local v13 = { name = module2.Home }

			local v15 = if fFlagLuaAppSortDeeplinkFix then module2.DeeplinkGamesList else module2.GamesList
			return {
				{
					v13,
					{
						name = v15,
						detail = v9,
						extraProps = {
							sortName = v9,
							pageContext = not fFlagLuaAppSortDeeplinkFix and "Deeplink" or nil,
							isOmni = v10,
							sortIndex = not fFlagLuaAppSortDeeplinkFix and v10 and 1 or nil
						}
					}
				}
			}
		else
			local page = data.page

			if page == nil or page == "" then
				return {
					{
						{ name = module2.Home }
					}
				}
			end

			return {
				{
					{ name = module2.Home },
					{
						name = module2.SduiLandingPage,
						detail = page,
						extraProps = { pageIdentifier = page, genre = data.genre }
					}
				}
			}
		end
	end)
end

addMapping(game:GetFastString("AvatarClothingSortingView"), function()
	return {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog },
			{ name = avatarScreen.LayeredClothingSort }
		}
	}
end)

if module33 then
	addMapping(game:GetFastString("AvatarProfilePictureEditor"), function()
		return {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				{ name = avatarScreen.ProfilePictureEditorEmotes }
			}
		}
	end)
end

if module33 and fFlagEditProfileImageV2Enabled and fFlagEditProfileFramesEnabled then
	addMapping(game:GetFastString("AvatarProfileFramesEditor"), function(p2)
		local v11 = { name = avatarScreen.AvatarExperienceLandingPage }
		local v12 = { name = avatarScreen.Catalog }
		local v13 = { name = avatarScreen.EditProfileImage, extraProps = 0 }

		local v15 = if module34 then p2.frameassetid else nil
		local callback = p2.callback

		if fFlagNavigationCallbackParam and callback ~= nil then
			if not require("@luauforge/bundled/fHX")(result, callback) then
				callback = nil
			end
		else
			callback = nil
		end

		v13.extraProps = {
			mode = "framesOnly",
			initialFrameAssetId = v15,
			callback = callback
		}
		return {
			{ v11, v12, v13 }
		}
	end)
end

if fFlagAXBackgroundGenerationDeepLink then
	addMapping(game:GetFastString("AvatarBackgroundGeneration"), function()
		return {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.AvatarEditor },
				{ name = avatarScreen.BackgroundGeneration }
			}
		}
	end)
end

local function getCustomizeTabCategoryIndex(customizetab)
	if customizetab == nil then
		return nil
	end

	for k, v9 in module16() do
		if string.lower(v9.Id) == customizetab then
			return k
		end
	end

	return nil
end

addMapping(game:GetFastString("AvatarDeepLinkPattern"), function(data)
	local v9

	if fFlagAXCustomizeTabDeepLink then
		v9 = getCustomizeTabCategoryIndex(data.customizetab)
	end

	local v10 = { name = avatarScreen.AvatarEditor }

	local v11 = fFlagAXCustomizeTabDeepLink and v9 and {
		name = avatarScreen.AvatarEditor,
		extraProps = { category = v9, customizeTab = data.customizetab }
	} or v10

	local v12 = {
		{ name = avatarScreen.AvatarExperienceLandingPage },
		not fFlagAXCustomizeTabDeepLink and { name = avatarScreen.AvatarEditor } or v11
	}

	if data.itemtype == "character" then
		local avatarEditorCategory, v13 = module17.findAvatarEditorCategory(
			module15.CharacterKey,
			module15.PurchasedCharacterKey
		)

		local v14 = {
			itemId = data.itemid,
			category = avatarEditorCategory,
			subcategory = v13
		}

		table.insert(v12, { name = avatarScreen.OutfitDetails, extraProps = v14 })
	elseif
		data.itemtype == "asset"
		and (not fFlagAXCustomizeTabDeepLink or not v9 or data.itemid ~= nil and data.itemid ~= "")
	then
		local v13, v14 = module17.getCategoryIndicesFromAssetType(data.itemsubtype)

		if fFlagAXCustomizeTabDeepLink and v9 then
			v13 = v9
			v14 = nil
		end

		local customizetabsByCustomizeTab = {
			itemId = data.itemid,
			itemType = module5.ItemType.Asset,
			mountAsFullView = true,
			category = v13,
			subcategory = v14,
			opaquePage = avatarScreen.AvatarEditor
		}

		if fFlagAXCustomizeTabDeepLink and v9 then
			customizetabsByCustomizeTab[navigationParams.customizeTab] = data.customizetab
		end

		table.insert(v12, {
			name = avatarScreen.ItemDetails,
			extraProps = customizetabsByCustomizeTab
		})
	end

	return buildHistoryFromRoute(v12)
end)

addHttpMapping(game:GetFastString("AvatarHttpPattern"), function(p2, p3)
	return Cryo.List.join(p3.history, {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage }
		},
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.AvatarEditor }
		}
	})
end)

addMapping(game:GetFastString("MorePageDeepLinkPattern"), function()
	local v12 = if module36 then module2.Home else module2.More
	return {
		{
			{ name = v12 }
		}
	}
end)

local function subSettingsMapping(p2, p3, p4)
	local v12 = if module36 then module2.Home else module2.More

	local v15 = if module36 then module2.Home else module2.More
	local v13 = {
		{ name = v15 },
		{ name = module2.Settings }
	}

	local v18 = if module36 then module2.Home else module2.More
	return {
		{
			{ name = v12 }
		},
		v13,
		{
			{ name = v18 },
			{ name = module2.Settings },
			{
				name = p4 or module2.SettingsSubPage,
				detail = p2,
				extraProps = { titleKey = p3, transitionAnimation = module12.None }
			}
		}
	}
end

addMapping(game:GetFastString("NotificationSettingsDeepLinkPattern"), function(p2)
	local v9 = module14.static.settings.notifications()

	if defineFastFlag10 and p2 then
		local category = if p2.category ~= "" then p2.category else nil
		local kind = if p2.type ~= "" then p2.type else nil

		if category and kind then
			v9 ..= "/" .. category .. "/" .. kind
		elseif category then
			v9 ..= "/" .. category
		end
	end

	return subSettingsMapping(v9, "Feature.AccountSettings.Heading.Tab.Notifications")
end)

if fFlagEnableNotificationsDeeplink then
	addMapping(game:GetFastString("NotificationsDeepLinkPattern"), function()
		if fFlagStreamNotificationDropdownSingleOwner then
			streamNotificationStore.setActiveBellId(streamNotificationStore.PrimaryBellId)
		end

		streamNotificationStore.setStreamPresented(true)

		if fFlagStreamNotificationDropdownSingleOwner and defineFastFlag11 then
			return {
				{
					{ name = module2.Home }
				}
			}
		end

		return nil
	end)
end

local function getChatEntryPointEnum(entrypoint)
	if type(entrypoint) ~= "string" then
		return chatEntryPointNames.Unknown
	end

	for k, chatEntryPointName in pairs(chatEntryPointNames) do
		if string.lower(k) == string.lower(entrypoint) then
			return chatEntryPointName
		end
	end

	return chatEntryPointNames.Unknown
end

addMapping(game:GetFastString("RoactChatDeepLinkPattern"), function(data, p2)
	local v9 = {
		entryPoint = getChatEntryPointEnum(data.entrypoint)
	}

	if data.chatid == nil and data.userid ~= nil then
		return createConversation(p2.network, "one_to_one", { data.userid }):andThen(function(p3)
			local id = tostring(p3.responseBody.conversations[1].id)
			return {
				{
					{ name = module2.Chat, detail = id, extraProps = v9 }
				}
			}
		end):catch(function()
			return {
				{
					{ name = module2.Chat, extraProps = v9 }
				}
			}
		end)
	end

	return {
		{
			{ name = module2.Chat, detail = data.chatid, extraProps = v9 }
		}
	}
end)

addMapping(game:GetFastString("GameDetailsDeepLinkPattern"), function(data)
	local gameDetail = module2.GameDetail

	local v9 = if defineFastFlag16 and data.context then v7[data.context] else nil

	if fFlagEnableShareLinksInGameDetailEvent then
		module6(data.gameid, defineFastFlag16 and v9 or "GameDetailsDeeplink", {})
	else
		module6(data.gameid, defineFastFlag16 and v9 or "GameDetailsDeeplink")
	end

	if not data.homeroot then
		return {
			{
				{ name = module2.Games }
			},
			{
				{ name = module2.Games },
				{
					name = gameDetail,
					detail = module4.isNotNil(data.gameid, "gameId"),
					extraProps = { mountAsFullView = true, mountAnimation = false }
				}
			}
		}
	end

	local v10

	if fFlagLuaAppSupportDeviceSafeInsets then
		v10 = hardwareSafeAreaInsets.fullscreenGui().AbsoluteSize
	else
		v10 = Workspace.CurrentCamera and Workspace.CurrentCamera.ViewportSize or Vector2.zero
	end

	local v11

	if v10.Y > v10.X and useGameDetailsPeekView() then
		v11 = module2.GameDetail

		if defineFastFlag18 then
			module9("defaultGameDetail")
		end
	elseif defineFastFlag17 then
		v11 = module2.GameDetail

		if defineFastFlag18 then
			module9("overrideExperienceDetailToGameDetail")
		end
	else
		v11 = module2.ExperienceDetail

		if defineFastFlag18 then
			module9("defaultExperienceDetail")
		end
	end

	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{
				name = v11,
				detail = module4.isNotNil(data.gameid, "gameId"),
				extraProps = {
					mountAsFullView = data.fullview == "true",
					mountAnimation = true
				}
			}
		}
	}
end)

addHttpMapping(game:GetFastString("GameDetailsHttpPattern"), function(placeId, p2, p3)
	if p2.privateserverlinkcode == nil then
		local gameDetail = module2.GameDetail

		return gamesMultigetPlaceDetails(p3.network, placeId):andThen(function(p4)
			local universeId = tostring(p4.responseBody[1].universeId)

			if fFlagEnableShareLinksInGameDetailEvent then
				module6(universeId, "GameDetailsHTTPDeepLink", {})
			else
				module6(universeId, "GameDetailsHTTPDeepLink")
			end

			return {
				{
					{ name = module2.Games }
				},
				{
					{ name = module2.Games },
					{
						name = gameDetail,
						detail = universeId,
						extraProps = { mountAsFullView = true, mountAnimation = false }
					}
				}
			}
		end)
	end

	p3.analyticsImpls.shareLinksAnalytics.openAppViaShareLink({
		placeId = placeId,
		linkCode = p2.privateserverlinkcode,
		linkType = module11.LongPrivateServerLink
	})

	if type(placeId) ~= "number" then
		placeId = tonumber(placeId)
	end

	experienceService:LaunchExperience({
		placeId = placeId,
		linkCode = p2.privateserverlinkcode
	})

	return nil
end)

addHttpMapping(game:GetFastString("GameDetailsReferralHttpPattern"), function(p2, p3)
	local notNil = module4.isNotNil(p2.placeid, "placeid")
	local gameDetail = module2.GameDetail

	return gamesMultigetPlaceDetails(p3.network, notNil):andThen(function(p4)
		local universeId = tostring(p4.responseBody[1].universeId)

		if fFlagEnableShareLinksInGameDetailEvent then
			module6(universeId, "GameDetailsHTTPReferralDeepLink", {})
		else
			module6(universeId, "GameDetailsHTTPReferralDeepLink")
		end

		return {
			{
				{ name = module2.Games }
			},
			{
				{ name = module2.Games },
				{
					name = gameDetail,
					detail = universeId,
					extraProps = { mountAsFullView = true, mountAnimation = false }
				}
			}
		}
	end)
end)

addMapping(game:GetFastString("ProfileCardDeepLinkPattern"), function(p2)
	local userid = p2.userid or ""

	return {
		{
			{ name = module2.Home },
			{
				name = module2.ProfilePlatform,
				detail = userid,
				extraProps = { source = module10.Sources.ProfileDeepLink }
			}
		}
	}
end)

if fFlagTCParentChildAutoUpgrade then
	addMapping(game:GetFastString("ProfileTrustedFriendsDeepLinkPattern"), function(p2, p3)
		local userid = p2.userid or ""

		return {
			{
				{ name = module2.Home },
				{
					name = module2.ProfilePlatform,
					detail = userid,
					extraProps = { source = module10.Sources.ProfileDeepLink }
				},
				{
					name = module2.TrustedContactsModal,
					props = {
						userId = userid,
						source = "Deeplink_Profile_TrustedFriends"
					}
				}
			}
		}
	end)
end

addMapping(game:GetFastString("ProfileDeepLinkPattern"), function(p2, p3)
	local notNil = module4.isNotNil(p2.userid, "userId")
	local friendshipsourcetype = p2.friendshipsourcetype
	local profile = module14.user.profile({
		userId = notNil,
		sourceType = friendshipsourcetype
	})

	if friendshipsourcetype == "profileshare" then
		p3.analyticsImpls.socialProfileShareAnalytics.inviteePageLoad(notNil, "playerProfile")
	end

	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{
				name = module2.GenericWebPage,
				detail = profile,
				extraProps = {
					titleKey = "CommonUI.Features.Label.Profile",
					transitionAnimation = module12.None
				}
			}
		}
	}
end)

addMapping(game:GetFastString("GroupsDeepLinkPattern"), function(data)
	local v9

	if
		data.forumcategoryid
		and data.forumcategoryid ~= ""
		and data.forumpostid
		and data.forumpostid ~= ""
		and data.forumcommentid
		and data.forumcommentid ~= ""
	then
		local forumComment = module14.user.forumComment
		local v10 = {
			groupId = module4.isNotNil(data.groupid, "groupId"),
			categoryId = 0,
			postId = 0,
			commentId = 0
		}

		local v11 = if fFlagLuaAppForumsDeeplinkFix then "category-" .. module4.isNotNil(data.forumcategoryid, "categoryId") else module4.isNotNil(data.forumcategoryid, "categoryId")
		v10.categoryId = v11

		local v12 = if fFlagLuaAppForumsDeeplinkFix then "post-" .. module4.isNotNil(data.forumpostid, "postId") else module4.isNotNil(data.forumpostid, "postId")
		v10.postId = v12

		v10.commentId = module4.isNotNil(data.forumcommentid, "commentId")
		v9 = forumComment(v10)
	else
		v9 = module14.user.group({
			groupId = module4.isNotNil(data.groupid, "groupId")
		})
	end

	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{
				name = module2.GenericWebPage,
				detail = v9,
				extraProps = {
					titleKey = getFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.Groups" or "CommonUI.Features.Label.sGroups",
					transitionAnimation = module12.None
				}
			}
		}
	}
end)

if fFlagEnableCommunitiesHttpDeepLink then
	local function fn(p2, value, p3, p4)
		if defineFastFlag19 then
			ixpServiceWrapper:LogFlagLinkedUserLayerExposure(defineFastString)
		end

		local v9 = string.find(value, "#!")
		local flag = true

		if v9 then
			local v10 = string.sub(value, v9 + 2)

			if v10 ~= "/about" and v10 ~= "" then
				flag = false
			end
		end

		if flag then
			return {
				{
					{ name = module2.Home },
					{
						name = module2.ProfilePlatform,
						detail = p2,
						extraProps = {
							profileType = module10.ProfileTypes.Community,
							source = module10.Sources.ProfileDeepLink
						}
					}
				}
			}
		end

		local formatted = `{module13.new("www")}/communities/{p2}{value}`
		return {
			{
				{ name = module2.Home },
				{
					name = module2.GenericWebPage,
					detail = formatted,
					extraProps = {
						titleKey = getFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.Groups" or "CommonUI.Features.Label.sGroups",
						transitionAnimation = module12.None
					}
				}
			}
		}
	end

	addHttpMapping(game:GetFastString("CommunitiesHttpPattern"), fn, {
		engineHandlingPolicy = "ExternalOriginOnly"
	})

	addHttpMapping(game:GetFastString("GroupsHttpPattern"), fn, {
		engineHandlingPolicy = "ExternalOriginOnly"
	})
end

addMapping(game:GetFastString("ContactsDeepLinkPattern"), function(p2, p3)
	local v9

	if p2.contactid and p2.contactid ~= "" then
		v9 = {
			name = module2.ProfilePlatform,
			detail = p2.contactid,
			extraProps = { profileType = constants.CONTACT }
		}
	else
		v9 = { name = 0, detail = "", extraProps = 0 }
		local v10

		if fFlagCiDeprecateFindFriendsModal then
			v10 = module2.ContactImporter
		elseif contactImporterModalInfo:isUserOptedInLocalStorage(
			AppStorageService,
			not (localPlayer and localPlayer.UserId) and "" or tostring(localPlayer.UserId)
		) then
			v10 = module2.ContactsList
		else
			v10 = module2.ContactImporter
		end

		v9.name = v10

		local v12 = if fFlagCiDeprecateFindFriendsModal then p2.entryPoint else nil
		v9.extraProps = { isPhoneVerified = true, entryPoint = v12 }
	end

	return { if fFlagCiDeprecateFindFriendsModal then {
			{ name = module2.Home },
			v9
		} else {
			{ name = module2.Home },
			{ name = module2.AddFriendsPage },
			v9
		} }
end)

addHttpMapping(game:GetFastString("StaticShareLinkHttpPattern"), function(p2, p3, p4, p5)
	return module23(p2, p3, Cryo.Dictionary.join(p4, { isViaAppsFlyer = false }), p5)
end)

local function fn(p2, p3)
	return module22(Cryo.Dictionary.join(p2, { isViaAppsFlyer = false }), p3, true)
end

addConnectionsHttpMapping(game:GetFastString("ShareLinkHttpPattern"), fn)
addConnectionsHttpMapping(game:GetFastString("ShortShareLinkHttpPattern"), fn)

addMapping(game:GetFastString("StaticShareLinkDeepLinkPattern"), function(p2, p3, p4, p5)
	return module23(p2, p3, Cryo.Dictionary.join(p4, { isViaAppsFlyer = true }), p5)
end)

addMapping(game:GetFastString("ShareLinkDeepLinkPattern"), function(p2, p3)
	return module22(Cryo.Dictionary.join(p2, { isViaAppsFlyer = true }), p3)
end)

local function fn2(p2, p3)
	return module22(Cryo.Dictionary.join(p2, { isViaAppsFlyer = false }), p3)
end

addHttpMapping(game:GetFastString("ShareLinkHttpPattern"), fn2)
addHttpMapping(game:GetFastString("ShortShareLinkHttpPattern"), fn2)

if game:GetFastFlag("EnableJoinLinkWebDeepLink") then
	addHttpMapping(game:GetFastString("JoinLinkHttpPattern"), function(p2, p3, p4)
		return module24(p2, p3, p4)
	end)
end

addMapping(game:GetFastString("CatalogEquipDeepLinkPattern"), function(p2)
	local v9 = {
		itemId = p2.itemid,
		itemType = p2.itemtype,
		wasItemEquipped = false,
		fetchItemFailed = false
	}

	return {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage }
		},
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog, extraProps = v9 }
		}
	}
end)

addMapping(game:GetFastString("CatalogSearchDeepLinkPattern"), function(data)
	local v10 = {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage }
		}
	}
	local v9 = {
		["creatorName"] = data.creatorname,
		minPrice = data.minprice,
		maxPrice = data.maxprice,
		salesTypeFilter = data.salestypefilter,
		includeNotForSale = data.includenotforsale,
		sortType = data.sorttype,
		sortAggregation = data.sortaggregation,
		category = data.category,
		subcategory = data.subcategory,
		taxonomy = data.taxonomy,
		keyword = data.keyword,
		topics = data.topics,
		wearTimeFilter = data.wearTimeFilter
	}

	if v9.keyword then
		table.insert(v10, {
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.CatalogSearch, extraProps = v9 }
		})
		return v10
	end

	table.insert(v10, {
		{ name = avatarScreen.AvatarExperienceLandingPage },
		{ name = avatarScreen.Catalog, extraProps = v9 }
	})

	return v10
end)

addMapping(game:GetFastString("ExperienceSortDeepLinkPattern"), function(p2, ...)
	if not p2.sortId then
		return
	end

	local v9, v10 = module20(p2.sortId)

	local v13 = { name = module2.Home }

	local v15 = if fFlagLuaAppSortDeeplinkFix then module2.DeeplinkGamesList else module2.GamesList
	return {
		{
			v13,
			{
				name = v15,
				detail = v9,
				extraProps = {
					sortName = v9,
					pageContext = not fFlagLuaAppSortDeeplinkFix and "Deeplink" or nil,
					isOmni = v10,
					sortIndex = not fFlagLuaAppSortDeeplinkFix and v10 and 1 or nil
				}
			}
		}
	}
end)

addMapping(game:GetFastString("CatalogDeepLinkPattern"), function()
	return {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage }
		},
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog }
		}
	}
end)

addMapping(game:GetFastString("ItemDetailsDeepLinkPattern"), function(p2)
	local notNil = module4.isNotNil(p2.itemid, "itemId")

	local notNil2 = module4.isNotNil(p2.itemtype, "itemType")
	local v9 = nil

	for k, v11 in pairs(module5.ItemType) do
		if string.lower(notNil2) == string.lower(v11) then
			v9 = v11
			break
		end
	end

	local v11 = {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage }
		},
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog }
		}
	}

	local v12 = tostring(v9) .. tostring(notNil)
	local v13 = avatarScreen.ItemDetails

	if module32 and v9 == module5.ItemType.Look then
		v13 = avatarScreen.LookDetails
	end

	local v14 = {
		name = v13,
		detail = v12,
		extraProps = {
			itemId = notNil,
			itemType = v9,
			mountAsFullView = true,
			mountAnimation = false
		}
	}

	if v9 ~= nil then
		table.insert(v11, {
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog },
			v14
		})
	end

	return v11
end)

addHttpMapping(game:GetFastString("ItemDetailsHttpPattern"), function(p2, p3, p4)
	local asset = module5.ItemType.Asset
	local v9 = asset .. p2

	return Cryo.List.join(p4.history, {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog }
		}
	}, {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog },
			{
				name = avatarScreen.ItemDetails,
				detail = v9,
				extraProps = {
					itemId = p2,
					itemType = asset,
					mountAsFullView = true,
					mountAnimation = false
				}
			}
		}
	})
end)

if defineFastFlag13 then
	addHttpMapping(game:GetFastString("BundleItemDetailsHttpPattern"), function(p2, p3, p4)
		local bundle = module5.ItemType.Bundle
		local v9 = bundle .. p2
		local history = p4.history
		return Cryo.List.join(history, {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				{
					name = avatarScreen.ItemDetails,
					detail = v9,
					extraProps = {
						itemId = p2,
						itemType = bundle,
						mountAsFullView = true,
						mountAnimation = false
					}
				}
			}
		})
	end)
end

if module32 then
	addHttpMapping(game:GetFastString("LookItemDetailsHttpPattern"), function(p2, p3, p4)
		local v9 = module5.ItemType.Look .. p2
		local history = p4.history

		return Cryo.List.join(history, {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				{
					name = avatarScreen.LookDetails,
					detail = v9,
					extraProps = { itemId = p2, mountAsFullView = true }
				}
			}
		})
	end)
end

if module26 then
	addMapping(game:GetFastString("ItemRedemptionDeepLinkPattern"), function(p2)
		local notNil = module4.isNotNil(p2.itemid, "itemId")

		local notNil2 = module4.isNotNil(p2.itemtype, "itemType")
		local v9 = nil

		for k, v11 in pairs(module5.ItemType) do
			if string.lower(notNil2) == string.lower(v11) then
				v9 = v11
				break
			end
		end

		local v11 = {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage }
			},
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog }
			}
		}

		local v12 = tostring(v9) .. tostring(notNil)
		local v13 = {
			name = avatarScreen.ItemDetails,
			detail = v12,
			extraProps = {
				itemId = notNil,
				itemType = v9,
				mountAsFullView = true,
				mountAnimation = false,
				redeemQRCodeItem = true
			}
		}

		if v9 ~= nil then
			table.insert(v11, {
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{ name = avatarScreen.Catalog },
				v13
			})
		end

		return v11
	end)
end

addHttpMapping(game:GetFastString("CatalogHttpPattern"), function(p2, p3)
	if module35 then
		return Cryo.List.join(p3.history, {
			{
				{ name = avatarScreen.AvatarExperienceLandingPage },
				{
					name = avatarScreen.Catalog,
					extraProps = module18.convertCatalogSearchParamsV1ToV2(p2)
				}
			}
		})
	end

	return Cryo.List.join(p3.history, {
		{
			{ name = avatarScreen.AvatarExperienceLandingPage },
			{ name = avatarScreen.Catalog }
		}
	})
end)

local function fn3(p2)
	local filter = if p2.filter and p2.filter ~= "" then p2.filter else nil

	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{
				name = module2.ViewFriends,
				extraProps = fFlagFriendsDeepLinkInitialFilter and filter and {
					initialFilter = filter
				} or nil
			}
		}
	}
end

addMapping(game:GetFastString("FriendsPageDeepLinkPattern"), fn3)

if fFlagFriendsDeepLinkInitialFilter then
	addMapping(game:GetFastString("FriendsPageWithQueryDeepLinkPattern"), fn3)
end

if fFlagEnablePlusUpsellDeepLink then
	addMapping(game:GetFastString("PlusUpsellDeepLinkPattern"), function(): nil
		module21.initiateRobloxSubscriptionPurchase(
			nil,
			nil,
			nil,
			surfaceName.DeepLinkUpsell,
			surfaceContext.InApp
		)

		return nil
	end)
end

if fFlagEnablePlusReferralDashboardDeepLink then
	addMapping(game:GetFastString("PlusReferralDashboardDeepLinkPattern"), function()
		return {
			{
				{ name = module2.Home }
			},
			{
				{ name = module2.Home },
				{ name = module2.PlusReferralDashboard }
			}
		}
	end)
end

local module37 = require("@luauforge/bundled/gew")

if fFlagEnablePlusReferralLandingSheet then
	addMapping(game:GetFastString("PlusSubscribeDeepLinkPattern"), function(data): nil
		local referrer_id = if data.referrer_id then tonumber(data.referrer_id) or nil else nil
		local surface = data.surface or "DeepLinkUpsell"
		local entrypoint

		if fFlagEnablePlusReferralEntrypointTelemetry then
			entrypoint = data.entrypoint or module21.Entrypoint.DeepLink
		else
			entrypoint = nil
		end

		local v9 = fFlagPlusSubscribeDeepLinkIncludeUpgrades and {
			includeUpgrades = string.lower(data.includeUpgrades or data.includeupgrades or "") == "true"
		} or nil

		if not module30 then
			module21.initiateRobloxSubscriptionPurchase(
				nil,
				nil,
				nil,
				surface,
				surfaceContext.InApp,
				v9,
				entrypoint and { entrypoint = entrypoint } or nil,
				referrer_id
			)

			return nil
		end

		local surface_context = string.lower(data.surface_context or "")
		local v10

		if surface_context == "ingame" then
			v10 = surfaceContext.InGame
		elseif surface_context == "web" then
			v10 = surfaceContext.Web
		elseif surface_context == "unspecified" then
			v10 = surfaceContext.Unspecified
		else
			v10 = surfaceContext.InApp
		end

		local openTTSheet = module21.openTTSheet
		local resetRobloxSubscriptionPurchaseConfiguration = module21.resetRobloxSubscriptionPurchaseConfiguration
		module37.routePlusSubscribe(data, {
			openClaimSheet = openTTSheet and function(p2)
				resetRobloxSubscriptionPurchaseConfiguration()

				local v11 = nil

				if data.surface and data.surface ~= "" then
					local surface2 = string.lower(data.surface)

					for k, v13 in pairs(surfaceName) do
						if string.lower(v13) == surface2 then
							v11 = v13
							break
						end
					end
				end

				openTTSheet(p2, v11, v10)
			end or nil,
			acceptCallback = acceptedNavigationCallback,
			followCallback = function(p2)
				require("@luauforge/bundled/gex")(result, p2)
			end,
			startPaidPurchase = function(data2)
				resetRobloxSubscriptionPurchaseConfiguration()

				local v11 = data2
					and {
						title = data2.title,
						description = data2.description,
						ctaText = data2.ctaText
					}
					or nil

				module21.initiateRobloxSubscriptionPurchase(
					v11,
					nil,
					nil,
					surface,
					v10,
					v9,
					entrypoint and { entrypoint = entrypoint } or nil,
					referrer_id
				)
			end
		})

		return nil
	end)
end

if defineFastFlag12 then
	addMapping(game:GetFastString("BuyRobuxDeepLinkPattern"), function(p2)
		local v9 = {}

		if p2.analyticid and p2.analyticid ~= "" then
			v9.analyticId = p2.analyticid
		end

		if p2.product_id and p2.product_id ~= "" then
			v9.productId = p2.product_id
		end

		local v11 = {
			{ name = module2.Home }
		}

		local v13 = { name = module2.Home }
		local v14 = { name = module2.PurchaseRobux, extraProps = 0 }

		if not next(v9) then
			v9 = nil
		end

		v14.extraProps = v9
		return {
			v11,
			{ v13, v14 }
		}
	end)
end

if fFlagEnableSchoolEntry then
	addMapping(game:GetFastString("AddSchoolDeepLinkPattern"), function(p2)
		local v9 = {}

		if p2.source and p2.source ~= "" then
			v9.source = p2.source
		end

		local v10

		if fFlagSchoolDeepLinkUseConnectionsHub then
			v10 = module2.ConnectionsHub
		else
			v10 = module2.AddFriendsPage
		end

		local v13 = { name = module2.Home }

		local v15 = { name = module2.Schools, extraProps = 0 }

		if not next(v9) then
			v9 = nil
		end

		v15.extraProps = v9
		return {
			{
				v13,
				{ name = v10 },
				v15
			}
		}
	end)
end

if module28() then
	addMapping(game:GetFastString("GiftCardsPageDeepLinkPattern"), function()
		return {
			{
				{ name = module2.Home }
			},
			{
				{ name = module2.Home },
				{
					name = module2.GenericWebPage,
					detail = module14.static.giftCards(),
					extraProps = {
						titleKey = "CommonUI.Features.Label.GiftCards",
						transitionAnimation = module12.None
					}
				}
			}
		}
	end)
end

local function handleCurrencyTransferLink(data, p2)
	local direction = data.direction

	if not direction or direction ~= "send" and direction ~= "receive" then
		return nil
	end

	if direction == "send" then
		if not data.userid or data.userid == "" then
			return nil
		end

		if fFlagCurrencyTransferDeepLinkValidateSender and data.senderid and data.senderid ~= "" then
			local userId

			if localPlayer and localPlayer.UserId and localPlayer.UserId ~= 0 then
				userId = tostring(localPlayer.UserId)
			end

			if userId == nil or userId ~= data.senderid then
				return nil
			end
		end
	elseif not data.transferrequestid or data.transferrequestid == "" then
		return nil
	end

	local v9 = { direction = direction }

	if direction == "send" then
		v9.recipientUserId = data.userid

		if data.transferorigination then
			v9.transferOrigination = data.transferorigination
		end
	else
		v9.transferId = data.transferrequestid

		if fFlagSduiOpenIncomingTransferUpsellAction then
			local promptid = data.promptid

			if promptid ~= nil and promptid ~= "" then
				v9.homepagePromptId = promptid
			end
		end
	end

	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{ name = module2.TransferRobuxFlow, extraProps = v9 }
		}
	}
end

if fFlagEnableCurrencyTransferDeepLink then
	addMapping(game:GetFastString("CurrencyTransferDeepLinkPattern"), handleCurrencyTransferLink)
end

if module31() then
	addMapping(game:GetFastString("SystemMessageDeepLinkPattern"), function()
		return {
			{
				{ name = module2.Home }
			},
			{
				{ name = module2.Home },
				{
					name = module2.GenericWebPage,
					detail = module14.static.messages(),
					extraProps = {
						titleKey = "CommonUI.Features.Label.Messages",
						transitionAnimation = module12.None
					}
				}
			}
		}
	end)
end

if game:GetFastFlag("EnableExternalWebDeeplink") then
	addMapping(game:GetFastString("ExternalWebUrlDeepLinkPattern"), function(p2)
		local v9, v10

		if p2.domain == module19.ExternalWebDomainEnum.Zendesk then
			v9 = module19.getZendeskUrl(p2)
			v10 = module19.getZendeskWebViewTitleKey(p2.type)
		end

		if v9 then
			return {
				{
					{ name = module2.Home }
				},
				{
					{ name = module2.Home },
					{
						name = module2.GenericWebPage,
						detail = v9,
						extraProps = {
							titleKey = v10,
							transitionAnimation = module12.None
						}
					}
				}
			}
		end

		return nil
	end)
end

if module27() then
	addMapping(game:GetFastString("CrossDeviceLoginDeepLinkPattern"), function(p2)
		local notNil = module4.isNotNil(p2.code, "code")
		local source = p2.source

		local v12 = if module36 then module2.Home else module2.More
		return {
			{
				{ name = v12 },
				{
					name = module2.CrossDeviceLogin,
					extraProps = { code = notNil, source = source }
				}
			}
		}
	end)
end

addMapping(game:GetFastString("EventDetailsPageDeepLinkPattern"), function(p2)
	return {
		{
			{ name = module2.Home }
		},
		{
			{ name = module2.Home },
			{
				name = module2.EventDetails,
				detail = module4.isNotNil(p2.eventid, "eventid")
			}
		}
	}
end)

addMapping(game:GetFastString("AppealsPortalDeepLinkPattern"), function(p2)
	local v12 = if module36 then module2.Home else module2.More
	local v13 = { name = module2.GenericWebPage, detail = 0, extraProps = 0 }
	local v14 = if p2.vid then module14.static.appealsPortal.violation({
		id = p2.vid,
		source = "deeplink"
	}) else module14.static.appealsPortal.main({ source = "deeplink" })
	v13.detail = v14

	v13.extraProps = { titleKey = "Feature.AppealsPortal.Label.ReportAndAppeals" }
	return {
		{
			{ name = v12 },
			v13
		}
	}
end)

if getFFlagEnableSupportCenter() then
	addMapping(game:GetFastString("SupportCenterDeepLinkPattern"), function(data)
		local ticketid = data.ticketid or data.ticketId
		local universeid = data.universeid or data.universeId
		local v9 = if universeid and universeid ~= "" then tonumber(universeid) else nil
		local v10

		if ticketid and ticketid ~= "" and v9 then
			v10 = module14.static.supportCenter.ticket({
				universeId = v9,
				ticketId = ticketid
			})
		else
			v10 = module14.static.supportCenter.main()
		end

		local v14 = if module36 then module2.Home else module2.More
		return {
			{
				{ name = v14 },
				{
					name = module2.GenericWebPage,
					detail = v10,
					extraProps = { titleKey = "CommonUI.Features.Label.SupportCenter" }
				}
			}
		}
	end)
end

if defineFastFlag then
	addMapping(game:GetFastString("PrivacySettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.privacy(),
			"Feature.AccountSettings.Heading.Tab.Privacy"
		)
	end)
end

if defineFastFlag9 then
	addMapping(game:GetFastString("AppPermissionsSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.appPermissions(),
			"Feature.AccountSettings.Heading.Tab.AppPermissions"
		)
	end)

	addMapping(game:GetFastString("ScreentimeSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.screentimeSettings(),
			"Feature.AccountSettings.Heading.ScreenTime"
		)
	end)

	addMapping(game:GetFastString("CommunicationSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.communicationSettings(),
			"Feature.AccountSettings.Heading.Communications"
		)
	end)

	addMapping(game:GetFastString("BlockedUsersSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.blockedUsersSettings(),
			"Feature.AccountSettings.Heading.BlockedUsersV2"
		)
	end)

	addMapping(game:GetFastString("BlockedExpSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.blockedExperiencesSettings(),
			"Feature.AccountSettings.Heading.BlockedExperiences"
		)
	end)

	addMapping(game:GetFastString("ExperienceChatSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.experienceChatSettings(),
			"Feature.AccountSettings.Heading.ExperienceChat"
		)
	end)

	addMapping(game:GetFastString("PartySettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.partySettings(),
			"Feature.AccountSettings.Label.Party"
		)
	end)

	addMapping(game:GetFastString("VoiceSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.voiceSettings(),
			"Feature.AccountSettings.Heading.VoiceChat"
		)
	end)

	addMapping(game:GetFastString("TradingInventorySettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.tradingInventorySettings(),
			"Feature.AccountSettings.Heading.TradingAndInventory"
		)
	end)

	addMapping(game:GetFastString("FriendsContactsSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.friendsContactsSettings(),
			"Feature.AccountSettings.Heading.FriendsAndContacts"
		)
	end)

	addMapping(game:GetFastString("PrivateServerSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.privateServerSettings(),
			"Feature.AccountSettings.Heading.PrivateServers"
		)
	end)

	addMapping(game:GetFastString("VisibilitySettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.visibilitySettings(),
			"Feature.AccountSettings.Heading.Visibility"
		)
	end)
end

if defineFastFlag2 then
	addMapping(game:GetFastString("ParentalControlsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.parentalControls(),
			"Feature.AccountSettings.Heading.Tab.ParentalControls"
		)
	end)
end

if defineFastFlag3 then
	addMapping(game:GetFastString("AccountInfoDeepLinkPattern"), function()
		local account = module14.static.settings.account()
		local v9 = if module29 then module2.AccountInfo else nil
		return subSettingsMapping(account, "Feature.AccountSettings.Heading.Tab.AccountInfo", v9)
	end)
end

addMapping(game:GetFastString("SpendingSettingsDeepLinkPattern"), function()
	return subSettingsMapping(
		module14.static.settings.billing(),
		"Feature.AccountSettings.Heading.Tab.Billing"
	)
end)

if defineFastFlag4 then
	addMapping(game:GetFastString("RobuxSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.robux(),
			"Feature.AccountSettings.Heading.Tab.Robux"
		)
	end)
end

if defineFastFlag5 then
	addMapping(game:GetFastString("SecuritySettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.security(),
			"Feature.AccountSettings.Heading.Tab.Security"
		)
	end)
end

if defineFastFlag6 then
	addMapping(game:GetFastString("SubscriptionsSettingsDeepLinkPattern"), function()
		return subSettingsMapping(
			module14.static.settings.subscriptions(),
			"Feature.AccountSettings.Heading.Tab.Subscriptions"
		)
	end)
end

if defineFastFlag7 then
	addMapping(
		game:GetFastString("DevicePreferencesDeepLinkPattern") .. (module25 and ".*" or ""),
		function(p2)
			local callback = p2.callback

			if fFlagNavigationCallbackParam and callback ~= nil then
				if not require("@luauforge/bundled/fHX")(result, callback) then
					callback = nil
				end
			else
				callback = nil
			end

			local v12 = if module36 then module2.Home else module2.More
			return {
				{
					{ name = v12 },
					{ name = module2.Settings },
					{
						name = module2.Accessibility,
						extraProps = callback ~= nil and { callback = callback } or nil
					}
				}
			}
		end
	)
end

if module25 then
	addMapping(game:GetFastString("RobloxSubscriptionOnboardingSheetDeepLinkPattern"), function()
		require("@luauforge/bundled/gey").request()
		return {
			{
				{ name = module2.Home }
			}
		}
	end)
end

if defineFastFlag8 then
	addMapping(game:GetFastString("LaunchDestinationDeepLinkPattern"), function()
		local v12 = if module36 then module2.Home else module2.More
		return {
			{
				{ name = v12 },
				{ name = module2.Settings },
				{ name = module2.Accessibility }
			}
		}
	end)
end

if getFFlagEnableSecurityAlertDeeplink() then
	addMapping(game:GetFastString("SecurityAlertDeepLinkPattern"), function(data, p2)
		if not data.payload or data.payload == "" or not data.username or data.username == "" then
			return {
				{
					{ name = module2.Home }
				}
			}
		end

		local v9 = if getFFlagGenerateLinkWithChannel() then module14.static.securityAlertWithChannel({
			payload = data.payload,
			username = data.username,
			channel = data.channel or ""
		}) else module14.static.securityAlert({
			payload = data.payload,
			username = data.username
		})

		return {
			{
				{ name = module2.Home }
			},
			{
				{ name = module2.Home },
				{
					name = module2.SecurityAlertInfo,
					detail = v9,
					extraProps = { transitionAnimation = module12.None }
				}
			}
		}
	end)
end

addMapping(game:GetFastString("SquadLobbyDeepLinkPattern"), function(p2, p3)
	local notNil = module4.isNotNil(p2.partyid, "partyId")
	return {
		{
			{
				name = module2.SquadLobby,
				detail = notNil,
				extraProps = fFlagEnableSquadDeeplinkWithChatId and {
					conversationId = p2.chatid
				} or nil
			}
		}
	}
end)

addMapping(game:GetFastString("FAEUpsellOverlayDeepLinkPattern"), function(p2)
	local v9 = v6[module4.isNotNil(p2.source, "source")] or ""
	local v10 = p2.is_phase2 == "true"

	return {
		{
			{
				name = module2.FAEUpsellOverlay,
				extraProps = { source = v9, isPhase2 = v10 }
			}
		}
	}
end)

if fFlagEnableAmpV2Wizard then
	addMapping("roblox.*://navigation/odp_checkpoint_resume.*", module.getOdpCheckpointDeepLinkRoute)
end

addMapping(game:GetFastString("FAEDeepLinkPattern"), function(p2)
	local v9 = v6[module4.isNotNil(p2.source, "source")] or ""

	return {
		{
			{
				name = module2.FAE,
				extraProps = { source = v9 }
			}
		}
	}
end)

if fFlagEnableAmpWizardDeepLink then
	addMapping(game:GetFastString("AmpWizardDeepLinkPattern"), function(data)
		local notNil = module4.isNotNil(data.feature_name, "feature_name")

		local v11 = { name = module2.AmpWizardContainer, extraProps = 0 }
		local v12 = {
			featureName = notNil,
			nameSpace = data.namespace,
			entryPointEventCtx = data.entry_point,
			returnPage = data.returnpage,
			targetUserId = 0
		}
		local v13 = if fFlagEnableAmpWizardDeepLinkValidateUserId then data.user_id else nil
		v12.targetUserId = v13
		v11.extraProps = v12
		return {
			{ v11 }
		}
	end)
end

if fFlagEnableAccountUnlockDeepLink then
	addMapping(game:GetFastString("AccountUnlockDeepLinkPattern"), function(p2)
		local v9 = if fFlagAccountUnlockAllowMissingUserId then p2.user_id else module4.isNotNil(p2.user_id, "user_id")

		return {
			{
				{ name = module2.Home },
				{
					name = module2.AccountUnlock,
					extraProps = { targetUserId = v9 }
				}
			}
		}
	end)
end

if defineFastFlag14 then
	addMapping(game:GetFastString("EnterAppFromWidget"), function(p2): nil
		module7("Default", p2.entry_point)
		return nil
	end)
end

addMapping(game:GetFastString("EnterAppFromLockScreenWidget"), function(p2, p3): nil
	module8("Default")
	return nil
end)

if fFlagEnablePlusWebviewDeepLink then
	local v9 = UrlBuilder.new("www") .. "/plus"

	local function plusWebviewHandler(p2, p3)
		return {
			{
				{ name = module2.Home }
			},
			{
				{ name = module2.Home },
				{
					name = module2.GenericWebPage,
					rnKey = "",
					detail = v9,
					extraProps = {}
				}
			}
		}
	end

	addMapping(game:GetFastString("PlusWebviewDeepLinkPattern"), plusWebviewHandler)
end

return result
