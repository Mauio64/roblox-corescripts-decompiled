local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")

local Cryo = require(CorePackages.Packages.Cryo)
local UIBlox = require(CorePackages.Packages.UIBlox)
local images = UIBlox.App.ImageSet.Images
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local module2 = require("@luauforge/bundled/dCp")
local formFactor = require("@luauforge/bundled/dDI").Enums.FormFactor
local module3 = require("@luauforge/bundled/fsq")
local module4 = require("@luauforge/bundled/fyb")

local module5 = require("@luauforge/deferred/fyd")
local module6 = require("@luauforge/bundled/fot")
local vrConstants = require("@luauforge/bundled/fye").VRConstants

local module7 = require("@luauforge/deferred/fyf")
local defineFastFlag = game:DefineFastFlag("LuaAppsEnableParentalControlsTab", false)
local getFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local module8 = require("@luauforge/deferred/fyh")

local defineFastString = game:DefineFastString(
	"LuobuCJVAboutUSCorpUrlOverride",
	"https://roblox.qq.com/?webview=true0409"
)

local getFFlagEnableGateNotificationPreferencesTab = SharedFlags.GetFFlagEnableGateNotificationPreferencesTab

local defineFastFlag2 = game:DefineFastFlag("RenameSettingsTabsSentenceCase", false)
local defineFastString2 = game:DefineFastString("GiftCardSourceParam", "more-page")
local fFlagUnifyConsoleSettingsPage = SharedFlags.FFlagUnifyConsoleSettingsPage
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagEnableBlackbirdOnMorePage = SharedFlags.FFlagEnableBlackbirdOnMorePage
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local Foundation

if fFlagEnableBlackbird and fFlagEnableBlackbirdOnMorePage then
	Foundation = require(CorePackages.Packages.Foundation)
end

local getFStringBlackbirdUrl = SharedFlags.GetFStringBlackbirdUrl
local defineFastString3 = game:DefineFastString(
	"LearnPlaceURI",
	"roblox://experiences/start?placeId=92498145666402"
)
local defineFastString4 = game:DefineFastString(
	"RMPlaceURI",
	"roblox://experiences/start?placeId=119524072047648"
)
local module9 = require("@luauforge/bundled/dHC")
local fFlagFlyoutFilterWebViewsAndBrowserLinks = SharedFlags.FFlagFlyoutFilterWebViewsAndBrowserLinks
local module10 = require("@luauforge/deferred/fyi")
local v5 = module9 and true or false
local fFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local module11 = require("@luauforge/bundled/fyj")
local fFlagCTAChangeMorePageFlyoutButtonText = SharedFlags.FFlagCTAChangeMorePageFlyoutButtonText
local module12 = require("@luauforge/deferred/fyk")
local module13 = require("@luauforge/deferred/fyl")
local getFFlagEnableSupportCenter = SharedFlags.GetFFlagEnableSupportCenter

local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local communityListRouting = require("@luauforge/bundled/dDK").CommunityListRouting

local v6 = {
	VRFTUX = "VRFTUX",
	Catalog = "Catalog",
	BuildersClub = "BuildersClub",
	DevSubs = "DevSubs",
	Trades = "Trades",
	Profile = "Profile",
	TencentNoticeCenter = "TencentNoticeCenter",
	TencentHelp = "TencentHelp",
	UserInfo = "UserInfo",
	Friends = "Friends",
	Groups = "Groups",
	Inventory = "Inventory",
	Messages = "Messages",
	CreateGames = "CreateGames",
	Blog = "Blog",
	GiftCards = "GiftCards",
	Redeem = "Redeem",
	OfficialStore = "OfficialStore",
	Settings = "Settings",
	AdjustScreen = "AdjustScreen",
	SafetySupport = "SafetySupport",
	About = "About",
	Help = "Help",
	LoginCode = "Login Code",
	ReportLogs = "Report Logs",
	LogOut = "LogOut",
	TheHunt = "TheHunt",
	About_AboutUs = "About_AboutUs",
	About_AboutUs_CJV = "About_AboutUs_CJV",
	About_Careers = "About_Careers",
	About_Parents = "About_Parents",
	About_Terms = "About_Terms",
	About_Privacy = "About_Privacy",
	About_PrivacyGuidelinesChildren = "About_PrivacyGuidelinesChildren",
	About_LuobuRiderTerms = "About_LuobuRiderTerms",
	About_LuobuThirdPartyDataUse = "About_LuobuThirdPartyDataUse",
	About_AppInformation = "About_AppInformation",
	About_AboutSection = "About_AboutSection",
	About_TermsOfService = "About_TermsOfService",
	About_LicensingSection = "About_LicensingSection",
	About_VersionSection = "About_VersionSection",
	SafetySupport_AccountStatus = "SafetySupport_AccountStatus",
	SafetySupport_ReportAppeals = "SafetySupport_ReportAppeals",
	SafetySupport_ReportInbox = "SafetySupport_ReportInbox",
	SafetySupport_Help = "SafetySupport_Help",
	SafetySupport_SupportCenter = "SafetySupport_SupportCenter",
	Settings_AccountInfo = "Settings_AccountInfo",
	Settings_Security = "Settings_Security",
	Settings_Privacy = "Settings_Privacy",
	Settings_ParentalControls = "Settings_ParentalControls",
	Settings_Billing = "Settings_Billing",
	Settings_Subscriptions = "Settings_Subscriptions",
	Settings_Robux = "Settings_Robux",
	Settings_Notifications = "Settings_Notifications",
	Settings_ConsoleAccountSettings = "Settings_ConsoleAccountSettings",
	Settings_PlatformSettings = "Settings_PlatformSettings",
	Settings_Accessibility = "Settings_Accessibility",
	Settings_Tencent_Reputation = "Settings_Tencent_Reputation",
	Settings_Cross_Play = "Settings_Cross_Play",
	Settings_SwitchProfileSection = "Settings_SwitchProfileSection",
	Settings_AccountSettingsSection = "Settings_AccountSettingsSection",
	Settings_AccountSettingsInfo = "Settings_AccountSettingsInfo",
	Settings_DeviceSettingsSection = "Settings_DeviceSettingsSection"
}

local v7 = { Content = "Content", Navigation = "Navigation", Action = "Action" }

local v8 = {
	Catalog = "Catalog",
	Games = "Games",
	Groups = "Groups",
	Library = "Library",
	Players = "Players"
}

local v9 = module7()
local v10 = string.lower(UserInputService:GetPlatform().Name)
local giftCardSourceRefOverride = getAppFeaturePolicies().getGiftCardSourceRefOverride()
local v11

if fFlagUnifyConsoleSettingsPage then
	v11 = getAppFeaturePolicies().getPlatformAccountName()
end

if giftCardSourceRefOverride ~= "" then
	v10 = giftCardSourceRefOverride
end

local v12 = {
	[v6.VRFTUX] = "CommonUI.Features.Label.VRFTUX",
	[v6.Catalog] = "Feature.Avatar.Action.Marketplace",
	[v6.BuildersClub] = "CommonUI.Features.Label.Premium",
	[v6.DevSubs] = "CommonUI.Features.Label.DevSubs",
	[v6.Trades] = "CommonUI.Features.Label.Trades",
	[v6.Profile] = "CommonUI.Features.Label.Profile",
	[v6.TencentHelp] = "CommonUI.Features.Label.Help",
	[v6.TencentNoticeCenter] = "CommonUI.Features.Label.TencentNotice",
	[v6.Friends] = "CommonUI.Features.Label.Friends",
	[v6.Groups] = v9.label,
	[v6.Inventory] = "CommonUI.Features.Label.Inventory",
	[v6.Messages] = "CommonUI.Features.Label.Messages",
	[v6.CreateGames] = "CommonUI.Features.Label.CreateGames",
	[v6.TheHunt] = "CommonUI.Features.Label.TheHunt",
	[v6.Blog] = "CommonUI.Features.Label.Newsroom",
	[v6.GiftCards] = "CommonUI.Features.Label.GiftCards",
	[v6.Redeem] = "CommonUI.Features.Label.Redeem",
	[v6.OfficialStore] = "CommonUI.Features.Label.OfficialStore",
	[v6.Settings] = "CommonUI.Features.Label.Settings",
	[v6.AdjustScreen] = "CommonUI.Features.Label.AdjustScreen",
	[v6.About] = "CommonUI.Features.Label.About",
	[v6.SafetySupport] = "CommonUI.Features.Label.HelpAndSafety",
	[v6.SafetySupport_AccountStatus] = module12 and "Feature.SafetyDashboard.Heading.AccountStatus.V2" or nil,
	[v6.SafetySupport_ReportAppeals] = module12 and "Feature.AppealsPortal.Heading.ViolationsAndAppeals" or "Feature.AppealsPortal.Label.ReportAndAppeals",
	[v6.SafetySupport_ReportInbox] = module13 and "Feature.SafetyDashboard.Heading.ReportHistory" or nil,
	[v6.SafetySupport_SupportCenter] = getFFlagEnableSupportCenter() and "CommonUI.Features.Label.SupportCenter" or nil,
	[v6.Help] = "CommonUI.Features.Label.Help",
	[v6.LoginCode] = fFlagCTAChangeMorePageFlyoutButtonText and "Authentication.Login.Action.QuickSignIn" or "Authentication.CrossDevice.Heading.QuickLogin",
	[v6.LogOut] = (fFlagCTAChangeMorePageFlyoutButtonText or module11) and "Feature.AccountLock.Action.Signout" or "Application.Logout.Action.Logout",
	[v6.ReportLogs] = fFlagCTAChangeMorePageFlyoutButtonText and "CommonUI.Features.Label.ReportLogsSentenceCase" or "CommonUI.Features.Label.ReportLogs",
	[v6.About_AboutUs] = "CommonUI.Features.Label.AboutUs",
	[v6.About_AboutUs_CJV] = "CommonUI.Features.Label.AboutUs",
	[v6.About_Careers] = "CommonUI.Features.Label.Careers",
	[v6.About_Parents] = "CommonUI.Features.Label.Parents",
	[v6.About_Terms] = "CommonUI.Features.Label.Terms",
	[v6.About_Privacy] = "CommonUI.Features.Label.Privacy",
	[v6.About_PrivacyGuidelinesChildren] = "CommonUI.Features.Label.PrivacyGuidelinesChildren",
	[v6.About_LuobuRiderTerms] = "CommonUI.Features.Label.LuobuRiderTerms",
	[v6.About_LuobuThirdPartyDataUse] = "CommonUI.Features.Label.LuobuThirdPartyDataUse",
	[v6.About_AppInformation] = "CommonUI.Features.Label.AppInformation",
	[v6.About_AboutSection] = "CommonUI.Features.Label.About",
	[v6.About_TermsOfService] = "CommonUI.Features.Label.TermsOfService",
	[v6.About_LicensingSection] = "CommonUI.Features.Label.Licensing",
	[v6.About_VersionSection] = "CommonUI.Features.Label.Version",
	[v6.Settings_AccountInfo] = defineFastFlag2 and "Feature.AccountSettings.Heading.Tab.AccountInfoV2" or "Feature.AccountSettings.Heading.Tab.AccountInfo",
	[v6.Settings_Security] = "Feature.AccountSettings.Heading.Tab.Security",
	[v6.Settings_Privacy] = "Feature.AccountSettings.Heading.Tab.PrivacyContentRestrictions",
	[v6.Settings_ParentalControls] = defineFastFlag2 and "Feature.AccountSettings.Heading.Tab.ParentalControlsV2" or "Feature.AccountSettings.Heading.Tab.ParentalControls",
	[v6.Settings_Billing] = getAppFeaturePolicies().getRenamePaymentsToSpendingTab() and "Feature.AccountSettings.Heading.Tab.Spending" or defineFastFlag2 and "Feature.AccountSettings.Heading.Tab.BillingV2" or "Feature.AccountSettings.Heading.Tab.Billing",
	[v6.Settings_Subscriptions] = "Feature.AccountSettings.Heading.Tab.Subscriptions",
	[v6.Settings_Robux] = "Feature.AccountSettings.Heading.Tab.Robux",
	[v6.Settings_Notifications] = "Feature.AccountSettings.Heading.Tab.Notifications",
	[v6.Settings_Accessibility] = defineFastFlag2 and "Feature.Accessibility.Heading.DevicePreferencesV2" or "Feature.Accessibility.Heading.DevicePreferences",
	[v6.Settings_Tencent_Reputation] = "Feature.AccountSettings.Label.TencentReputation",
	[v6.Settings_SwitchProfileSection] = "Feature.Settings.Heading.SwitchProfile",
	[v6.Settings_AccountSettingsSection] = "Feature.Settings.Heading.AccountSettings"
}

local v13 = {
	[v6.VRFTUX] = images["icons/menu/vrheadset_large"],
	[v6.Catalog] = images["icons/menu/shop_large"],
	[v6.BuildersClub] = images["icons/status/premium_large"],
	[v6.DevSubs] = images["icons/status/player/developer"],
	[v6.Trades] = images["icons/menu/trade"],
	[v6.Profile] = images["icons/actions/friend_sort/my_profile"],
	[v6.TencentHelp] = images["icons/menu/help_large"],
	[v6.TencentNoticeCenter] = images["icons/menu/events_large"],
	[v6.Friends] = images["icons/menu/friends_large"],
	[v6.Groups] = images[v9.iconLarge],
	[v6.Inventory] = images["icons/menu/inventory_large"],
	[v6.Messages] = images["icons/menu/messages_large"],
	[v6.CreateGames] = images["icons/menu/create_large"],
	[v6.TheHunt] = images["icons/menu/events_large"],
	[v6.Blog] = images["icons/menu/blog_large"],
	[v6.GiftCards] = images["icons/menu/giftcard_large"],
	[v6.Redeem] = images["icons/menu/wallet"],
	[v6.OfficialStore] = images["icons/menu/officialstore_large"],
	[v6.Settings] = images["icons/menu/settings_large"],
	[v6.AdjustScreen] = images["icons/menu/adjust/scale"],
	[v6.About] = images["icons/menu/about_large"],
	[v6.SafetySupport] = images["icons/menu/protection"],
	[v6.Help] = images["icons/menu/help_large"],
	[v6.LoginCode] = images["icons/graphic/lock_xxlarge"],
	[v6.ReportLogs] = images["icons/menu/giftcard_large"]
}

local v14 = {
	[v6.Catalog] = module3.static.catalog(),
	[v6.BuildersClub] = module3.static.buildersClub(),
	[v6.Trades] = module3.static.trades(),
	[v6.Profile] = module3.static.profile(),
	[v6.Friends] = module3.static.friends(),
	[v6.Groups] = module3.static.groups(),
	[v6.Inventory] = module3.static.inventory(),
	[v6.Messages] = module3.static.messages(),
	[v6.CreateGames] = module4({ utm_content = "more_page" })
}
local theHunt = v6.TheHunt
local v15 = if getFStringPlatformEventUrl() == "" then module3.static.help() else module3.fromString(getFStringPlatformEventUrl())()
v14[theHunt] = v15

v14[v6.Blog] = module3.static.blog()
v14[v6.OfficialStore] = module3.static.amazonStore()
v14[v6.GiftCards] = module3.static.giftCards()
v14[v6.GiftCards] = module3.static.giftCards(v10 .. "-" .. defineFastString2)
v14[v6.Redeem] = module3.static.redeem()
v14[v6.Help] = module3.static.help()
local safetySupport_AccountStatus = v6.SafetySupport_AccountStatus
local v16 = if module12 then module3.static.safetyDashboard.main({
	source = "app-help-safety"
}) else nil
v14[safetySupport_AccountStatus] = v16

v14[v6.SafetySupport_ReportAppeals] = module3.static.appealsPortal.main({
	source = "app-help-safety"
})
local safetySupport_ReportInbox = v6.SafetySupport_ReportInbox
local v17 = if module13 then module3.static.safetyDashboard.reportInbox({
	source = "app-help-safety"
}) else nil
v14[safetySupport_ReportInbox] = v17

local safetySupport_SupportCenter = v6.SafetySupport_SupportCenter
local v18 = if getFFlagEnableSupportCenter() then module3.static.supportCenter.main() else nil
v14[safetySupport_SupportCenter] = v18

v14[v6.About_AboutUs] = module3.static.about.us()
v14[v6.About_AboutUs_CJV] = defineFastString ~= "" and module3.fromString(defineFastString)()
	or module3.static.about.us()
v14[v6.About_Careers] = module3.static.about.careers()
v14[v6.About_Parents] = module3.static.about.parents()
v14[v6.About_Terms] = module3.static.about.terms({ useGameQQUrls = true })

v14[v6.About_Privacy] = module3.static.about.privacy({ useGameQQUrls = true })

v14[v6.About_PrivacyGuidelinesChildren] = module3.static.tencent.childrenPrivacyGuide()
v14[v6.About_LuobuRiderTerms] = module3.static.tencent.luobuRiderTerms()
v14[v6.About_LuobuThirdPartyDataUse] = module3.static.tencent.luobuThirdPartyDataUse()
v14[v6.Settings_AccountInfo] = module3.static.settings.account()
v14[v6.Settings_Security] = module3.static.settings.security()
v14[v6.Settings_Privacy] = module3.static.settings.privacy()
v14[v6.Settings_ParentalControls] = module3.static.settings.parentalControls()
v14[v6.Settings_Billing] = module3.static.settings.billing()
v14[v6.Settings_Subscriptions] = module3.static.settings.subscriptions()
v14[v6.Settings_Robux] = module3.static.settings.robux()
v14[v6.Settings_Notifications] = module3.static.settings.notifications()
v14[v6.Settings_Tencent_Reputation] = module3.static.tencent.reputationInfo()

local function fn(p2, p3, p4)
	if p2 then
		return {
			page = p3 or module2.GenericWebPage,
			titleKey = v12[p2],
			url = v14[p2],
			fallbackToExternalBrowser = p4
		}
	end

	return {}
end

local v19 = {
	[v6.VRFTUX] = {
		itemType = v6.VRFTUX,
		textKey = v12[v6.VRFTUX],
		icon = v13[v6.VRFTUX],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		context = { page = module2.ExperienceDetail, url = vrConstants.FTUX.UniverseId }
	},
	[v6.Catalog] = {
		itemType = v6.Catalog,
		textKey = v12[v6.Catalog],
		icon = v13[v6.Catalog],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		context = { page = avatarScreen.Catalog }
	},
	[v6.BuildersClub] = {
		itemType = v6.BuildersClub,
		textKey = v12[v6.BuildersClub],
		icon = v13[v6.BuildersClub],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		context = { page = module2.BuildersClub }
	},
	[v6.DevSubs] = {
		itemType = v6.DevSubs,
		textKey = v12[v6.DevSubs],
		icon = v13[v6.DevSubs],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		context = { page = module2.DevSubs }
	},
	[v6.Trades] = {
		itemType = v6.Trades,
		textKey = v12[v6.Trades],
		icon = v13[v6.Trades],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		context = fn(v6.Trades)
	},
	[v6.Profile] = {
		itemType = v6.Profile,
		textKey = v12[v6.Profile],
		icon = v13[v6.Profile],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		urlGenerator = function(p2)
			return p2
		end,
		context = { page = module2.ProfilePlatform }
	}
}

local friends = v6.Friends
local v20 = {
	itemType = v6.Friends,
	textKey = v12[v6.Friends],
	icon = v13[v6.Friends],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeComponent = module5,
	badgeCount = 0,
	urlGenerator = function(p2)
		return p2 and module3.user.friends({ userId = p2 }) or nil
	end,
	getSearchParams = function()
		return { searchType = "Players" }
	end,
	context = 0
}

local v22 = if fFlagCreateConnectionsHub then module2.CoHubMyConnections else module2.ViewFriends
v20.context = { page = v22 }
v19[friends] = v20

local groups = v6.Groups
local v23 = {
	itemType = v6.Groups,
	textKey = v12[v6.Groups],
	icon = v13[v6.Groups],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	getSearchParams = function(p2)
		if p2 == formFactor.WIDE then
			return { searchType = "Groups" }
		end

		return nil
	end,
	context = 0
}

local v24 = if communityListRouting.getShouldUseLuaCommunityList() then {
	page = module2.Groups
} else fn(v6.Groups)
v23.context = v24
v19[groups] = v23

v19[v6.Inventory] = {
	itemType = v6.Inventory,
	textKey = v12[v6.Inventory],
	icon = v13[v6.Inventory],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	urlGenerator = function(p2)
		return p2 and module3.user.inventory({ userId = p2 }) or nil
	end,
	context = fn(v6.Inventory)
}

v19[v6.Messages] = {
	itemType = v6.Messages,
	textKey = v12[v6.Messages],
	icon = v13[v6.Messages],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeComponent = module5,
	badgeCount = 0,
	context = fn(v6.Messages)
}

v19[v6.CreateGames] = {
	itemType = v6.CreateGames,
	textKey = v12[v6.CreateGames],
	icon = v13[v6.CreateGames],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.CreateGames),
	shouldOpenInExternalBrowser = true
}

v19[v6.TencentHelp] = {
	itemType = v6.TencentHelp,
	textKey = v12[v6.Help],
	icon = v13[v6.Help],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.TencentHelp, titleKey = v12[v6.Help] }
}

v19[v6.TencentNoticeCenter] = {
	itemType = v6.TencentNoticeCenter,
	textKey = v12[v6.TencentNoticeCenter],
	icon = v13[v6.TencentNoticeCenter],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.TencentNoticeCenter }
}

v19[v6.TheHunt] = {
	itemType = v6.TheHunt,
	textKey = v12[v6.TheHunt],
	icon = v13[v6.TheHunt],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.TheHunt)
}

v19[v6.Blog] = {
	itemType = v6.Blog,
	textKey = v12[v6.Blog],
	icon = v13[v6.Blog],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Blog, nil, true)
}

v19[v6.GiftCards] = {
	itemType = v6.GiftCards,
	textKey = v12[v6.GiftCards],
	icon = v13[v6.GiftCards],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.GiftCards, nil, true),
	shouldOpenInExternalBrowser = true
}

v19[v6.Redeem] = {
	itemType = v6.Redeem,
	textKey = v12[v6.Redeem],
	icon = v13[v6.Redeem],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Redeem)
}

v19[v6.OfficialStore] = {
	itemType = v6.OfficialStore,
	textKey = v12[v6.OfficialStore],
	icon = v13[v6.OfficialStore],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.OfficialStore, nil, true)
}

v19[v6.Settings] = {
	itemType = v6.Settings,
	textKey = v12[v6.Settings],
	icon = v13[v6.Settings],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeComponent = module5,
	badgeCount = 0,
	context = { page = module2.Settings }
}

v19[v6.AdjustScreen] = {
	itemType = v6.AdjustScreen,
	textKey = v12[v6.AdjustScreen],
	icon = v13[v6.AdjustScreen],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.AdjustScreen }
}

v19[v6.About] = {
	itemType = v6.About,
	textKey = v12[v6.About],
	icon = v13[v6.About],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.About }
}

v19[v6.SafetySupport] = {
	itemType = v6.SafetySupport,
	textKey = v12[v6.SafetySupport],
	icon = v13[v6.SafetySupport],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.SafetySupport }
}

v19[v6.ReportLogs] = {
	itemType = v6.ReportLogs,
	textKey = v12[v6.ReportLogs],
	icon = v13[v6.ReportLogs],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = {}
}

v19[v6.Help] = {
	itemType = v6.Help,
	textKey = v12[v6.Help],
	icon = v13[v6.Help],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Help, nil, true),
	shouldOpenInExternalBrowser = true
}

v19[v6.LoginCode] = {
	itemType = v6.LoginCode,
	textKey = v12[v6.LoginCode],
	icon = v13[v6.LoginCode],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.CrossDeviceLogin }
}

v19[v6.LogOut] = {
	itemType = v6.LogOut,
	textKey = v12[v6.LogOut],
	textXAlignment = Enum.TextXAlignment.Center,
	badgeCount = 0,
	context = { page = module2.LogoutConfirmation }
}

v19[v6.UserInfo] = { itemType = v6.UserInfo }

v19[v6.Settings_Cross_Play] = { itemType = v6.Settings_Cross_Play }

v19[v6.SafetySupport_AccountStatus] = module12 and {
	itemType = v6.SafetySupport_AccountStatus,
	textKey = v12[v6.SafetySupport_AccountStatus],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.SafetySupport_AccountStatus, nil, true)
} or nil

v19[v6.SafetySupport_ReportAppeals] = {
	itemType = v6.SafetySupport_ReportAppeals,
	textKey = v12[v6.SafetySupport_ReportAppeals],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.SafetySupport_ReportAppeals)
}

v19[v6.SafetySupport_ReportInbox] = module13 and {
	itemType = v6.SafetySupport_ReportInbox,
	textKey = v12[v6.SafetySupport_ReportInbox],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.SafetySupport_ReportInbox, nil, true)
} or nil

v19[v6.SafetySupport_Help] = {
	itemType = v6.SafetySupport_Help,
	textKey = v12[v6.Help],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Help),
	shouldOpenInExternalBrowser = true
}

v19[v6.SafetySupport_SupportCenter] = getFFlagEnableSupportCenter() and {
	itemType = v6.SafetySupport_SupportCenter,
	textKey = v12[v6.SafetySupport_SupportCenter],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.SafetySupport_SupportCenter)
} or nil

v19[v6.About_AboutUs] = {
	itemType = v6.About_AboutUs,
	textKey = v12[v6.About_AboutUs],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_AboutUs, nil, true),
	shouldOpenInExternalBrowser = true
}

v19[v6.About_AboutUs_CJV] = {
	itemType = v6.About_AboutUs_CJV,
	textKey = v12[v6.About_AboutUs],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_AboutUs_CJV)
}

v19[v6.About_Careers] = {
	itemType = v6.About_Careers,
	textKey = v12[v6.About_Careers],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_Careers, nil, true),
	shouldOpenInExternalBrowser = true
}

v19[v6.About_Parents] = {
	itemType = v6.About_Parents,
	textKey = v12[v6.About_Parents],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_Parents, nil, true),
	shouldOpenInExternalBrowser = true
}

v19[v6.About_Terms] = {
	itemType = v6.About_Terms,
	textKey = v12[v6.About_Terms],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_Terms, nil, true),
	shouldOpenInExternalBrowser = true,
	urlGenerator = module8() and function(p2, p3)
		local v25 = if p3 then p3.getTermsOfUseLink() else nil

		if v25 == nil or v25 == "" then
			v25 = v14[v6.About_Terms]
		end

		return v25
	end or nil
}

v19[v6.About_Privacy] = {
	itemType = v6.About_Privacy,
	textKey = v12[v6.About_Privacy],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_Privacy, nil, true),
	shouldOpenInExternalBrowser = true,
	urlGenerator = module8() and function(p2, p3)
		local v25 = if p3 then p3.getPrivacyPolicyLink() else nil

		if v25 == nil or v25 == "" then
			v25 = v14[v6.About_Privacy]
		end

		return v25
	end or nil
}

v19[v6.About_PrivacyGuidelinesChildren] = {
	itemType = v6.About_PrivacyGuidelinesChildren,
	textKey = v12[v6.About_PrivacyGuidelinesChildren],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_PrivacyGuidelinesChildren)
}

v19[v6.About_LuobuRiderTerms] = {
	itemType = v6.About_LuobuRiderTerms,
	textKey = v12[v6.About_LuobuRiderTerms],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_LuobuRiderTerms)
}

v19[v6.About_LuobuThirdPartyDataUse] = {
	itemType = v6.About_LuobuThirdPartyDataUse,
	textKey = v12[v6.About_LuobuThirdPartyDataUse],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.About_LuobuThirdPartyDataUse)
}

v19[v6.About_AppInformation] = {
	itemType = v6.About_AppInformation,
	textKey = v12[v6.About_AppInformation],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.AppInformation }
}

v19[v6.About_VersionSection] = {
	itemType = v6.About_VersionSection,
	textKey = v12[v6.About_VersionSection]
}

v19[v6.Settings_AccountInfo] = {
	itemType = v6.Settings_AccountInfo,
	textKey = v12[v6.Settings_AccountInfo],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeComponent = module5,
	badgeCount = 0,
	context = fn(v6.Settings_AccountInfo, module2.AccountInfo)
}

v19[v6.Settings_Security] = {
	itemType = v6.Settings_Security,
	textKey = v12[v6.Settings_Security],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_Security, module2.SettingsSubPage)
}

v19[v6.Settings_Privacy] = {
	itemType = v6.Settings_Privacy,
	textKey = v12[v6.Settings_Privacy],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_Privacy, module2.SettingsSubPage)
}

v19[v6.Settings_ParentalControls] = {
	itemType = v6.Settings_ParentalControls,
	textKey = v12[v6.Settings_ParentalControls],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_ParentalControls, module2.SettingsSubPage)
}

v19[v6.Settings_Billing] = {
	itemType = v6.Settings_Billing,
	textKey = v12[v6.Settings_Billing],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_Billing, module2.SettingsSubPage)
}

v19[v6.Settings_Subscriptions] = {
	itemType = v6.Settings_Subscriptions,
	textKey = v12[v6.Settings_Subscriptions],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_Subscriptions, module2.SettingsSubPage)
}

v19[v6.Settings_Robux] = module10 and {
	itemType = v6.Settings_Robux,
	textKey = v12[v6.Settings_Robux],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_Robux, module2.SettingsSubPage)
} or nil

v19[v6.Settings_Notifications] = {
	itemType = v6.Settings_Notifications,
	textKey = v12[v6.Settings_Notifications],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fn(v6.Settings_Notifications, module2.SettingsSubPage)
}

v19[v6.Settings_ConsoleAccountSettings] = fFlagUnifyConsoleSettingsPage and {
	itemType = v6.Settings_ConsoleAccountSettings,
	textKey = v12[v6.Settings_AccountSettingsSection],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.AccountSettings }
} or nil

v19[v6.Settings_PlatformSettings] = fFlagUnifyConsoleSettingsPage and {
	itemType = v6.Settings_PlatformSettings,
	textKey = {
		"Feature.Settings.Heading.PlatformAccountSettings",
		platform = v11
	},
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.PlatformSettings }
} or nil

v19[v6.Settings_Accessibility] = {
	itemType = v6.Settings_Accessibility,
	textKey = v12[v6.Settings_Accessibility],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { page = module2.Accessibility }
}

v19[v6.Settings_Tencent_Reputation] = {
	itemType = v6.Settings_Tencent_Reputation,
	textKey = v12[v6.Settings_Tencent_Reputation],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = Cryo.Dictionary.join(
		{ notificationType = module6.SDK_OPEN_URL },
		fn(v6.Settings_Tencent_Reputation, module2.SettingsSubPage)
	)
}

v19[v6.Settings_SwitchProfileSection] = {
	itemType = v6.Settings_SwitchProfileSection,
	textKey = v12[v6.Settings_SwitchProfileSection]
}

v19[v6.Settings_AccountSettingsSection] = {
	itemType = v6.Settings_AccountSettingsSection,
	textKey = v12[v6.Settings_AccountSettingsSection]
}

v19[v6.Settings_AccountSettingsInfo] = { itemType = v6.Settings_AccountSettingsInfo }

v19[v6.Settings_DeviceSettingsSection] = {
	itemType = v6.Settings_DeviceSettingsSection
}

v19[v6.About_AboutSection] = {
	itemType = v6.About_AboutSection,
	textKey = v12[v6.About_AboutSection]
}

v19[v6.About_TermsOfService] = {
	itemType = v6.About_TermsOfService,
	textKey = v12[v6.About_TermsOfService],
	rightImage = images["icons/navigation/externallink_medium"],
	context = { url = v14[v6.About_Terms] }
}

v19[v6.About_LicensingSection] = {
	itemType = v6.About_LicensingSection,
	textKey = v12[v6.About_LicensingSection]
}

v6.Learn = "Learn"
v12[v6.Learn] = "CommonUI.Features.Label.Learn"
v13[v6.Learn] = images["icons/menu/education"]
v19[v6.Learn] = {
	itemType = v6.Learn,
	textKey = v12[v6.Learn],
	icon = v13[v6.Learn],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = { appURI = defineFastString3 }
}

if fFlagEnableBlackbird and fFlagEnableBlackbirdOnMorePage then
	v6.Blackbird = "Blackbird"

	v12[v6.Blackbird] = "CommonUI.Features.Label.X"
	v13[v6.Blackbird] = {
		isFoundationIcon = true,
		name = Foundation.Enums.IconName.RobloxPlus
	}

	local blackbird = v6.Blackbird
	local v25 = if getFStringBlackbirdUrl() ~= "" then module3.fromString(getFStringBlackbirdUrl())() else nil
	v14[blackbird] = v25

	v19[v6.Blackbird] = {
		itemType = v6.Blackbird,
		textKey = v12[v6.Blackbird],
		icon = v13[v6.Blackbird],
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		context = { page = module2.Blackbird }
	}
end

v6.RM = "RM"
v12[v6.RM] = "CommonUI.Features.Label.RM"
v13[v6.RM] = images["icons/brands/moments_large"]
v19[v6.RM] = {
	itemType = v6.RM,
	textKey = v12[v6.RM],
	icon = v13[v6.RM],
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	context = fFlagEnableArgus and { page = module2.Moments } or {
		appURI = defineFastString4
	}
}

local function fn2(p2)
	if module9 then
		return p2 and type(p2) == "table"
	end

	return p2 ~= false
end

return {
	["ItemType"] = v6,
	ItemInfo = v19,
	SectionType = v7,
	MomentsExperienceURI = defineFastString4,
	GetItemsInPage = function(p2, p3, p4, data, p5, p6, p7, p8, p9, p10)
		local v25 = defineFastFlag and true or p5
		local v26

		if getFFlagEnableGateNotificationPreferencesTab() then
			v26 = type(data) == "table" and data.enableNotificationPreferencesTab
		else
			v26 = true
		end

		local v27 = type(data) == "table" and data.hideBillingTab ~= nil and data.hideBillingTab
		local v28

		if getFFlagEnableSupportCenter() and type(data) == "table" then
			v28 = data.isSupportCenterEnabled
		else
			v28 = false
		end

		local v29 = not (fFlagFlyoutFilterWebViewsAndBrowserLinks and p6)

		local v30 = {
			[module2.SimplifiedMore] = {
				{
					type = v7.Navigation,
					contents = { v19[v6.About_Terms] }
				},
				{
					type = v7.Action,
					contents = { v19[v6.LogOut] }
				}
			}
		}

		local about = module2.About
		local v32 = { type = v7.Navigation, contents = 0 }
		local filter = Cryo.List.filter
		local v34 = v19[v6.About_AboutUs]
		local v35 = if module9 then v19[v6.Blog] else false
		v32.contents = filter(
			{
				v34,
				v35,
				v19[v6.About_Careers],
				v19[v6.About_Parents],
				false,
				false,
				v19[v6.About_AppInformation]
			},
			fn2
		)
		v30[about] = { v32 }

		local safetySupport = module2.SafetySupport
		local v37 = { type = v7.Navigation, contents = 0 }
		local v38

		if module9 then
			local filter2 = Cryo.List.filter

			local v40 = if module12 and v29 then v19[v6.SafetySupport_AccountStatus] else false

			local v41 = v19[v6.SafetySupport_Help]
			local v42 = not module12 and v19[v6.SafetySupport_ReportAppeals]

			local v43 = if module13 and v29 then v19[v6.SafetySupport_ReportInbox] else false
			local v44

			if getFFlagEnableSupportCenter() and v28 and v29 then
				v44 = v19[v6.SafetySupport_SupportCenter]
			else
				v44 = false
			end

			local v45 = v19[v6.About]
			local v46 = not v5 and v19[v6.About_Terms]
			v38 = filter2({
				v40,
				v41,
				v42,
				v43,
				v44,
				v45,
				v46,
				not v5 and v19[v6.About_Privacy]
			}, fn2)
		elseif getFFlagEnableSupportCenter() then
			local filter2 = Cryo.List.filter
			local v40 = if module12 then v19[v6.SafetySupport_AccountStatus] else false
			local v41 = if module13 then v19[v6.SafetySupport_ReportInbox] else false
			local v42 = v19[v6.SafetySupport_Help]
			local v43 = not module12 and v19[v6.SafetySupport_ReportAppeals]
			local v44 = if v28 then v19[v6.SafetySupport_SupportCenter] else false
			v38 = filter2({ v40, v41, v42, v43, v44 }, fn2)
		elseif module12 then
			v38 = { v19[v6.SafetySupport_AccountStatus], v19[v6.SafetySupport_Help] }
		else
			v38 = { v19[v6.SafetySupport_Help], v19[v6.SafetySupport_ReportAppeals] }
		end

		v37.contents = v38
		v30[safetySupport] = { v37 }

		v30[module2.CJVAbout] = {
			{
				type = v7.Navigation,
				contents = Cryo.List.filter(
					{
						v19[v6.About_AboutUs_CJV],
						v19[v6.About_Careers],
						v19[v6.About_Terms],
						v19[v6.About_Privacy],
						v19[v6.About_PrivacyGuidelinesChildren],
						v19[v6.About_LuobuRiderTerms],
						v19[v6.About_LuobuThirdPartyDataUse],
						v19[v6.About_AppInformation]
					},
					fn2
				)
			}
		}

		local settings2 = module2.Settings
		local v40 = { type = v7.Navigation, contents = 0 }
		local v41

		if fFlagUnifyConsoleSettingsPage and p6 then
			v41 = Cryo.List.filter(
				{
					v19[v6.Settings_ConsoleAccountSettings],
					v19[v6.Settings_PlatformSettings],
					v19[v6.Settings_Accessibility]
				},
				fn2
			)
		else
			v41 = Cryo.List.filter({
				v19[v6.Settings_AccountInfo],
				v19[v6.Settings_Security],
				v19[v6.Settings_Privacy],
				v25 and v19[v6.Settings_ParentalControls] or false,
				not v27 and (v19[v6.Settings_Billing] or false),
				v19[v6.Settings_Subscriptions],
				module10 and v19[v6.Settings_Robux] or false,
				v26 and v19[v6.Settings_Notifications] or false,
				v19[v6.Settings_Accessibility]
			}, fn2)
		end

		v40.contents = v41
		v30[settings2] = { v40 }

		v30[module2.CJVSettings] = {
			{
				type = v7.Navigation,
				contents = Cryo.List.filter(
					{
						v19[v6.Settings_AccountInfo],
						v19[v6.Settings_Security],
						v19[v6.Settings_Privacy],
						false
					},
					fn2
				)
			}
		}

		v30[module2.TenFootSettings] = {
			{
				type = v7.Content,
				contents = {
					{ itemInfo = v19[v6.Settings_SwitchProfileSection] },
					{
						itemInfo = v19[v6.Settings_AccountSettingsSection],
						subItems = { v19[v6.Settings_AccountSettingsInfo] }
					},
					{ itemInfo = v19[v6.Settings_DeviceSettingsSection] }
				}
			}
		}

		v30[module2.TenFootAbout] = {
			{
				type = v7.Content,
				contents = {
					{ itemInfo = v19[v6.About_AboutSection], subItems = {} },
					{ itemInfo = v19[v6.About_LicensingSection] },
					{ itemInfo = v19[v6.About_VersionSection] }
				}
			}
		}

		local itemsInPage = v30[module2.SimplifiedMore]

		if v30[p2] ~= nil then
			itemsInPage = v30[p2]
		end

		return itemsInPage
	end
}
