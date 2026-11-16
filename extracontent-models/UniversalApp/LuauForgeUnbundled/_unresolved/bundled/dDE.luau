local module = require("@luauforge/bundled/dCo")

local module2 = require("@luauforge/bundled/dCp")

local module3 = require("@luauforge/bundled/dDF")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableGroupOverviewPane = SharedFlags.FFlagEnableGroupOverviewPane
local defineFastFlag = game:DefineFastFlag("ProfileMomentsFeedHideTabBar", false)
local defineFastFlag2 = game:DefineFastFlag("ProfileHideTabBarOnAboutSheet", false)
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagSocialTabsPageSplitPaneLayout = SharedFlags.FFlagSocialTabsPageSplitPaneLayout

local splitPaneSlot = if fFlagEnableSplitPane then require("@luauforge/bundled/dDG").Enums.SplitPaneSlot else nil

local module5 = require("@luauforge/bundled/dDH")

local v5 = if fFlagEnableGroupOverviewPane then require("@luauforge/bundled/dDJ") else nil

local v6 = if fFlagEnableSplitPane then require("@luauforge/bundled/dFQ") else nil

local getFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft

local getFFlagLuaAppChallengeDialogContainerPageEnabled = require("@luauforge/bundled/dFS").GetFFlagLuaAppChallengeDialogContainerPageEnabled
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local defineFastFlag3 = game:DefineFastFlag("LuaAppIncorrectWebViewProperty", false)
local module6 = require("@luauforge/bundled/dGU")
local module7 = require("@luauforge/bundled/dGV")

local socialNetworksInEditProfileIXP = require("@luauforge/bundled/dGW").SocialNetworksInEditProfileIXP
local fFlagUnifyConsoleSettingsPage = SharedFlags.FFlagUnifyConsoleSettingsPage
local module8 = require("@luauforge/bundled/dHl")
local getFFlagLuaAppEnableTopBanner = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableTopBanner
local fFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fStringMomentsFeedWatchPageRouteName = SharedFlags.FStringMomentsFeedWatchPageRouteName
local fFlagProfileRenderAvatarMoments = SharedFlags.FFlagProfileRenderAvatarMoments
local fFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local fFlagEnableLoginV2Modalization = SharedFlags.FFlagEnableLoginV2Modalization
local getFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local fFlagLuaAppBirthdayComplianceGate = SharedFlags.FFlagLuaAppBirthdayComplianceGate
local fFlagTutorialUpsellEnabled = SharedFlags.FFlagTutorialUpsellEnabled

local fFlagEnableSocialProofUserList = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSocialProofUserList
local fFlagProfilePlatformAddTC = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagProfilePlatformAddTC
local fFlagTCShareLinkErrorModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagTCShareLinkErrorModal
local fFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local fFlagAppIaHomeCampaignSubTab = SharedFlags.FFlagAppIaHomeCampaignSubTab
local defineFastFlag4 = game:DefineFastFlag("FixOneByTwoAndroidBackNavigation", false)
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagBuildExperienceHideNavBarOnSubPages = SharedFlags.FFlagBuildExperienceHideNavBarOnSubPages
local fFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace
local fFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local fFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local defineFastFlag5 = game:DefineFastFlag("AppIaScrollAwayDisableChat", false)
local fFlagRenameAvatarToMe = SharedFlags.FFlagRenameAvatarToMe
local fFlagLuaAppSortDeeplinkFix = SharedFlags.FFlagLuaAppSortDeeplinkFix
local fFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled
local fFlagLuaAppSduiLandingPageEnabled = SharedFlags.FFlagLuaAppSduiLandingPageEnabled
local defineFastFlag6 = game:DefineFastFlag("WebViewHideLuaSideBar", false)
local fFlagFixMoreSubMenuTitleFlash = SharedFlags.FFlagFixMoreSubMenuTitleFlash
local fFlagEnableSocialProofVerticalUserListSheet = SharedFlags.FFlagEnableSocialProofVerticalUserListSheet
local fFlagEnableSchoolEntry = SharedFlags.FFlagEnableSchoolEntry
local defineFastFlag7 = game:DefineFastFlag("TCEducationModalSideBarPolicy", false)
local fFlagLuaAppSduiEdpEnabled = SharedFlags.FFlagLuaAppSduiEdpEnabled
local defineFastFlag8 = game:DefineFastFlag("SduiEdpShowLeftNavOnConsole", false)
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagLuaAppEnableStratusStreamingTestOnly = SharedFlags.FFlagLuaAppEnableStratusStreamingTestOnly
local fFlagLuaAppCloudClientPlayButtonOffer = SharedFlags.FFlagLuaAppCloudClientPlayButtonOffer
local fFlagEnableMobileGameJoinCard = SharedFlags.FFlagEnableMobileGameJoinCard
local fFlagSocialCarouselBuildPresence = SharedFlags.FFlagSocialCarouselBuildPresence
local fFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage
local fFlagEnableUserRecentActivityEntryPoint = SharedFlags.FFlagEnableUserRecentActivityEntryPoint
local fFlagEnableRecentActivityInspectAndBuy = SharedFlags.FFlagEnableRecentActivityInspectAndBuy
local fFlagEnablePlusReferralDashboard = SharedFlags.FFlagEnablePlusReferralDashboard

local v7 = {
	[module2.None] = {
		nameLocalizationKey = "CommonUI.Features.Label.Nil",
		disableAppTopBanner = true
	},
	[module2.Startup] = {
		tabBarHidden = module3.Hidden,
		nameLocalizationKey = "CommonUI.Features.Label.Startup",
		disableAppTopBanner = true
	},
	[module2.Landing] = {
		tabBarHidden = module3.Hidden,
		nameLocalizationKey = "CommonUI.Features.Label.Startup",
		appShellReporterFeature = Enum.AppShellFeature.Landing
	},
	[module2.PioneerPostAuth] = {
		tabBarHidden = module3.Hidden,
		nameLocalizationKey = "CommonUI.Features.Label.Startup"
	},
	[module2.Login] = {
		nameLocalizationKey = "Authentication.Login.Heading.Login",
		tabBarHidden = module3.Hidden,
		disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil
	},
	[module2.LoginV2] = {
		nameLocalizationKey = "Authentication.Login.Heading.Login",
		tabBarHidden = module3.Hidden,
		disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil,
		disableBackButton = true,
		renderUnderlyingPage = fFlagEnableLoginV2Modalization
	},
	[module2.WechatQQAuth] = {
		nameLocalizationKey = "Authentication.Login.Heading.Login",
		tabBarHidden = module3.Hidden,
		disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil,
		disableBackButton = true
	},
	[module2.AccountRecovery] = {
		nameLocalizationKey = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		tabBarHidden = module3.Hidden,
		disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil,
		disableBackButton = true
	},
	[module2.CrossDeviceLogin] = {
		nameLocalizationKey = "Authentication.CrossDevice.Heading.QuickLogin",
		tabBarHidden = module3.Hidden
	},
	[module2.Birthday] = {
		nameLocalizationKey = "Authentication.SignUp.Label.WhensYourBirthday",
		tabBarHidden = module3.Hidden
	},
	[module2.SinglePageSignUp] = {
		nameLocalizationKey = "Authentication.SignUp.Label.SignUp",
		tabBarHidden = module3.Hidden,
		disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil
	},
	[module2.MultiPageSignup] = {
		nameLocalizationKey = "Authentication.SignUp.Label.SignUp",
		tabBarHidden = module3.Hidden,
		disableBackButton = true,
		disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil
	},
	[module2.LuobuSignUpPage] = {
		nameLocalizationKey = "Authentication.SignUp.Label.SignUp",
		tabBarHidden = module3.Hidden
	},
	[module2.WeChatLoginWrapper] = {
		nativeWrapper = true,
		tabBarHidden = module3.Hidden
	}
}

local home = module2.Home
local v8 = {
	nameLocalizationKey = "CommonUI.Features.Label.Home",
	appShellReporterFeature = Enum.AppShellFeature.HomePage,
	tabBarHidden = module3.Visible,
	enableScrollAway = fFlagAppIaScrollAway and true or nil,
	splitPaneEligibility = 0
}

local v9 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
v8.splitPaneEligibility = v9
v7[home] = v8

local games = module2.Games
local v10 = {
	nameLocalizationKey = module.GetGamesTabName(),
	appShellReporterFeature = Enum.AppShellFeature.GamePage,
	tabBarHidden = module3.Visible,
	enableScrollAway = fFlagAppIaScrollAway and true or nil,
	splitPaneEligibility = 0
}

local v11 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
v10.splitPaneEligibility = v11
v7[games] = v10

local gameDetail = module2.GameDetail
local v12 = {
	nameLocalizationKey = "CommonUI.Features.Heading.GameDetails",
	tabBarHidden = module5,
	renderUnderlyingPage = true,
	blurUnderlyingPage = true,
	appShellReporterFeature = Enum.AppShellFeature.GamePage,
	isPeekView = true,
	splitPaneEligibility = 0
}

local v13 = if fFlagEnableSplitPane then splitPaneSlot.Support else nil
v12.splitPaneEligibility = v13
v7[gameDetail] = v12

v7[module2.AvatarExperienceRoot] = {
	nameLocalizationKey = fFlagRenameAvatarToMe and "CommonUI.Features.Label.Me" or "CommonUI.Features.Label.Avatar",
	tabBarHidden = module3.Visible,
	overridesAppRouterTabBarControl = true,
	appShellReporterFeature = Enum.AppShellFeature.AvatarEditor,
	disableBackButton = true,
	disableAppTopBanner = getFFlagLuaAppEnableTopBanner() and true or nil,
	enableScrollAway = fFlagEnableBottomNavOnMarketplace and fFlagAppIaScrollAway and true or nil,
	disableHeaderScrollAway = fFlagEnableBottomNavOnMarketplace and fFlagAppIaScrollAwayPinHeader and true or nil,
	disableGlobalScrollAwayTouch = fFlagEnableBottomNavOnMarketplace and fFlagAppIaScopedScrollAway and true or nil
}

v7[module2.Chat] = {
	nameLocalizationKey = "CommonUI.Features.Label.Chat",
	overridesAppRouterTabBarControl = true,
	appShellReporterFeature = Enum.AppShellFeature.Chat,
	enableScrollAway = fFlagAppIaScrollAway and not defineFastFlag5 and true or nil
}

v7[module2.ContentFeed] = {
	disableBackButton = false,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.ShareGameToChat] = not fFlagShareTargetGameCleanup
	and { tabBarHidden = module3.PolicyDependent }
	or nil

v7[module2.AvatarExperienceWrapper] = {
	overridesAppRouterTabBarControl = true,
	appShellReporterFeature = Enum.AppShellFeature.AvatarEditor,
	disableBackButton = true
}

v7[module2.AvatarExperienceWrapperTransparent] = {
	overridesAppRouterTabBarControl = true,
	renderUnderlyingPage = true,
	appShellReporterFeature = Enum.AppShellFeature.AvatarEditor,
	disableBackButton = true
}

v7[module2.FeatureTileAdPlayer] = {
	tabBarHidden = module3.Visible,
	overridesAppRouterTabBarControl = true,
	renderUnderlyingPage = true,
	disableBackButton = not defineFastFlag4 or nil,
	disableAppTopBanner = true
}

v7[module2.SearchPage] = {
	tabBarHidden = module3.Visible,
	overridesAppRouterTabBarControl = false,
	enableScrollAway = fFlagAppIaScrollAway and true or nil
}

v7[module2.More] = {
	nameLocalizationKey = "CommonUI.Features.Label.More",
	tabBarHidden = module3.Visible,
	appShellReporterFeature = Enum.AppShellFeature.More,
	enableScrollAway = fFlagAppIaScrollAway and true or nil
}

local accountInfo = module2.AccountInfo

local v15 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[accountInfo] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v15,
	renderUnderlyingPage = true
}

v7[module2.About] = {
	nameLocalizationKey = "CommonUI.Features.Label.About",
	tabBarHidden = module3.Visible,
	alwaysShowBackButton = fFlagFixMoreSubMenuTitleFlash and true or nil
}

v7[module2.SafetySupport] = {
	nameLocalizationKey = "CommonUI.Features.Label.HelpAndSafety",
	tabBarHidden = module3.Visible,
	alwaysShowBackButton = fFlagFixMoreSubMenuTitleFlash and true or nil
}

v7[module2.Settings] = {
	nameLocalizationKey = "CommonUI.Features.Label.Settings",
	tabBarHidden = module3.Visible,
	alwaysShowBackButton = fFlagFixMoreSubMenuTitleFlash and true or nil
}

v7[module2.AccountSettings] = fFlagUnifyConsoleSettingsPage
	and {
		nameLocalizationKey = "Feature.Settings.Heading.AccountSettings",
		tabBarHidden = module3.Visible
	}
	or nil

v7[module2.PlatformSettings] = fFlagUnifyConsoleSettingsPage and {
	tabBarHidden = module3.Visible
} or nil

v7[module2.Accessibility] = {
	nameLocalizationKey = "Feature.Accessibility.Heading.DevicePreferences",
	tabBarHidden = module3.Visible
}

v7[module2.Licensing] = {
	nameLocalizationKey = "CommonUI.Features.Label.Licensing",
	tabBarHidden = module3.Visible
}

v7[module2.AppInformation] = {
	nameLocalizationKey = "CommonUI.Features.Label.AppInformation",
	tabBarHidden = module3.Visible
}

v7[module2.DevSubs] = {
	nameLocalizationKey = "CommonUI.Features.Label.DevSubs",
	tabBarHidden = module3.Visible
}

v7[module2.AddFriendsPage] = {
	nameLocalizationKey = "Feature.Friends.Feature.Friends.Heading.AddFriends",
	nativeWrapper = false,
	tabBarHidden = module3.PolicyDependent,
	bottomTabBarHidden = true,
	sideTabBarHidden = false
}

v7[module2.Build] = fFlagAppNavMyStatsTab and {
	nameLocalizationKey = "CommonUI.Features.NavBar.Build",
	tabBarHidden = module3.Visible,
	overridesAppRouterTabBarControl = fFlagBuildExperienceHideNavBarOnSubPages and true or nil
} or nil

v7[module2.ConnectionsHub] = {
	nativeWrapper = false,
	tabBarHidden = module3.PolicyDependent,
	bottomTabBarHidden = true,
	sideTabBarHidden = false
}

local buildersClub = module2.BuildersClub

local v17 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[buildersClub] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v17,
	renderUnderlyingPage = true
}

v7[module2.InviteLinkExpiredModal] = { absorbInput = true, renderUnderlyingPage = true }

v7[module2.ShareLinkInvalidModal] = { absorbInput = true, renderUnderlyingPage = true }

v7[module2.VerifiedBadgeModal] = { renderUnderlyingPage = true }

v7[module2.ShareVirtualEventModal] = { renderUnderlyingPage = true }

v7[module2.EventNotificationsModal] = { renderUnderlyingPage = true }

local eventDetails = module2.EventDetails
local v19 = if not fFlagLuaAppSduiEventDetailsEnabled then module3.PolicyDependent else nil
v7[eventDetails] = {
	tabBarHidden = v19,
	renderUnderlyingPage = true,
	blurUnderlyingPage = not fFlagLuaAppSduiEventDetailsEnabled or nil
}

v7[module2.TencentHelp] = {
	nameLocalizationKey = "CommonUI.Features.Label.Help",
	nativeWrapper = true,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.TencentNoticeCenter] = {
	nameLocalizationKey = "CommonUI.Features.Label.TencentNotice",
	tabBarHidden = module3.Visible
}

v7[module2.TencentNoticeContent] = {
	nameLocalizationKey = "CommonUI.Features.Label.TencentNotice",
	tabBarHidden = module3.Visible
}

local genericWebPage = module2.GenericWebPage

local v21 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[genericWebPage] = {
	webView = true,
	nativeWrapper = true,
	renderUnderlyingPage = true,
	tabBarHidden = v21
}

local settingsSubPage = module2.SettingsSubPage

local v23 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[settingsSubPage] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v23,
	renderUnderlyingPage = true
}

v7[module2.SecurityAlertInfo] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = module3.Hidden,
	renderUnderlyingPage = true
}

local youTubePlayer = module2.YouTubePlayer

local v25 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[youTubePlayer] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v25,
	renderUnderlyingPage = true
}

local purchaseRobux = module2.PurchaseRobux

local v27 = if defineFastFlag6 or isTenFootInterface() then module3.Hidden else module3.PolicyDependent
v7[purchaseRobux] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v27,
	renderUnderlyingPage = not (isTenFootInterface() or isVRAppBuild())
}

local payment = module2.Payment

local v29 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[payment] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v29,
	renderUnderlyingPage = true
}

v7[module2.SubscriptionPurchase] = {
	webView = false,
	nativeWrapper = true,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.Notifications] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.LogoutConfirmation] = {
	nativeWrapper = true,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

local addFriends = module2.AddFriends

local v31 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[addFriends] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v31,
	renderUnderlyingPage = true
}

local viewUserProfile = module2.ViewUserProfile

local v33 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[viewUserProfile] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v33,
	renderUnderlyingPage = true
}

local viewProfile = module2.ViewProfile

local v35 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[viewProfile] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v35,
	renderUnderlyingPage = true
}

v7[module2.AccountSelectorPeekView] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true,
	disableBackButton = true,
	isPeekView = true
}

v7[module2.AccountSwitchingAddAccountPeekView] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true,
	disableBackButton = true,
	isPeekView = true
}

v7[module2.LoginNative] = {
	nativeWrapper = true,
	tabBarHidden = module3.Hidden,
	renderUnderlyingPage = true
}

v7[module2.CaptchaNative] = {
	nativeWrapper = true,
	tabBarHidden = module3.Hidden,
	renderUnderlyingPage = true
}

v7[module2.ViewFriends] = {
	webView = false,
	nativeWrapper = false,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = false
}

v7[module2.ShareSheet] = {
	nativeWrapper = true,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.SdkShare] = {
	nativeWrapper = false,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true,
	disableBackButton = true
}

local reportAbuse = module2.ReportAbuse

local v37 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
v7[reportAbuse] = {
	webView = true,
	nativeWrapper = true,
	tabBarHidden = v37,
	renderUnderlyingPage = true
}

v7[module2.ScanQrCode] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.GenericOpaqueWebPage] = {
	nativeWrapper = true,
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = false
}

v7[module2.ChallengeHybridOverlayPage] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true
}

v7[module2.ChallengeHybridWebView] = {
	nativeWrapper = true,
	tabBarHidden = module3.Hidden,
	renderUnderlyingPage = true
}

local profilePlatform = module2.ProfilePlatform

local v39 = if fFlagEnableSplitPane then v6 else module3.PolicyDependent

local v40 = if fFlagEnableSplitPane then splitPaneSlot.Support else nil
v7[profilePlatform] = {
	nameLocalizationKey = "CommonUI.Features.Label.Profile",
	tabBarHidden = v39,
	renderUnderlyingPage = true,
	isPeekView = true,
	disableBackButton = true,
	splitPaneEligibility = v40
}

local groups = module2.Groups

if not fFlagEnableGroupOverviewPane then
	v5 = module3.PolicyDependent
end

v7[groups] = {
	nameLocalizationKey = "CommonUI.Features.Label.Groups",
	tabBarHidden = v5,
	disableBackButton = fFlagEnableGroupOverviewPane
}

v7[module2.SocialUnableToJoinExperience] = {
	overlayEnabled = true,
	transparent = true,
	absorbInput = true,
	overlayTransparency = 0.5,
	renderUnderlyingPage = true,
	disableBackButton = true
}

v7[module2.SocialPurchaseExperience] = {
	overlayEnabled = true,
	transparent = true,
	absorbInput = true,
	overlayTransparency = 0.5,
	renderUnderlyingPage = true,
	disableBackButton = true
}

v7[module2.SocialToast] = {
	overlayEnabled = true,
	transparent = true,
	absorbInput = false,
	overlayTransparency = 1,
	renderUnderlyingPage = true,
	disableBackButton = true
}

v7[module2.EditSocialNetworks] = socialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled()
	and {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true
	}
	or nil

v7[module2.EditSocialNetworksError] = socialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled()
	and {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true
	}
	or nil

local phoneVerification = module2.PhoneVerification

local v43 = if defineFastFlag6 and not defineFastFlag3 then module3.Hidden else module3.PolicyDependent
v7[phoneVerification] = {
	webView = not defineFastFlag3 or nil,
	tabBarHidden = v43,
	renderUnderlyingPage = true
}

local editUsername = module2.EditUsername

local v45 = if defineFastFlag6 and not defineFastFlag3 then module3.Hidden else module3.PolicyDependent
v7[editUsername] = {
	webView = not defineFastFlag3 or nil,
	tabBarHidden = v45,
	renderUnderlyingPage = true
}

v7[module2.ExperienceGuidelinesExplained] = {
	nameLocalizationKey = "Feature.GameDetails.Label.ContentMaturity",
	disableBackButton = false,
	renderUnderlyingPage = true
}

v7[module2.AgeVerificationRequired] = {
	disableBackButton = false,
	renderUnderlyingPage = true
}

v7[module2.AccountSettingsUpsell] = {
	renderUnderlyingPage = true,
	tabBarHidden = module3.PolicyDependent
}

v7[module2.IDVUpsellContainer] = { renderUnderlyingPage = true }

v7[module2.VPCUpsellContainer] = { renderUnderlyingPage = true }

v7[module2.RobloxSubscriptionUpsell] = { renderUnderlyingPage = true }

v7[module2.AmpWizardContainer] = { renderUnderlyingPage = true }

v7[module2.AccountUnlock] = {
	renderUnderlyingPage = true,
	disableBackButton = true,
	disableAppTopBanner = true
}

local gamesList = module2.GamesList

local v47 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
v7[gamesList] = {
	enableScrollAway = fFlagAppIaScrollAway and true or nil,
	splitPaneEligibility = v47
}

v7[module2.SduiLandingPage] = fFlagLuaAppSduiLandingPageEnabled and {
		tabBarHidden = module3.Visible
	}
	or nil

local deeplinkGamesList = module2.DeeplinkGamesList
local v48

if fFlagLuaAppSortDeeplinkFix then
	v48 = {
		enableScrollAway = fFlagAppIaScrollAway and true or nil,
		splitPaneEligibility = 0
	}

	local v49 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
	v48.splitPaneEligibility = v49
end

v7[deeplinkGamesList] = v48

v7[module2.ContactImporter] = {
	tabBarHidden = module3.Hidden,
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.ContactsList] = {
	tabBarHidden = module3.Hidden,
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.UAppBlock] = {
	tabBarHidden = module3.Hidden,
	nameLocalizationKey = "CommonUI.Features.Label.Startup"
}

v7[module2.PassesPage] = {
	nameLocalizationKey = "Feature.GameDetails.Label.Store",
	appShellReporterFeature = Enum.AppShellFeature.GamePage
}

v7[module2.SocialMessageToast] = {
	renderUnderlyingPage = true,
	disableBackButton = true
}

v7[module2.ProfileQRCodePage] = {
	absorbInput = true,
	renderUnderlyingPage = true,
	tabBarHidden = module3.PolicyDependent
}

local parentVerification = module2.ParentVerification

local v50 = if defineFastFlag6 then module3.Hidden else nil
v7[parentVerification] = { webView = true, tabBarHidden = v50 }

local emailVerification = module2.EmailVerification

local v52 = if defineFastFlag6 then module3.Hidden else nil
v7[emailVerification] = { webView = true, tabBarHidden = v52 }

v7[module2.AddAuthMethodPage] = { tabBarHidden = module3.Hidden }

v7[module2.PasskeyUpsellScreen] = fFlagPasskeyUpsellEnabled
	and { renderUnderlyingPage = true, tabBarHidden = module3.Hidden }
	or nil

v7[module2.PlatformLockedPage] = getFFlagEnablePlatformRestrictedEventReceiver()
	and { tabBarHidden = module3.Hidden }
	or nil

v7[module2.BirthdayCompliancePage] = fFlagLuaAppBirthdayComplianceGate
	and {
		tabBarHidden = module3.Hidden,
		renderUnderlyingPage = true,
		disableBackButton = true,
		disableAppTopBanner = true
	}
	or nil

v7[module2.TutorialUpsellScreen] = fFlagTutorialUpsellEnabled
	and { renderUnderlyingPage = true, tabBarHidden = module3.Hidden }
	or nil

v7[module2.SponsoredTooltipPeekView] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true,
	disableBackButton = true,
	isPeekView = true
}

v7[module2.InfoPeekView] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true,
	disableBackButton = true,
	isPeekView = true
}

v7[module2.ReportDialog] = { disableBackButton = false, renderUnderlyingPage = true }

v7[module2.VoiceTrialUpsell] = module8() and {
	renderUnderlyingPage = true,
	absorbInput = true
} or nil

v7[module2.GameFilterMenuPeekView] = {
	tabBarHidden = module3.PolicyDependent,
	renderUnderlyingPage = true,
	disableBackButton = true,
	isPeekView = true
}

if fFlagAppIaHomeCampaignSubTab then
	local campaign = module2.Campaign
	local v53 = {
		nameLocalizationKey = "Feature.Home.Button.Join",
		tabBarHidden = module3.Visible,
		enableScrollAway = fFlagAppIaScrollAway and true or nil,
		splitPaneEligibility = 0
	}

	local v54 = if fFlagEnableSplitPane then splitPaneSlot.Content else nil
	v53.splitPaneEligibility = v54
	v7[campaign] = v53
end

if getFFlagLuaAppChallengeDialogContainerPageEnabled() then
	v7[module2.ChallengeDialogModalContainer] = {
		tabBarHidden = module3.Hidden,
		renderUnderlyingPage = true
	}
end

if getFFlagEnableAbuseReport10ft() then
	v7[module2.ReportScreen] = {
		nameLocalizationKey = "Feature.GameDetails.Label.ReportAbuse",
		tabBarHidden = module3.Visible,
		renderUnderlyingPage = false
	}
end

if module6() then
	v7[module2.ChallengeNativeWrapper] = {
		nativeWrapper = true,
		tabBarHidden = module3.Hidden,
		renderUnderlyingPage = true
	}
end

if module7() then
	v7[module2.PlatformAccountRouter] = { tabBarHidden = module3.Hidden }
end

v7[module2.DiscoverabilityOverlay] = {
	tabBarHidden = module3.Hidden,
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.FindFriendsModal] = {
	tabBarHidden = module3.Hidden,
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.ContactsRevokedAccessDialog] = {
	tabBarHidden = module3.Hidden,
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.SettingsPermissionInteractiveAlert] = {
	tabBarHidden = module3.Hidden,
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

local trustedContactsEducationModal = module2.TrustedContactsEducationModal
local v54 = if not defineFastFlag7 then module3.Hidden else nil
v7[trustedContactsEducationModal] = {
	tabBarHidden = v54,
	bottomTabBarHidden = not defineFastFlag7 or nil,
	sideTabBarHidden = not defineFastFlag7 or nil,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

if fFlagProfilePlatformAddTC then
	v7[module2.TrustedContactsModal] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true,
		overlayTransparency = 1
	}
end

v7[module2.TrustedFriendsVPCPrologue] = {
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.AmpV2Wizard] = {
	tabBarHidden = module3.PolicyDependent,
	bottomTabBarHidden = true,
	sideTabBarHidden = false,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.FAEUpsell] = {
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}

v7[module2.FriendsRenameInfoModal] = {
	tabBarHidden = module3.PolicyDependent,
	isPeekView = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	absorbInput = true
}

if fFlagTCShareLinkErrorModal then
	v7[module2.TrustedFriendsShareLinkErrorModal] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true,
		absorbInput = true
	}
end

if fFlagEnableSocialProofUserList then
	v7[module2.FriendsOwnedUserList] = {
		renderUnderlyingPage = true,
		isPeekView = true,
		overlayEnabled = true
	}
end

if fFlagEnableSocialProofVerticalUserListSheet then
	v7[module2.SocialProofVerticalUserListSheet] = {
		renderUnderlyingPage = true,
		isPeekView = true,
		overlayEnabled = true
	}
end

if fFlagEnableSchoolEntry then
	v7[module2.Schools] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true
	}
end

v7[module2.MutualConnectionList] = {
	renderUnderlyingPage = true,
	isPeekView = true,
	overlayEnabled = true
}

if fFlagEnableSocialTabsPage then
	local socialTabsPage = module2.SocialTabsPage

	if not fFlagSocialTabsPageSplitPaneLayout then
		v6 = module3.PolicyDependent
	end

	v7[socialTabsPage] = {
		hasSubNavigation = true,
		tabBarHidden = v6,
		nativeWrapper = false,
		renderUnderlyingPage = true,
		bottomTabBarHidden = true,
		overlayEnabled = true,
		overlayTransparency = 0.5
	}
end

v7[module2.BlockingModal] = { renderUnderlyingPage = true, overlayEnabled = true }

local aboutDetailsSheet = module2.AboutDetailsSheet

local v56 = if defineFastFlag2 then module3.PolicyDependent else nil
v7[aboutDetailsSheet] = {
	isPeekView = true,
	renderUnderlyingPage = true,
	overlayEnabled = true,
	tabBarHidden = v56
}

local profileMomentsFeed = module2.ProfileMomentsFeed
local v57 = {
	isPeekView = not fFlagProfileRenderAvatarMoments or nil,
	renderUnderlyingPage = not fFlagProfileRenderAvatarMoments,
	overlayEnabled = not fFlagProfileRenderAvatarMoments,
	tabBarHidden = 0,
	bottomTabBarHidden = 0,
	sideTabBarHidden = 0,
	disableAppTopBanner = 0
}
local v58

if fFlagProfileRenderAvatarMoments then
	v58 = module3.Hidden
elseif defineFastFlag then
	v58 = module3.PolicyDependent
end

v57.tabBarHidden = v58

v57.bottomTabBarHidden = fFlagProfileRenderAvatarMoments and true or nil
v57.sideTabBarHidden = fFlagProfileRenderAvatarMoments and true or nil
v57.disableAppTopBanner = fFlagProfileRenderAvatarMoments and true or nil
v7[profileMomentsFeed] = v57

v7[module2.NotApprovedPage] = {
	tabBarHidden = module3.Hidden,
	disableBackButton = true,
	disableAppTopBanner = true
}

v7[module2.AdjustScreen] = { tabBarHidden = module3.Hidden }

local experienceDetail = module2.ExperienceDetail

local v60 = if isTenFootInterface() and not (defineFastFlag8 and fFlagLuaAppSduiEdpEnabled) then module3.Hidden else module3.Visible
v7[experienceDetail] = { tabBarHidden = v60 }

if fFlagEnableBlackbird then
	local blackbird = module2.Blackbird

	local v62 = if defineFastFlag6 then module3.Hidden else module3.PolicyDependent
	v7[blackbird] = {
		webView = true,
		nativeWrapper = true,
		tabBarHidden = v62,
		renderUnderlyingPage = true
	}
end

if fFlagLuaAppEnableStratusStreamingTestOnly or fFlagLuaAppCloudClientPlayButtonOffer then
	v7[module2.VideoServer] = {
		tabBarHidden = module3.Hidden,
		nameLocalizationKey = "CommonUI.Features.Label.Nil",
		disableAppTopBanner = true,
		disableBackButton = true
	}
end

if fFlagEnableMobileGameJoinCard then
	v7[module2.GameJoinCard] = {
		tabBarHidden = module3.PolicyDependent,
		isPeekView = true,
		renderUnderlyingPage = true,
		overlayEnabled = true
	}
end

if fFlagSocialCarouselBuildPresence then
	v7[module2.BuildJoinCard] = {
		tabBarHidden = module3.PolicyDependent,
		isPeekView = true,
		renderUnderlyingPage = true,
		overlayEnabled = true
	}
end

if fFlagEnableUserRecentActivityEntryPoint then
	v7[module2.UserRecentActivity] = {
		tabBarHidden = module3.PolicyDependent,
		isPeekView = true,
		renderUnderlyingPage = true,
		overlayEnabled = true
	}
end

if fFlagEnableRecentActivityInspectAndBuy then
	v7[module2.RecentActivityInspectAndBuy] = {
		tabBarHidden = module3.PolicyDependent,
		isPeekView = true,
		renderUnderlyingPage = true,
		overlayEnabled = true
	}
end

if fFlagEnableArgus then
	v7[module2.Moments] = {
		nameLocalizationKey = "CommonUI.Features.Label.Moments",
		overridesAppRouterTabBarControl = true,
		appShellReporterFeature = Enum.AppShellFeature.WatchPage
	}

	v7[fStringMomentsFeedWatchPageRouteName] = {
		appShellReporterFeature = Enum.AppShellFeature.WatchPage
	}

	if fFlagEnableArgusImmersiveNav then
		v7[module2.MomentsImmersive] = {
			nameLocalizationKey = "CommonUI.Features.Label.Moments",
			tabBarHidden = module3.Hidden,
			disableAppTopBanner = true,
			appShellReporterFeature = Enum.AppShellFeature.WatchPage
		}
	end
end

if fFlagEnablePlusReferralDashboard then
	v7[module2.PlusReferralDashboard] = { tabBarHidden = module3.PolicyDependent }
end

return v7
