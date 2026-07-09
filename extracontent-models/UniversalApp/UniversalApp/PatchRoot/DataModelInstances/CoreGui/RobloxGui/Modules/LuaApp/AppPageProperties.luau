local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local AppPage = require(Modules.LuaApp.AppPage)
local SystemBarVisibility = require(Modules.LuaApp.Enum.SystemBarVisibility)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local getExperienceDetailsPageNavBarVisible = require(Modules.LuaApp.getExperienceDetailsPageNavBarVisible)
local GetFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft
local GetFFlagLuaAppChallengeDialogContainerPageEnabled = require(CorePackages.Workspace.Packages.ChallengeDialog).GetFFlagLuaAppChallengeDialogContainerPageEnabled
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local v12 = game:DefineFastFlag("LuaAppIncorrectWebViewProperty", false)
local GetFFlagEnableNativeWrapperAppPage = require(Modules.LuaApp.Flags.GetFFlagEnableNativeWrapperAppPage)
local GetFFlagFixNavBarStartupDuplicateAnim = require(Modules.LuaApp.Flags.GetFFlagFixNavBarStartupDuplicateAnim)
local SocialNetworksInEditProfileIXP = require(CorePackages.Workspace.Packages.EditProfile.Flags).SocialNetworksInEditProfileIXP
local FFlagFriendRequestNicknames = SharedFlags.FFlagFriendRequestNicknames
local GetFFlagEnableVoiceTrialUpsellCard = require(Modules.LuaApp.Flags.GetFFlagEnableVoiceTrialUpsellCard)
local GetFFlagLuaAppEnableTopBanner = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableTopBanner
local FFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagMomentsFeedWatchPageAttribution = SharedFlags.FFlagMomentsFeedWatchPageAttribution
local FStringMomentsFeedWatchPageRouteName = SharedFlags.FStringMomentsFeedWatchPageRouteName
local FFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local GetFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local FFlagTutorialUpsellEnabled = SharedFlags.FFlagTutorialUpsellEnabled
local FFlagEnableSocialProofUserList = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSocialProofUserList
local FFlagProfilePlatformAddTC = require(CorePackages.Workspace.Packages.SharedFlags).FFlagProfilePlatformAddTC
local FFlagTCShareLinkErrorModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCShareLinkErrorModal
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppEnableFeatureTileAdPlayer = SharedFlags.FFlagLuaAppEnableFeatureTileAdPlayer
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagEnableBottomNavOnMarketplace = SharedFlags.FFlagEnableBottomNavOnMarketplace
local FFlagAppIaScrollAwayPinHeader = SharedFlags.FFlagAppIaScrollAwayPinHeader
local FFlagAppIaScopedScrollAway = SharedFlags.FFlagAppIaScopedScrollAway
local FFlagRenameAvatarToMe = SharedFlags.FFlagRenameAvatarToMe
local FFlagAddVideoToCommunityProfile = SharedFlags.FFlagAddVideoToCommunityProfile
local FFlagLuaAppSortDeeplinkFix = SharedFlags.FFlagLuaAppSortDeeplinkFix
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled
local FFlagLuaAppSduiLandingPageEnabled = SharedFlags.FFlagLuaAppSduiLandingPageEnabled
local v41 = game:DefineFastFlag("WebViewHideLuaSideBar", false)
local FFlagFixMoreSubMenuTitleFlash = SharedFlags.FFlagFixMoreSubMenuTitleFlash
local FFlagEnableSocialProofVerticalUserListSheet = SharedFlags.FFlagEnableSocialProofVerticalUserListSheet
local FFlagEnableSchoolEntry = SharedFlags.FFlagEnableSchoolEntry
local FFlagEnableLeftNavOnConsole = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableLeftNavOnConsole
local v46 = game:DefineFastFlag("TCEducationModalSideBarPolicy", false)
local FFlagTCModalUseFoundationOverlay = require(CorePackages.Workspace.Packages.SharedFlags).FFlagTCModalUseFoundationOverlay
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagLuaAppEnableStratusStreamingTestOnly = SharedFlags.FFlagLuaAppEnableStratusStreamingTestOnly
local FFlagEnableMobileGameJoinCard = SharedFlags.FFlagEnableMobileGameJoinCard
local FFlagEnableSocialTabsPage = SharedFlags.FFlagEnableSocialTabsPage
local t1 = {
	[AppPage.None] = {
		nameLocalizationKey = "CommonUI.Features.Label.Nil",
		disableAppTopBanner = true
	},
	[AppPage.Startup] = {
		nameLocalizationKey = "CommonUI.Features.Label.Startup",
		disableAppTopBanner = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.Landing] = {
		nameLocalizationKey = "CommonUI.Features.Label.Startup",
		tabBarHidden = SystemBarVisibility.Hidden,
		appShellReporterFeature = Enum.AppShellFeature.Landing
	},
	[AppPage.Login] = {
		nameLocalizationKey = "Authentication.Login.Heading.Login",
		tabBarHidden = SystemBarVisibility.Hidden,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil
	},
	[AppPage.LoginV2] = {
		nameLocalizationKey = "Authentication.Login.Heading.Login",
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.Hidden,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil
	},
	[AppPage.WechatQQAuth] = {
		nameLocalizationKey = "Authentication.Login.Heading.Login",
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.Hidden,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil
	},
	[AppPage.AccountRecovery] = {
		nameLocalizationKey = "Authentication.AccountRecovery.Heading.RobloxAccountRecovery",
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.Hidden,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil
	},
	[AppPage.CrossDeviceLogin] = {
		nameLocalizationKey = "Authentication.CrossDevice.Heading.QuickLogin",
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.Birthday] = {
		nameLocalizationKey = "Authentication.SignUp.Label.WhensYourBirthday",
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.SinglePageSignUp] = {
		nameLocalizationKey = "Authentication.SignUp.Label.SignUp",
		tabBarHidden = SystemBarVisibility.Hidden,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil
	},
	[AppPage.MultiPageSignup] = {
		nameLocalizationKey = "Authentication.SignUp.Label.SignUp",
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.Hidden,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil
	},
	[AppPage.LuobuSignUpPage] = {
		nameLocalizationKey = "Authentication.SignUp.Label.SignUp",
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.WeChatLoginWrapper] = {
		nativeWrapper = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.Home] = {
		nameLocalizationKey = "CommonUI.Features.Label.Home",
		appShellReporterFeature = Enum.AppShellFeature.HomePage,
		tabBarHidden = SystemBarVisibility.Visible,
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.Games] = {
		nameLocalizationKey = FlagSettings.GetGamesTabName(),
		appShellReporterFeature = Enum.AppShellFeature.GamePage,
		tabBarHidden = SystemBarVisibility.Visible,
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.GameDetail] = {
		nameLocalizationKey = "CommonUI.Features.Heading.GameDetails",
		renderUnderlyingPage = true,
		blurUnderlyingPage = true,
		isPeekView = true,
		tabBarHidden = getExperienceDetailsPageNavBarVisible,
		appShellReporterFeature = Enum.AppShellFeature.GamePage
	},
	[AppPage.AvatarExperienceRoot] = {
		overridesAppRouterTabBarControl = true,
		disableBackButton = true,
		nameLocalizationKey = not FFlagRenameAvatarToMe and "CommonUI.Features.Label.Avatar" or "CommonUI.Features.Label.Me",
		tabBarHidden = SystemBarVisibility.Visible,
		appShellReporterFeature = Enum.AppShellFeature.AvatarEditor,
		disableAppTopBanner = not not GetFFlagLuaAppEnableTopBanner() or nil,
		enableScrollAway = FFlagEnableBottomNavOnMarketplace and not not FFlagAppIaScrollAway or nil,
		disableHeaderScrollAway = FFlagEnableBottomNavOnMarketplace and not not FFlagAppIaScrollAwayPinHeader or nil,
		disableGlobalScrollAwayTouch = FFlagEnableBottomNavOnMarketplace and not not FFlagAppIaScopedScrollAway or nil
	},
	[AppPage.Chat] = {
		nameLocalizationKey = "CommonUI.Features.Label.Chat",
		overridesAppRouterTabBarControl = true,
		appShellReporterFeature = Enum.AppShellFeature.Chat,
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.ContentFeed] = {
		disableBackButton = false,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ShareGameToChat] = if not FFlagShareTargetGameCleanup then {
		tabBarHidden = SystemBarVisibility.PolicyDependent
	} else nil,
	[AppPage.AvatarExperienceWrapper] = {
		overridesAppRouterTabBarControl = true,
		disableBackButton = true,
		appShellReporterFeature = Enum.AppShellFeature.AvatarEditor
	},
	[AppPage.AvatarExperienceWrapperTransparent] = {
		overridesAppRouterTabBarControl = true,
		renderUnderlyingPage = true,
		disableBackButton = true,
		appShellReporterFeature = Enum.AppShellFeature.AvatarEditor
	},
	[AppPage.FeatureTileAdPlayer] = if not FFlagLuaAppEnableFeatureTileAdPlayer then nil else {
		overridesAppRouterTabBarControl = true,
		renderUnderlyingPage = true,
		disableBackButton = true,
		disableAppTopBanner = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.SearchPage] = {
		overridesAppRouterTabBarControl = false,
		tabBarHidden = SystemBarVisibility.Visible,
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.More] = {
		nameLocalizationKey = "CommonUI.Features.Label.More",
		tabBarHidden = SystemBarVisibility.Visible,
		appShellReporterFeature = Enum.AppShellFeature.More,
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.AccountInfo] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.About] = {
		nameLocalizationKey = "CommonUI.Features.Label.About",
		tabBarHidden = SystemBarVisibility.Visible,
		alwaysShowBackButton = not not FFlagFixMoreSubMenuTitleFlash or nil
	},
	[AppPage.SafetySupport] = {
		nameLocalizationKey = "CommonUI.Features.Label.HelpAndSafety",
		tabBarHidden = SystemBarVisibility.Visible,
		alwaysShowBackButton = not not FFlagFixMoreSubMenuTitleFlash or nil
	},
	[AppPage.Settings] = {
		nameLocalizationKey = "CommonUI.Features.Label.Settings",
		tabBarHidden = SystemBarVisibility.Visible,
		alwaysShowBackButton = not not FFlagFixMoreSubMenuTitleFlash or nil
	},
	[AppPage.Accessibility] = {
		nameLocalizationKey = "Feature.Accessibility.Heading.DevicePreferences",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.Licensing] = {
		nameLocalizationKey = "CommonUI.Features.Label.Licensing",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.AppInformation] = {
		nameLocalizationKey = "CommonUI.Features.Label.AppInformation",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.DevSubs] = {
		nameLocalizationKey = "CommonUI.Features.Label.DevSubs",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.AddFriendsPage] = {
		nameLocalizationKey = "Feature.Friends.Feature.Friends.Heading.AddFriends",
		nativeWrapper = false,
		bottomTabBarHidden = true,
		sideTabBarHidden = false,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.MyStats] = if not FFlagAppNavMyStatsTab then nil else {
		nameLocalizationKey = "CommonUI.Features.NavBar.Build",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.ConnectionsHub] = {
		nativeWrapper = false,
		bottomTabBarHidden = true,
		sideTabBarHidden = false,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.BuildersClub] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.InviteLinkExpiredModal] = {
		absorbInput = true,
		renderUnderlyingPage = true
	},
	[AppPage.ShareLinkInvalidModal] = {
		absorbInput = true,
		renderUnderlyingPage = true
	},
	[AppPage.VerifiedBadgeModal] = {
		renderUnderlyingPage = true
	},
	[AppPage.ShareVirtualEventModal] = {
		renderUnderlyingPage = true
	},
	[AppPage.EventNotificationsModal] = {
		renderUnderlyingPage = true
	},
	[AppPage.EventDetails] = {
		renderUnderlyingPage = true,
		tabBarHidden = if not FFlagLuaAppSduiEventDetailsEnabled then SystemBarVisibility.PolicyDependent else nil,
		blurUnderlyingPage = not FFlagLuaAppSduiEventDetailsEnabled or nil
	},
	[AppPage.TencentHelp] = {
		nameLocalizationKey = "CommonUI.Features.Label.Help",
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.TencentNoticeCenter] = {
		nameLocalizationKey = "CommonUI.Features.Label.TencentNotice",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.TencentNoticeContent] = {
		nameLocalizationKey = "CommonUI.Features.Label.TencentNotice",
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.GenericWebPage] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.SettingsSubPage] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.SecurityAlertInfo] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.YouTubePlayer] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.PurchaseRobux] = {
		webView = true,
		nativeWrapper = true,
		tabBarHidden = if not v41 and (not FFlagEnableLeftNavOnConsole or not GuiService:IsTenFootInterface()) then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden,
		renderUnderlyingPage = (not FFlagEnableLeftNavOnConsole or not GuiService:IsTenFootInterface()) and not IsVRAppBuild()
	},
	[AppPage.Payment] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.RobuxUpsell] = {
		webView = false,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.SubscriptionPurchase] = {
		webView = false,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.Notifications] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.LogoutConfirmation] = {
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.AddFriends] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.ViewUserProfile] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.ViewProfile] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.AccountSelectorPeekView] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		isPeekView = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.AccountSwitchingAddAccountPeekView] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		isPeekView = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.LoginNative] = {
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.CaptchaNative] = {
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.ViewFriends] = {
		webView = false,
		nativeWrapper = false,
		renderUnderlyingPage = false,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ShareSheet] = {
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.SdkShare] = {
		nativeWrapper = false,
		renderUnderlyingPage = true,
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ReportAbuse] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.ScanQrCode] = {
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.GenericOpaqueWebPage] = {
		nativeWrapper = true,
		renderUnderlyingPage = false,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ChallengeHybridOverlayPage] = {
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ChallengeHybridWebView] = {
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.ProfilePlatform] = {
		nameLocalizationKey = "CommonUI.Features.Label.Profile",
		renderUnderlyingPage = true,
		isPeekView = true,
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.Groups] = {
		nameLocalizationKey = "CommonUI.Features.Label.Groups",
		disableBackButton = false,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.SocialUnableToJoinExperience] = {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true
	},
	[AppPage.SocialPurchaseExperience] = {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true
	},
	[AppPage.SocialToast] = {
		overlayEnabled = true,
		transparent = true,
		absorbInput = false,
		overlayTransparency = 1,
		renderUnderlyingPage = true,
		disableBackButton = true
	},
	[AppPage.EditSocialNetworks] = if not SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() then nil else {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true
	},
	[AppPage.EditSocialNetworksError] = if not SocialNetworksInEditProfileIXP.GetFFlagSocialNetworksInEditProfileIXPSetupEnabled() then nil else {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true
	},
	[AppPage.PhoneVerification] = {
		renderUnderlyingPage = true,
		webView = not v12 or nil,
		tabBarHidden = if not v41 or v12 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.EditUsername] = {
		renderUnderlyingPage = true,
		webView = not v12 or nil,
		tabBarHidden = if not v41 or v12 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	},
	[AppPage.ExperienceGuidelinesExplained] = {
		nameLocalizationKey = "Feature.GameDetails.Label.ContentMaturity",
		disableBackButton = false,
		renderUnderlyingPage = true
	},
	[AppPage.AgeVerificationRequired] = {
		disableBackButton = false,
		renderUnderlyingPage = true
	},
	[AppPage.AccountSettingsUpsell] = {
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.IDVUpsellContainer] = {
		renderUnderlyingPage = true
	},
	[AppPage.VPCUpsellContainer] = {
		renderUnderlyingPage = true
	},
	[AppPage.RobloxSubscriptionUpsell] = {
		renderUnderlyingPage = true
	},
	[AppPage.AmpWizardContainer] = {
		renderUnderlyingPage = true
	},
	[AppPage.AccountUnlock] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		disableAppTopBanner = true
	},
	[AppPage.GamesList] = {
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.SduiLandingPage] = if not FFlagLuaAppSduiLandingPageEnabled then nil else {
		tabBarHidden = SystemBarVisibility.Visible
	},
	[AppPage.DeeplinkGamesList] = if not FFlagLuaAppSortDeeplinkFix then nil else {
		enableScrollAway = not not FFlagAppIaScrollAway or nil
	},
	[AppPage.ContactImporter] = {
		bottomTabBarHidden = true,
		sideTabBarHidden = true,
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.ContactsList] = {
		bottomTabBarHidden = true,
		sideTabBarHidden = true,
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.UAppBlock] = {
		nameLocalizationKey = "CommonUI.Features.Label.Startup",
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.PassesPage] = {
		nameLocalizationKey = "Feature.GameDetails.Label.Store",
		appShellReporterFeature = Enum.AppShellFeature.GamePage
	},
	[AppPage.SocialMessageToast] = {
		renderUnderlyingPage = true,
		disableBackButton = true
	},
	[AppPage.ProfileQRCodePage] = {
		absorbInput = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ParentVerification] = {
		webView = true,
		tabBarHidden = if not v41 then nil else SystemBarVisibility.Hidden
	},
	[AppPage.EmailVerification] = {
		webView = true,
		tabBarHidden = if not v41 then nil else SystemBarVisibility.Hidden
	},
	[AppPage.AddAuthMethodPage] = {
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.PasskeyUpsellScreen] = if not FFlagPasskeyUpsellEnabled then nil else {
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.PlatformLockedPage] = if not GetFFlagEnablePlatformRestrictedEventReceiver() then nil else {
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.TutorialUpsellScreen] = if not FFlagTutorialUpsellEnabled then nil else {
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.SponsoredTooltipPeekView] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		isPeekView = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.InfoPeekView] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		isPeekView = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.ReportDialog] = {
		disableBackButton = false,
		renderUnderlyingPage = true
	},
	[AppPage.SetNicknameModal] = if not FFlagFriendRequestNicknames then nil else {
		overlayEnabled = true,
		transparent = true,
		absorbInput = true,
		overlayTransparency = 0.5,
		renderUnderlyingPage = true,
		disableBackButton = true,
		bottomTabBarHidden = true,
		tabBarHidden = SystemBarVisibility.Hidden
	},
	[AppPage.VoiceTrialUpsell] = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else {
		renderUnderlyingPage = true,
		absorbInput = true
	},
	[AppPage.GameFilterMenuPeekView] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		isPeekView = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	},
	[AppPage.VideoFullscreen] = if not FFlagAddVideoToCommunityProfile then nil else {
		renderUnderlyingPage = true,
		disableBackButton = false,
		tabBarHidden = SystemBarVisibility.Hidden
	}
}

if GetFFlagLuaAppChallengeDialogContainerPageEnabled() then
	t1[AppPage.ChallengeDialogModalContainer] = {
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	}
end

if GetFFlagEnableAbuseReport10ft() then
	t1[AppPage.ReportScreen] = {
		nameLocalizationKey = "Feature.GameDetails.Label.ReportAbuse",
		renderUnderlyingPage = false,
		tabBarHidden = SystemBarVisibility.Visible
	}
end

if GetFFlagEnableNativeWrapperAppPage() then
	t1[AppPage.ChallengeNativeWrapper] = {
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = SystemBarVisibility.Hidden
	}
end

if GetFFlagFixNavBarStartupDuplicateAnim() then
	t1[AppPage.PlatformAccountRouter] = {
		tabBarHidden = SystemBarVisibility.Hidden
	}
end

t1[AppPage.DiscoverabilityOverlay] = {
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	tabBarHidden = SystemBarVisibility.Hidden
}
t1[AppPage.FindFriendsModal] = {
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	tabBarHidden = SystemBarVisibility.Hidden
}
t1[AppPage.ContactsRevokedAccessDialog] = {
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	tabBarHidden = SystemBarVisibility.Hidden
}
t1[AppPage.SettingsPermissionInteractiveAlert] = {
	bottomTabBarHidden = true,
	sideTabBarHidden = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	tabBarHidden = SystemBarVisibility.Hidden
}
t1[AppPage.TrustedContactsEducationModal] = {
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	tabBarHidden = if not v46 then SystemBarVisibility.Hidden else nil,
	bottomTabBarHidden = not v46 or nil,
	sideTabBarHidden = not v46 or nil
}

if FFlagProfilePlatformAddTC then
	t1[AppPage.TrustedContactsModal] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true,
		overlayTransparency = if not FFlagTCModalUseFoundationOverlay then nil else 1
	}
end

t1[AppPage.TrustedFriendsVPCPrologue] = {
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}
t1[AppPage.FAEUpsell] = {
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true
}
t1[AppPage.FriendsRenameInfoModal] = {
	isPeekView = true,
	renderUnderlyingPage = true,
	disableBackButton = true,
	overlayEnabled = true,
	absorbInput = true,
	tabBarHidden = SystemBarVisibility.PolicyDependent
}

if FFlagTCShareLinkErrorModal then
	t1[AppPage.TrustedFriendsShareLinkErrorModal] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true,
		absorbInput = true
	}
end

if FFlagEnableSocialProofUserList then
	t1[AppPage.FriendsOwnedUserList] = {
		renderUnderlyingPage = true,
		isPeekView = true,
		overlayEnabled = true
	}
end

if FFlagEnableSocialProofVerticalUserListSheet then
	t1[AppPage.SocialProofVerticalUserListSheet] = {
		renderUnderlyingPage = true,
		isPeekView = true,
		overlayEnabled = true
	}
end

if FFlagEnableSchoolEntry then
	t1[AppPage.Schools] = {
		renderUnderlyingPage = true,
		disableBackButton = true,
		overlayEnabled = true
	}
end

t1[AppPage.MutualConnectionList] = {
	renderUnderlyingPage = true,
	isPeekView = true,
	overlayEnabled = true
}

if FFlagEnableSocialTabsPage then
	t1[AppPage.SocialTabsPage] = {
		hasSubNavigation = true,
		nativeWrapper = false,
		renderUnderlyingPage = true,
		bottomTabBarHidden = true,
		overlayEnabled = true,
		overlayTransparency = 0.5,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	}
end

t1[AppPage.BlockingModal] = {
	renderUnderlyingPage = true,
	overlayEnabled = true
}
t1[AppPage.AboutDetailsSheet] = {
	isPeekView = true,
	renderUnderlyingPage = true,
	overlayEnabled = true
}
t1[AppPage.NotApprovedPage] = {
	disableBackButton = true,
	disableAppTopBanner = true,
	tabBarHidden = SystemBarVisibility.Hidden
}

if FFlagEnableLeftNavOnConsole then
	t1[AppPage.AdjustScreen] = {
		tabBarHidden = SystemBarVisibility.Hidden
	}
	t1[AppPage.ExperienceDetail] = {
		tabBarHidden = if not GuiService:IsTenFootInterface() then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	}
end

if FFlagEnableBlackbird then
	t1[AppPage.Blackbird] = {
		webView = true,
		nativeWrapper = true,
		renderUnderlyingPage = true,
		tabBarHidden = if not v41 then SystemBarVisibility.PolicyDependent else SystemBarVisibility.Hidden
	}
end

if FFlagLuaAppEnableStratusStreamingTestOnly then
	t1[AppPage.VideoServer] = {
		nameLocalizationKey = "CommonUI.Features.Label.Nil",
		disableAppTopBanner = true,
		disableBackButton = true,
		tabBarHidden = SystemBarVisibility.Hidden
	}
end

if FFlagEnableMobileGameJoinCard then
	t1[AppPage.GameJoinCard] = {
		isPeekView = true,
		renderUnderlyingPage = true,
		overlayEnabled = true,
		tabBarHidden = SystemBarVisibility.PolicyDependent
	}
end

if FFlagEnableArgus then
	t1[AppPage.Moments] = {
		nameLocalizationKey = "CommonUI.Features.Label.Moments",
		overridesAppRouterTabBarControl = true,
		appShellReporterFeature = Enum.AppShellFeature.WatchPage
	}

	if FFlagMomentsFeedWatchPageAttribution then
		t1[FStringMomentsFeedWatchPageRouteName] = {
			appShellReporterFeature = Enum.AppShellFeature.WatchPage
		}
	end

	if FFlagEnableArgusImmersiveNav then
		t1[AppPage.MomentsImmersive] = {
			nameLocalizationKey = "CommonUI.Features.Label.Moments",
			disableAppTopBanner = true,
			tabBarHidden = SystemBarVisibility.Hidden,
			appShellReporterFeature = Enum.AppShellFeature.WatchPage
		}
	end
end

return t1
