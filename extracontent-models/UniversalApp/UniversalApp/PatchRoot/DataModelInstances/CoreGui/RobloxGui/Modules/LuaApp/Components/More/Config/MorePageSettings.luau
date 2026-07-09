local CorePackages = game:GetService("CorePackages")
local UserInputService = game:GetService("UserInputService")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Cryo = require(CorePackages.Packages.Cryo)
local Images = require(CorePackages.Packages.UIBlox).App.ImageSet.Images
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AppPage = require(Modules.LuaApp.AppPage)
local FormFactor = require(CorePackages.Workspace.Packages.FormFactor).Enums.FormFactor
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local buildCreatorWebNavUrl = require(Modules.LuaApp.buildCreatorWebNavUrl)
local NumericalBadge = require(Modules.LuaApp.Components.NumericalBadge)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local VRConstants = require(CorePackages.Workspace.Packages.VrCompatibility).VRConstants
local getAppChatCommunitiesVisualConfig = require(CorePackages.Workspace.Packages.AppChat.getAppChatCommunitiesVisualConfig)
local getFFlagCommunitiesUseVisualConfigUtil = SharedFlags.getFFlagCommunitiesUseVisualConfigUtil
local GetFFlagUseCommunitiesTranslation = SharedFlags.GetFFlagUseCommunitiesTranslation
local v18 = game:DefineFastFlag("LuaAppsEnableParentalControlsTab", false)
local GetFStringPlatformEventUrl = SharedFlags.GetFStringPlatformEventUrl
local GetFFlagEnableGUACControlTOSPPLinks = require(Modules.LuaApp.Flags.GetFFlagEnableGUACControlTOSPPLinks)
local v21 = game:DefineFastString("LuobuCJVAboutUSCorpUrlOverride", "https://roblox.qq.com/?webview=true0409")
local GetFFlagEnableGateNotificationPreferencesTab = SharedFlags.GetFFlagEnableGateNotificationPreferencesTab
local v23 = game:DefineFastFlag("RenameSettingsTabsSentenceCase", false)
local v24 = game:DefineFastString("GiftCardSourceParam", "more-page")
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagEnableBlackbirdOnMorePage = SharedFlags.FFlagEnableBlackbirdOnMorePage
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusFlyoutEntry = SharedFlags.FFlagEnableArgusFlyoutEntry
local v29 = if not FFlagEnableBlackbird or not FFlagEnableBlackbirdOnMorePage then nil else require(CorePackages.Packages.Foundation)
local GetFStringBlackbirdUrl = SharedFlags.GetFStringBlackbirdUrl
local v31 = game:DefineFastString("LearnPlaceURI", "roblox://experiences/start?placeId=92498145666402")
local v32 = game:DefineFastString("RMPlaceURI", "roblox://experiences/start?placeId=119524072047648")
local FFlagEnableFlyoutSidePanel = require(Modules.LuaApp.Flags.FFlagEnableFlyoutSidePanel)
local FFlagEnableRobuxTransferLimitSettings = require(Modules.LuaApp.Flags.FFlagEnableRobuxTransferLimitSettings)
local FFlagMorePageTermsPrivacyFooter = require(Modules.LuaApp.Flags.FFlagMorePageTermsPrivacyFooter)
local v36 = not not FFlagEnableFlyoutSidePanel and require(CorePackages.Workspace.Packages.FlyoutSidePanel).Flags.FFlagFlyoutTermsPrivacyFooter
local FFlagCreateConnectionsHub = SharedFlags.FFlagCreateConnectionsHub
local GetFFlagEnableCommunityListExperimentation = SharedFlags.GetFFlagEnableCommunityListExperimentation
local FFlagConnectionsToFriendsRename = SharedFlags.FFlagConnectionsToFriendsRename
local FFlagCTAChangeLogOutToSignOut = require(Modules.LuaApp.Flags.FFlagCTAChangeLogOutToSignOut)
local FFlagEnableSafetyDashboard = require(Modules.LuaApp.Flags.FFlagEnableSafetyDashboard)
local GetFFlagEnableSupportCenter = SharedFlags.GetFFlagEnableSupportCenter
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local CommunityListExperimentation = require(CorePackages.Workspace.Packages.Groups).Experiments.CommunityListExperimentation
local t1 = {
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
	Settings_Accessibility = "Settings_Accessibility",
	Settings_Tencent_Reputation = "Settings_Tencent_Reputation",
	Settings_Cross_Play = "Settings_Cross_Play",
	Settings_SwitchProfileSection = "Settings_SwitchProfileSection",
	Settings_AccountSettingsSection = "Settings_AccountSettingsSection",
	Settings_AccountSettingsInfo = "Settings_AccountSettingsInfo",
	Settings_DeviceSettingsSection = "Settings_DeviceSettingsSection"
}
local t2 = {
	Content = "Content",
	Navigation = "Navigation",
	Action = "Action"
}
local _ = {
	Catalog = "Catalog",
	Games = "Games",
	Groups = "Groups",
	Library = "Library",
	Players = "Players"
}
local v48 = getAppChatCommunitiesVisualConfig()
local v49 = string.lower(UserInputService:GetPlatform().Name)
local v50 = getAppFeaturePolicies().getGiftCardSourceRefOverride()
local v51 = if v50 == "" then v49 else v50
local t3 = {
	[t1.VRFTUX] = "CommonUI.Features.Label.VRFTUX",
	[t1.Catalog] = "Feature.Avatar.Action.Marketplace",
	[t1.BuildersClub] = "CommonUI.Features.Label.Premium",
	[t1.DevSubs] = "CommonUI.Features.Label.DevSubs",
	[t1.Trades] = "CommonUI.Features.Label.Trades",
	[t1.Profile] = "CommonUI.Features.Label.Profile",
	[t1.TencentHelp] = "CommonUI.Features.Label.Help",
	[t1.TencentNoticeCenter] = "CommonUI.Features.Label.TencentNotice",
	[t1.Friends] = not FFlagConnectionsToFriendsRename and "CommonUI.Features.Label.Connections" or "CommonUI.Features.Label.Friends",
	[t1.Groups] = if not getFFlagCommunitiesUseVisualConfigUtil() then not GetFFlagUseCommunitiesTranslation() and "CommonUI.Features.Label.sGroups" or "CommonUI.Features.Label.Groups" else v48.label,
	[t1.Inventory] = "CommonUI.Features.Label.Inventory",
	[t1.Messages] = "CommonUI.Features.Label.Messages",
	[t1.CreateGames] = "CommonUI.Features.Label.CreateGames",
	[t1.TheHunt] = "CommonUI.Features.Label.TheHunt",
	[t1.Blog] = "CommonUI.Features.Label.Blog",
	[t1.GiftCards] = "CommonUI.Features.Label.GiftCards",
	[t1.Redeem] = "CommonUI.Features.Label.Redeem",
	[t1.OfficialStore] = "CommonUI.Features.Label.OfficialStore",
	[t1.Settings] = "CommonUI.Features.Label.Settings",
	[t1.AdjustScreen] = "CommonUI.Features.Label.AdjustScreen",
	[t1.About] = "CommonUI.Features.Label.About",
	[t1.SafetySupport] = "CommonUI.Features.Label.HelpAndSafety",
	[t1.SafetySupport_AccountStatus] = if not FFlagEnableSafetyDashboard then nil else "Feature.SafetyDashboard.Heading.AccountStatus",
	[t1.SafetySupport_ReportAppeals] = not FFlagEnableSafetyDashboard and "Feature.AppealsPortal.Label.ReportAndAppeals" or "Feature.AppealsPortal.Heading.ViolationsAndAppeals",
	[t1.SafetySupport_SupportCenter] = if not GetFFlagEnableSupportCenter() then nil else "CommonUI.Features.Label.SupportCenter",
	[t1.Help] = "CommonUI.Features.Label.Help",
	[t1.LoginCode] = "Authentication.CrossDevice.Heading.QuickLogin",
	[t1.LogOut] = not FFlagCTAChangeLogOutToSignOut and "Application.Logout.Action.Logout" or "Feature.AccountLock.Action.Signout",
	[t1.ReportLogs] = "CommonUI.Features.Label.ReportLogs",
	[t1.About_AboutUs] = "CommonUI.Features.Label.AboutUs",
	[t1.About_AboutUs_CJV] = "CommonUI.Features.Label.AboutUs",
	[t1.About_Careers] = "CommonUI.Features.Label.Careers",
	[t1.About_Parents] = "CommonUI.Features.Label.Parents",
	[t1.About_Terms] = "CommonUI.Features.Label.Terms",
	[t1.About_Privacy] = "CommonUI.Features.Label.Privacy",
	[t1.About_PrivacyGuidelinesChildren] = "CommonUI.Features.Label.PrivacyGuidelinesChildren",
	[t1.About_LuobuRiderTerms] = "CommonUI.Features.Label.LuobuRiderTerms",
	[t1.About_LuobuThirdPartyDataUse] = "CommonUI.Features.Label.LuobuThirdPartyDataUse",
	[t1.About_AppInformation] = "CommonUI.Features.Label.AppInformation",
	[t1.About_AboutSection] = "CommonUI.Features.Label.About",
	[t1.About_TermsOfService] = "CommonUI.Features.Label.TermsOfService",
	[t1.About_LicensingSection] = "CommonUI.Features.Label.Licensing",
	[t1.About_VersionSection] = "CommonUI.Features.Label.Version",
	[t1.Settings_AccountInfo] = not v23 and "Feature.AccountSettings.Heading.Tab.AccountInfo" or "Feature.AccountSettings.Heading.Tab.AccountInfoV2",
	[t1.Settings_Security] = "Feature.AccountSettings.Heading.Tab.Security",
	[t1.Settings_Privacy] = "Feature.AccountSettings.Heading.Tab.PrivacyContentRestrictions",
	[t1.Settings_ParentalControls] = not v23 and "Feature.AccountSettings.Heading.Tab.ParentalControls" or "Feature.AccountSettings.Heading.Tab.ParentalControlsV2",
	[t1.Settings_Billing] = if not getAppFeaturePolicies().getRenamePaymentsToSpendingTab() then not v23 and "Feature.AccountSettings.Heading.Tab.Billing" or "Feature.AccountSettings.Heading.Tab.BillingV2" else "Feature.AccountSettings.Heading.Tab.Spending",
	[t1.Settings_Subscriptions] = "Feature.AccountSettings.Heading.Tab.Subscriptions",
	[t1.Settings_Robux] = "Feature.AccountSettings.Heading.Tab.Robux",
	[t1.Settings_Notifications] = "Feature.AccountSettings.Heading.Tab.Notifications",
	[t1.Settings_Accessibility] = not v23 and "Feature.Accessibility.Heading.DevicePreferences" or "Feature.Accessibility.Heading.DevicePreferencesV2",
	[t1.Settings_Tencent_Reputation] = "Feature.AccountSettings.Label.TencentReputation",
	[t1.Settings_SwitchProfileSection] = "Feature.Settings.Heading.SwitchProfile",
	[t1.Settings_AccountSettingsSection] = "Feature.Settings.Heading.AccountSettings"
}
local t4 = {
	[t1.VRFTUX] = Images["icons/menu/vrheadset_large"],
	[t1.Catalog] = Images["icons/menu/shop_large"],
	[t1.BuildersClub] = Images["icons/status/premium_large"],
	[t1.DevSubs] = Images["icons/status/player/developer"],
	[t1.Trades] = Images["icons/menu/trade"],
	[t1.Profile] = Images["icons/actions/friend_sort/my_profile"],
	[t1.TencentHelp] = Images["icons/menu/help_large"],
	[t1.TencentNoticeCenter] = Images["icons/menu/events_large"],
	[t1.Friends] = Images["icons/menu/friends_large"],
	[t1.Groups] = if not getFFlagCommunitiesUseVisualConfigUtil() then Images["icons/menu/groups_large"] else Images[v48.iconLarge],
	[t1.Inventory] = Images["icons/menu/inventory_large"],
	[t1.Messages] = Images["icons/menu/messages_large"],
	[t1.CreateGames] = Images["icons/menu/create_large"],
	[t1.TheHunt] = Images["icons/menu/events_large"],
	[t1.Blog] = Images["icons/menu/blog_large"],
	[t1.GiftCards] = Images["icons/menu/giftcard_large"],
	[t1.Redeem] = Images["icons/menu/wallet"],
	[t1.OfficialStore] = Images["icons/menu/officialstore_large"],
	[t1.Settings] = Images["icons/menu/settings_large"],
	[t1.AdjustScreen] = Images["icons/menu/adjust/scale"],
	[t1.About] = Images["icons/menu/about_large"],
	[t1.SafetySupport] = Images["icons/menu/protection"],
	[t1.Help] = Images["icons/menu/help_large"],
	[t1.LoginCode] = Images["icons/graphic/lock_xxlarge"],
	[t1.ReportLogs] = Images["icons/menu/giftcard_large"]
}
local t5 = {
	[t1.Catalog] = UrlBuilder.static.catalog(),
	[t1.BuildersClub] = UrlBuilder.static.buildersClub(),
	[t1.Trades] = UrlBuilder.static.trades(),
	[t1.Profile] = UrlBuilder.static.profile(),
	[t1.Friends] = UrlBuilder.static.friends(),
	[t1.Groups] = UrlBuilder.static.groups(),
	[t1.Inventory] = UrlBuilder.static.inventory(),
	[t1.Messages] = UrlBuilder.static.messages(),
	[t1.CreateGames] = buildCreatorWebNavUrl({
		utm_content = "more_page"
	}),
	[t1.TheHunt] = if GetFStringPlatformEventUrl() == "" then UrlBuilder.static.help() else UrlBuilder.fromString(GetFStringPlatformEventUrl())(),
	[t1.Blog] = UrlBuilder.static.blog(),
	[t1.OfficialStore] = UrlBuilder.static.amazonStore(),
	[t1.GiftCards] = UrlBuilder.static.giftCards(),
	[t1.GiftCards] = UrlBuilder.static.giftCards(v51 .. "-" .. v24),
	[t1.Redeem] = UrlBuilder.static.redeem(),
	[t1.Help] = UrlBuilder.static.help(),
	[t1.SafetySupport_AccountStatus] = if not FFlagEnableSafetyDashboard then nil else UrlBuilder.static.safetyDashboard.main({
		source = "app-help-safety"
	}),
	[t1.SafetySupport_ReportAppeals] = UrlBuilder.static.appealsPortal.main({
		source = "app-help-safety"
	}),
	[t1.SafetySupport_SupportCenter] = if not GetFFlagEnableSupportCenter() then nil else UrlBuilder.static.supportCenter.main(),
	[t1.About_AboutUs] = UrlBuilder.static.about.us(),
	[t1.About_AboutUs_CJV] = v21 ~= "" and UrlBuilder.fromString(v21)() or UrlBuilder.static.about.us(),
	[t1.About_Careers] = UrlBuilder.static.about.careers(),
	[t1.About_Parents] = UrlBuilder.static.about.parents(),
	[t1.About_Terms] = UrlBuilder.static.about.terms({
		useGameQQUrls = true
	}),
	[t1.About_Privacy] = UrlBuilder.static.about.privacy({
		useGameQQUrls = true
	}),
	[t1.About_PrivacyGuidelinesChildren] = UrlBuilder.static.tencent.childrenPrivacyGuide(),
	[t1.About_LuobuRiderTerms] = UrlBuilder.static.tencent.luobuRiderTerms(),
	[t1.About_LuobuThirdPartyDataUse] = UrlBuilder.static.tencent.luobuThirdPartyDataUse(),
	[t1.Settings_AccountInfo] = UrlBuilder.static.settings.account(),
	[t1.Settings_Security] = UrlBuilder.static.settings.security(),
	[t1.Settings_Privacy] = UrlBuilder.static.settings.privacy(),
	[t1.Settings_ParentalControls] = UrlBuilder.static.settings.parentalControls(),
	[t1.Settings_Billing] = UrlBuilder.static.settings.billing(),
	[t1.Settings_Subscriptions] = UrlBuilder.static.settings.subscriptions(),
	[t1.Settings_Robux] = UrlBuilder.static.settings.robux(),
	[t1.Settings_Notifications] = UrlBuilder.static.settings.notifications(),
	[t1.Settings_Tencent_Reputation] = UrlBuilder.static.tencent.reputationInfo()
}

local function v55(p1, p2, p3) -- line: 319
	-- upvalues: AppPage (copy), t3 (copy), t5 (copy)
	if p1 then
		return {
			page = p2 or AppPage.GenericWebPage,
			titleKey = t3[p1],
			url = t5[p1],
			fallbackToExternalBrowser = p3
		}
	end

	return {}
end

local t6 = {
	[t1.VRFTUX] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.VRFTUX,
		textKey = t3[t1.VRFTUX],
		icon = t4[t1.VRFTUX],
		context = {
			page = AppPage.ExperienceDetail,
			url = VRConstants.FTUX.UniverseId
		}
	},
	[t1.Catalog] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Catalog,
		textKey = t3[t1.Catalog],
		icon = t4[t1.Catalog],
		context = {
			page = AvatarScreen.Catalog
		}
	},
	[t1.BuildersClub] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.BuildersClub,
		textKey = t3[t1.BuildersClub],
		icon = t4[t1.BuildersClub],
		context = {
			page = AppPage.BuildersClub
		}
	},
	[t1.DevSubs] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.DevSubs,
		textKey = t3[t1.DevSubs],
		icon = t4[t1.DevSubs],
		context = {
			page = AppPage.DevSubs
		}
	},
	[t1.Trades] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Trades,
		textKey = t3[t1.Trades],
		icon = t4[t1.Trades],
		context = v55(t1.Trades)
	},
	[t1.Profile] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Profile,
		textKey = t3[t1.Profile],
		icon = t4[t1.Profile],
		urlGenerator = function(p4) -- line: 387
			return p4
		end,
		context = {
			page = AppPage.ProfilePlatform
		}
	},
	[t1.Friends] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Friends,
		textKey = t3[t1.Friends],
		icon = t4[t1.Friends],
		badgeComponent = NumericalBadge,
		urlGenerator = function(p5) -- line: 403
			-- upvalues: UrlBuilder (copy)
			return p5 and UrlBuilder.user.friends({
				userId = p5
			}) or nil
		end,
		getSearchParams = function() -- line: 406
			return {
				searchType = "Players"
			}
		end,
		context = {
			page = if not FFlagCreateConnectionsHub then AppPage.ViewFriends else AppPage.CoHubMyConnections
		}
	},
	[t1.Groups] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Groups,
		textKey = t3[t1.Groups],
		icon = t4[t1.Groups],
		getSearchParams = function(p6) -- line: 421
			-- upvalues: FormFactor (copy)
			if p6 == FormFactor.WIDE then
				return {
					searchType = "Groups"
				}
			end

			return nil
		end,
		context = if not GetFFlagEnableCommunityListExperimentation() or not CommunityListExperimentation.getCommunityListEnabled() then v55(t1.Groups) else {
			page = AppPage.Groups
		}
	},
	[t1.Inventory] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Inventory,
		textKey = t3[t1.Inventory],
		icon = t4[t1.Inventory],
		urlGenerator = function(p7) -- line: 443
			-- upvalues: UrlBuilder (copy)
			return p7 and UrlBuilder.user.inventory({
				userId = p7
			}) or nil
		end,
		context = v55(t1.Inventory)
	},
	[t1.Messages] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Messages,
		textKey = t3[t1.Messages],
		icon = t4[t1.Messages],
		badgeComponent = NumericalBadge,
		context = v55(t1.Messages)
	},
	[t1.CreateGames] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.CreateGames,
		textKey = t3[t1.CreateGames],
		icon = t4[t1.CreateGames],
		context = v55(t1.CreateGames)
	},
	[t1.TencentHelp] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.TencentHelp,
		textKey = t3[t1.Help],
		icon = t4[t1.Help],
		context = {
			page = AppPage.TencentHelp,
			titleKey = t3[t1.Help]
		}
	},
	[t1.TencentNoticeCenter] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.TencentNoticeCenter,
		textKey = t3[t1.TencentNoticeCenter],
		icon = t4[t1.TencentNoticeCenter],
		context = {
			page = AppPage.TencentNoticeCenter
		}
	},
	[t1.TheHunt] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.TheHunt,
		textKey = t3[t1.TheHunt],
		icon = t4[t1.TheHunt],
		context = v55(t1.TheHunt)
	},
	[t1.Blog] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Blog,
		textKey = t3[t1.Blog],
		icon = t4[t1.Blog],
		context = v55(t1.Blog, nil, true)
	},
	[t1.GiftCards] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.GiftCards,
		textKey = t3[t1.GiftCards],
		icon = t4[t1.GiftCards],
		context = v55(t1.GiftCards, nil, true)
	},
	[t1.Redeem] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Redeem,
		textKey = t3[t1.Redeem],
		icon = t4[t1.Redeem],
		context = v55(t1.Redeem)
	},
	[t1.OfficialStore] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.OfficialStore,
		textKey = t3[t1.OfficialStore],
		icon = t4[t1.OfficialStore],
		context = v55(t1.OfficialStore, nil, true)
	},
	[t1.Settings] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings,
		textKey = t3[t1.Settings],
		icon = t4[t1.Settings],
		badgeComponent = NumericalBadge,
		context = {
			page = AppPage.Settings
		}
	},
	[t1.AdjustScreen] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.AdjustScreen,
		textKey = t3[t1.AdjustScreen],
		icon = t4[t1.AdjustScreen],
		context = {
			page = AppPage.AdjustScreen
		}
	},
	[t1.About] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.About,
		textKey = t3[t1.About],
		icon = t4[t1.About],
		context = {
			page = AppPage.About
		}
	},
	[t1.SafetySupport] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.SafetySupport,
		textKey = t3[t1.SafetySupport],
		icon = t4[t1.SafetySupport],
		context = {
			page = AppPage.SafetySupport
		}
	},
	[t1.ReportLogs] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.ReportLogs,
		textKey = t3[t1.ReportLogs],
		icon = t4[t1.ReportLogs],
		context = {}
	},
	[t1.Help] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.Help,
		textKey = t3[t1.Help],
		icon = t4[t1.Help],
		context = v55(t1.Help, nil, true)
	},
	[t1.LoginCode] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.LoginCode,
		textKey = t3[t1.LoginCode],
		icon = t4[t1.LoginCode],
		context = {
			page = AppPage.CrossDeviceLogin
		}
	},
	[t1.LogOut] = {
		badgeCount = 0,
		itemType = t1.LogOut,
		textKey = t3[t1.LogOut],
		textXAlignment = Enum.TextXAlignment.Center,
		context = {
			page = AppPage.LogoutConfirmation
		}
	},
	[t1.UserInfo] = {
		itemType = t1.UserInfo
	},
	[t1.Settings_Cross_Play] = {
		itemType = t1.Settings_Cross_Play
	},
	[t1.SafetySupport_AccountStatus] = if not FFlagEnableSafetyDashboard then nil else {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.SafetySupport_AccountStatus,
		textKey = t3[t1.SafetySupport_AccountStatus],
		context = v55(t1.SafetySupport_AccountStatus, nil, true)
	},
	[t1.SafetySupport_ReportAppeals] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.SafetySupport_ReportAppeals,
		textKey = t3[t1.SafetySupport_ReportAppeals],
		context = v55(t1.SafetySupport_ReportAppeals)
	},
	[t1.SafetySupport_Help] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.SafetySupport_Help,
		textKey = t3[t1.Help],
		context = v55(t1.Help)
	},
	[t1.SafetySupport_SupportCenter] = if not GetFFlagEnableSupportCenter() then nil else {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.SafetySupport_SupportCenter,
		textKey = t3[t1.SafetySupport_SupportCenter],
		context = v55(t1.SafetySupport_SupportCenter)
	},
	[t1.About_AboutUs] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.About_AboutUs,
		textKey = t3[t1.About_AboutUs],
		context = v55(t1.About_AboutUs, nil, true)
	},
	[t1.About_AboutUs_CJV] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.About_AboutUs_CJV,
		textKey = t3[t1.About_AboutUs],
		context = v55(t1.About_AboutUs_CJV)
	},
	[t1.About_Careers] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.About_Careers,
		textKey = t3[t1.About_Careers],
		context = v55(t1.About_Careers, nil, true)
	},
	[t1.About_Parents] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.About_Parents,
		textKey = t3[t1.About_Parents],
		context = v55(t1.About_Parents, nil, true)
	},
	[t1.About_Terms] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.About_Terms,
		textKey = t3[t1.About_Terms],
		context = v55(t1.About_Terms, nil, true),
		urlGenerator = if not GetFFlagEnableGUACControlTOSPPLinks() then nil else function(_, p9) -- line: 686
			-- upvalues: t5 (copy), t1 (copy)
			local v67 = nil

			if p9 then
				v67 = p9.getTermsOfUseLink()
			end

			if v67 == nil or v67 == "" then
				v67 = t5[t1.About_Terms]
			end

			return v67
		end
	},
	[t1.About_Privacy] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		shouldOpenInExternalBrowser = true,
		itemType = t1.About_Privacy,
		textKey = t3[t1.About_Privacy],
		context = v55(t1.About_Privacy, nil, true),
		urlGenerator = if not GetFFlagEnableGUACControlTOSPPLinks() then nil else function(_, p11) -- line: 706
			-- upvalues: t5 (copy), t1 (copy)
			local v70 = nil

			if p11 then
				v70 = p11.getPrivacyPolicyLink()
			end

			if v70 == nil or v70 == "" then
				v70 = t5[t1.About_Privacy]
			end

			return v70
		end
	},
	[t1.About_PrivacyGuidelinesChildren] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.About_PrivacyGuidelinesChildren,
		textKey = t3[t1.About_PrivacyGuidelinesChildren],
		context = v55(t1.About_PrivacyGuidelinesChildren)
	},
	[t1.About_LuobuRiderTerms] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.About_LuobuRiderTerms,
		textKey = t3[t1.About_LuobuRiderTerms],
		context = v55(t1.About_LuobuRiderTerms)
	},
	[t1.About_LuobuThirdPartyDataUse] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.About_LuobuThirdPartyDataUse,
		textKey = t3[t1.About_LuobuThirdPartyDataUse],
		context = v55(t1.About_LuobuThirdPartyDataUse)
	},
	[t1.About_AppInformation] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.About_AppInformation,
		textKey = t3[t1.About_AppInformation],
		context = {
			page = AppPage.AppInformation
		}
	},
	[t1.About_VersionSection] = {
		itemType = t1.About_VersionSection,
		textKey = t3[t1.About_VersionSection]
	},
	[t1.Settings_AccountInfo] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_AccountInfo,
		textKey = t3[t1.Settings_AccountInfo],
		badgeComponent = NumericalBadge,
		context = v55(t1.Settings_AccountInfo, AppPage.AccountInfo)
	},
	[t1.Settings_Security] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Security,
		textKey = t3[t1.Settings_Security],
		context = v55(t1.Settings_Security, AppPage.SettingsSubPage)
	},
	[t1.Settings_Privacy] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Privacy,
		textKey = t3[t1.Settings_Privacy],
		context = v55(t1.Settings_Privacy, AppPage.SettingsSubPage)
	},
	[t1.Settings_ParentalControls] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_ParentalControls,
		textKey = t3[t1.Settings_ParentalControls],
		context = v55(t1.Settings_ParentalControls, AppPage.SettingsSubPage)
	},
	[t1.Settings_Billing] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Billing,
		textKey = t3[t1.Settings_Billing],
		context = v55(t1.Settings_Billing, AppPage.SettingsSubPage)
	},
	[t1.Settings_Subscriptions] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Subscriptions,
		textKey = t3[t1.Settings_Subscriptions],
		context = v55(t1.Settings_Subscriptions, AppPage.SettingsSubPage)
	},
	[t1.Settings_Robux] = if not FFlagEnableRobuxTransferLimitSettings then nil else {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Robux,
		textKey = t3[t1.Settings_Robux],
		context = v55(t1.Settings_Robux, AppPage.SettingsSubPage)
	},
	[t1.Settings_Notifications] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Notifications,
		textKey = t3[t1.Settings_Notifications],
		context = v55(t1.Settings_Notifications, AppPage.SettingsSubPage)
	},
	[t1.Settings_Accessibility] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Accessibility,
		textKey = t3[t1.Settings_Accessibility],
		context = {
			page = AppPage.Accessibility
		}
	},
	[t1.Settings_Tencent_Reputation] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Settings_Tencent_Reputation,
		textKey = t3[t1.Settings_Tencent_Reputation],
		context = Cryo.Dictionary.join({
			notificationType = NotificationType.SDK_OPEN_URL
		}, (v55(t1.Settings_Tencent_Reputation, AppPage.SettingsSubPage)))
	},
	[t1.Settings_SwitchProfileSection] = {
		itemType = t1.Settings_SwitchProfileSection,
		textKey = t3[t1.Settings_SwitchProfileSection]
	},
	[t1.Settings_AccountSettingsSection] = {
		itemType = t1.Settings_AccountSettingsSection,
		textKey = t3[t1.Settings_AccountSettingsSection]
	},
	[t1.Settings_AccountSettingsInfo] = {
		itemType = t1.Settings_AccountSettingsInfo
	},
	[t1.Settings_DeviceSettingsSection] = {
		itemType = t1.Settings_DeviceSettingsSection
	},
	[t1.About_AboutSection] = {
		itemType = t1.About_AboutSection,
		textKey = t3[t1.About_AboutSection]
	},
	[t1.About_TermsOfService] = {
		itemType = t1.About_TermsOfService,
		textKey = t3[t1.About_TermsOfService],
		rightImage = Images["icons/navigation/externallink_medium"],
		context = {
			url = t5[t1.About_Terms]
		}
	},
	[t1.About_LicensingSection] = {
		itemType = t1.About_LicensingSection,
		textKey = t3[t1.About_LicensingSection]
	}
}

t1.Learn = "Learn"
t3[t1.Learn] = "CommonUI.Features.Label.Learn"
t4[t1.Learn] = Images["icons/menu/education"]
t6[t1.Learn] = {
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	itemType = t1.Learn,
	textKey = t3[t1.Learn],
	icon = t4[t1.Learn],
	context = {
		appURI = v31
	}
}

if FFlagEnableBlackbird and FFlagEnableBlackbirdOnMorePage then
	t1.Blackbird = "Blackbird"
	t3[t1.Blackbird] = "CommonUI.Features.Label.X"
	t4[t1.Blackbird] = {
		isFoundationIcon = true,
		name = v29.Enums.IconName.RobloxPlus
	}
	t5[t1.Blackbird] = if GetFStringBlackbirdUrl() == "" then nil else UrlBuilder.fromString(GetFStringBlackbirdUrl())()
	t6[t1.Blackbird] = {
		rightImage = "LuaApp/icons/navigation/pushRight_small",
		badgeCount = 0,
		itemType = t1.Blackbird,
		textKey = t3[t1.Blackbird],
		icon = t4[t1.Blackbird],
		context = {
			page = AppPage.Blackbird
		}
	}
end

t1.RM = "RM"
t3[t1.RM] = "CommonUI.Features.Label.RM"
t4[t1.RM] = Images["icons/brands/moments_large"]
t6[t1.RM] = {
	rightImage = "LuaApp/icons/navigation/pushRight_small",
	badgeCount = 0,
	itemType = t1.RM,
	textKey = t3[t1.RM],
	icon = t4[t1.RM],
	context = if not FFlagEnableArgusFlyoutEntry or not FFlagEnableArgus then {
		appURI = v32
	} else {
		page = AppPage.Moments
	}
}

local function v57(p12) -- line: 915
	-- upvalues: FFlagEnableFlyoutSidePanel (copy)
	if FFlagEnableFlyoutSidePanel then
		return p12 and type(p12) == "table"
	end

	return p12 ~= false
end

return {
	ItemType = t1,
	ItemInfo = t6,
	SectionType = t2,
	GetItemsInPage = function(p13, _, _, p16, p17, _, _, _, _, _) -- line: 927
		-- upvalues: v18 (copy), GetFFlagEnableGateNotificationPreferencesTab (copy), GetFFlagEnableSupportCenter (copy), AppPage (copy), t2 (copy), t6 (copy), t1 (copy), Cryo (copy), FFlagEnableFlyoutSidePanel (copy), FFlagMorePageTermsPrivacyFooter (copy), v57 (copy), FFlagEnableSafetyDashboard (copy), v36 (copy), FFlagEnableRobuxTransferLimitSettings (copy), Images (copy)
		if v18 then
			p17 = true
		end

		local v82 = not GetFFlagEnableGateNotificationPreferencesTab() or type(p16) == "table" and p16.enableNotificationPreferencesTab
		local v83 = type(p16) == "table" and (p16.hideBillingTab == nil or p16.hideBillingTab)
		local v84 = not not GetFFlagEnableSupportCenter() and (type(p16) == "table" and p16.isSupportCenterEnabled)
		local t7 = {
			[AppPage.SimplifiedMore] = {
				{
					type = t2.Navigation,
					contents = { t6[t1.About_Terms] }
				},
				{
					type = t2.Action,
					contents = { t6[t1.LogOut] }
				}
			},
			[AppPage.About] = {{
				type = t2.Navigation,
				contents = Cryo.List.filter({
					t6[t1.About_AboutUs],
					not not FFlagEnableFlyoutSidePanel and t6[t1.Blog],
					t6[t1.About_Careers],
					t6[t1.About_Parents],
					not FFlagMorePageTermsPrivacyFooter and if not FFlagEnableFlyoutSidePanel then t6[t1.About_Terms] else nil,
					not FFlagMorePageTermsPrivacyFooter and if not FFlagEnableFlyoutSidePanel then t6[t1.About_Privacy] else nil,
					t6[t1.About_AppInformation]
				}, v57)
			}},
			[AppPage.SafetySupport] = {{
				type = t2.Navigation,
				contents = if not FFlagEnableFlyoutSidePanel then if not GetFFlagEnableSupportCenter() then if not FFlagEnableSafetyDashboard then {
					t6[t1.SafetySupport_Help],
					t6[t1.SafetySupport_ReportAppeals]
				} else {
					t6[t1.SafetySupport_AccountStatus],
					t6[t1.SafetySupport_Help]
				} else Cryo.List.filter({
					not not FFlagEnableSafetyDashboard and t6[t1.SafetySupport_AccountStatus],
					t6[t1.SafetySupport_Help],
					not FFlagEnableSafetyDashboard and t6[t1.SafetySupport_ReportAppeals],
					not not v84 and t6[t1.SafetySupport_SupportCenter]
				}, v57) else Cryo.List.filter({
					not not FFlagEnableSafetyDashboard and t6[t1.SafetySupport_AccountStatus],
					t6[t1.SafetySupport_Help],
					not FFlagEnableSafetyDashboard and t6[t1.SafetySupport_ReportAppeals],
					not not GetFFlagEnableSupportCenter() and (not not v84 and t6[t1.SafetySupport_SupportCenter]),
					t6[t1.About],
					not v36 and t6[t1.About_Terms],
					not v36 and t6[t1.About_Privacy]
				}, v57)
			}},
			[AppPage.CJVAbout] = {{
				type = t2.Navigation,
				contents = Cryo.List.filter({
					t6[t1.About_AboutUs_CJV],
					t6[t1.About_Careers],
					t6[t1.About_Terms],
					t6[t1.About_Privacy],
					t6[t1.About_PrivacyGuidelinesChildren],
					t6[t1.About_LuobuRiderTerms],
					t6[t1.About_LuobuThirdPartyDataUse],
					t6[t1.About_AppInformation]
				}, v57)
			}},
			[AppPage.Settings] = {{
				type = t2.Navigation,
				contents = Cryo.List.filter({
					t6[t1.Settings_AccountInfo],
					t6[t1.Settings_Security],
					t6[t1.Settings_Privacy],
					not not p17 and (t6[t1.Settings_ParentalControls] or false),
					not v83 and (t6[t1.Settings_Billing] or false),
					t6[t1.Settings_Subscriptions],
					not not FFlagEnableRobuxTransferLimitSettings and (t6[t1.Settings_Robux] or false),
					not not v82 and (t6[t1.Settings_Notifications] or false),
					t6[t1.Settings_Accessibility]
				}, v57)
			}},
			[AppPage.CJVSettings] = {{
				type = t2.Navigation,
				contents = Cryo.List.filter({
					t6[t1.Settings_AccountInfo],
					t6[t1.Settings_Security],
					t6[t1.Settings_Privacy],
					false
				}, v57)
			}},
			[AppPage.TenFootSettings] = {{
				type = t2.Content,
				contents = {
					{
						itemInfo = t6[t1.Settings_SwitchProfileSection]
					},
					{
						itemInfo = t6[t1.Settings_AccountSettingsSection],
						subItems = { t6[t1.Settings_AccountSettingsInfo] }
					},
					{
						itemInfo = t6[t1.Settings_DeviceSettingsSection]
					}
				}
			}},
			[AppPage.TenFootAbout] = {{
				type = t2.Content,
				contents = {
					{
						itemInfo = t6[t1.About_AboutSection],
						subItems = if not FFlagMorePageTermsPrivacyFooter then {
							t6[t1.About_TermsOfService],
							Cryo.Dictionary.join(t6[t1.About_Privacy], {
								rightImage = Images["icons/navigation/externallink_medium"]
							})
						} else {}
					},
					{
						itemInfo = t6[t1.About_LicensingSection]
					},
					{
						itemInfo = t6[t1.About_VersionSection]
					}
				}
			}}
		}
		local v86 = t7[AppPage.SimplifiedMore]

		if t7[p13] ~= nil then
			v86 = t7[p13]
		end

		return v86
	end
}
