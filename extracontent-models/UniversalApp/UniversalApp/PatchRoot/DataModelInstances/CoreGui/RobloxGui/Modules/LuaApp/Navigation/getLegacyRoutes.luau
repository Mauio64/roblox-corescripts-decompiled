local GuiService = game:GetService("GuiService")
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)

require(CorePackages.Workspace.Packages.Navigation)

local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local createLazyComponent = require(CorePackages.Workspace.Packages.RoactUtils).Components.createLazyComponent
local TenFootUiCommon = require(CorePackages.Workspace.Packages.TenFootUiCommon)
local ScreenKind = TenFootUiCommon.TenFootUiRNTypes.ScreenKind
local GlobalNavDisplayOption = TenFootUiCommon.TenFootUiRNTypes.GlobalNavDisplayOption
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local wrapAppPageForRoactNavigation = require(Modules.LuaApp.Navigation.wrapAppPageForRoactNavigation)
local wrapPageInScreenGui = require(Modules.LuaApp.Navigation.wrapPageInScreenGui)
local FlagSettings = require(Modules.LuaApp.FlagSettings)
local NotificationType = require(Modules.LuaApp.Enum.NotificationType)
local UrlBuilder = require(Modules.LuaApp.Http.UrlBuilder)
local WebViewWindow = require(Modules.LuaApp.Enum.WebViewWindow)
local AppPageProperties = require(Modules.LuaApp.AppPageProperties)
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local FFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local FFlagEnableArgus = SharedFlags.FFlagEnableArgus
local FFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local FFlagMomentsWatchSessionalization = SharedFlags.FFlagMomentsWatchSessionalization
local FFlagEnableAccountUnlockDeepLink = SharedFlags.FFlagEnableAccountUnlockDeepLink
local FFlagReworkPurchaseRobuxPage = require(Modules.LuaApp.Flags.FFlagReworkPurchaseRobuxPage)
local GetFFlagWebViewServiceHasBackButtonVisibility = require(Modules.LuaApp.Flags.GetFFlagWebViewServiceHasBackButtonVisibility)
local FFlagLuaAppEnableStratusStreamingTestOnly = SharedFlags.FFlagLuaAppEnableStratusStreamingTestOnly
local v31 = createLazyComponent(function() -- line: 41
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.VideoServerScreen).VideoServerScreenContainer
end)
local u32 = nil

if FFlagAppNavMyStatsTab then
	u32 = createLazyComponent(function() -- line: 47
		-- upvalues: CorePackages (copy)
		return require(CorePackages.Workspace.Packages.BuildExperience).BuildPage
	end)
end

local t1 = {
	SafetySupportPage = createLazyComponent(function() -- line: 53
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.More.SafetySupportPage)
	end),
	DeviceSettingsPage = createLazyComponent(function() -- line: 56
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.More.DeviceSettings.DeviceSettingsPage)
	end),
	AppInformation = createLazyComponent(function() -- line: 59
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.More.AppInformationPage)
	end),
	DevSubsPage = createLazyComponent(function() -- line: 62
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.More.DevSubsPage)
	end),
	TencentNoticeCenterPage = createLazyComponent(function() -- line: 65
		-- upvalues: Modules (copy)
		return require(Modules.Luobu.Components.More.TencentNoticeCenter.TencentNoticeCenterPage)
	end),
	TencentNoticeContentPage = createLazyComponent(function() -- line: 68
		-- upvalues: Modules (copy)
		return require(Modules.Luobu.Components.More.TencentNoticeCenter.TencentNoticeContentPage)
	end)
}
local t2 = {
	LoginV2MonoWrapper = createLazyComponent(function() -- line: 73
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.Authentication.LoginV2MonoWrapper)
	end),
	AccountRecoveryMonoWrapper = createLazyComponent(function() -- line: 76
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.AccountSecurity.AccountRecoveryMonoWrapper)
	end),
	UAppBlockPage = createLazyComponent(function() -- line: 79
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.Authentication.UAppBlockPage)
	end),
	LandingPage = createLazyComponent(function() -- line: 82
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.Authentication.LandingPage)
	end),
	LuobuLandingPage = createLazyComponent(function() -- line: 85
		-- upvalues: Modules (copy)
		return require(Modules.Luobu.Components.Authentication.LuobuLandingPage)
	end),
	BirthdayPage = createLazyComponent(function() -- line: 88
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.Authentication.BirthdayPage)
	end),
	LuobuSignUpPage = createLazyComponent(function() -- line: 91
		-- upvalues: Modules (copy)
		return require(Modules.Luobu.Components.Authentication.LuobuSignUpPage)
	end),
	AddAuthMethodPage = createLazyComponent(function() -- line: 94
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.Authentication.AddAuthMethodPage)
	end),
	PasskeyUpsellScreen = createLazyComponent(function() -- line: 97
		-- upvalues: CorePackages (copy)
		return require(CorePackages.Workspace.Packages.PasskeyUpsell).Components.PasskeyUpsellScreen
	end),
	PlatformLockedPage = createLazyComponent(function() -- line: 100
		-- upvalues: CorePackages (copy)
		return require(CorePackages.Workspace.Packages.PlatformRestricted).Components.PlatformLockedPage
	end),
	CaptchaPageBrowserServiceWrapper = createLazyComponent(function() -- line: 103
		-- upvalues: Modules (copy)
		return require(Modules.LuaApp.Components.CaptchaPageBrowserServiceWrapper)
	end),
	NotApprovedPage = createLazyComponent(function() -- line: 106
		-- upvalues: CorePackages (copy)
		return require(CorePackages.Workspace.Packages.NotApprovedPage).NotApprovedPageV2
	end)
}
local v35 = createLazyComponent(function() -- line: 110
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.ExperienceDetails.Navigation.ExperienceDetailsSelector)
end)
local v36 = createLazyComponent(function() -- line: 113
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.BlackbirdPageWrapper)
end)
local v37 = createLazyComponent(function() -- line: 116
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Passes.PassesPage)
end)
local v38 = createLazyComponent(function() -- line: 119
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.InviteLinkExpiredModal.api).InviteLinkExpiredModal
end)
local v39 = createLazyComponent(function() -- line: 122
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.ShareLinkInvalidModal.api).ShareLinkInvalidModal
end)
local v40 = createLazyComponent(function() -- line: 125
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.ProfileQRCodePage.api).ProfileQRCodeEntryPoint
end)
local v41 = createLazyComponent(function() -- line: 128
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.SocialMessageToast.api).RootScreen
end)
local v42 = createLazyComponent(function() -- line: 131
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.EditProfile.EditUsernameWrapper)
end)
local v43 = createLazyComponent(function() -- line: 134
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.AccountSelector).AccountSelectorPeekView
end)
local v44 = createLazyComponent(function() -- line: 137
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.AccountSelector).AccountSwitchingAddAccountPeekView
end)
local v45 = createLazyComponent(function() -- line: 140
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.VirtualEvents).ShareEventModal
end)
local v46 = createLazyComponent(function() -- line: 143
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.VerifiedBadges).AboutVerifiedBadgeModal
end)
local v47 = createLazyComponent(function() -- line: 146
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.VirtualEvents.EventDetailsWrapper)
end)
local v48 = createLazyComponent(function() -- line: 149
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.VirtualEvents.EventNotificationsModalWrapper)
end)
local v49 = createLazyComponent(function() -- line: 152
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.YouTubePageWrapper)
end)
local v50 = createLazyComponent(function() -- line: 155
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.GenericWebPageWrapper)
end)
local v51 = createLazyComponent(function() -- line: 158
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.GenericNativePageWrapper)
end)
local v52 = createLazyComponent(function() -- line: 161
	-- upvalues: Modules (copy)
	return require(Modules.ShareTargetGame.Components.ShareTargetGameEntrypoint)
end)
local v53 = createLazyComponent(function() -- line: 164
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Authentication.WeChatLoginWrapper)
end)
local v54 = createLazyComponent(function() -- line: 167
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.NativeViewUserProfileWrapper)
end)
local v55 = createLazyComponent(function() -- line: 170
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.NativeViewProfileWrapper)
end)
local v56 = createLazyComponent(function() -- line: 173
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.NativePageWithUrlWrapper)
end)
local v57 = createLazyComponent(function() -- line: 176
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.NativeReportAbuseWrapper)
end)
local v58 = createLazyComponent(function() -- line: 179
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.NativePurchaseRobuxPageWrapper)
end)
local v59 = createLazyComponent(function() -- line: 182
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.More.AccountInfoPage)
end)
local v60 = createLazyComponent(function() -- line: 185
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.ShareSheetWrapper)
end)
local v61 = createLazyComponent(function() -- line: 188
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.SdkShareWrapper)
end)
local v62 = createLazyComponent(function() -- line: 191
	-- upvalues: Modules (copy)
	return require(Modules.Luobu.Components.More.TencentHelp.TencentHelpWrapper)
end)
local v63 = createLazyComponent(function() -- line: 194
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.TutorialUpsell).Components.TutorialUpsellScreen
end)
local v64 = createLazyComponent(function() -- line: 197
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Authentication.VerificationUpsell.PhoneVerificationNativeWrapper)
end)
local v65 = createLazyComponent(function() -- line: 200
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.SettingsNativeWrapper)
end)
local v66 = createLazyComponent(function() -- line: 203
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.More.ParentVerificationPage)
end)
local v67 = createLazyComponent(function() -- line: 206
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.WebView.AppWebView)
end)
local v68 = createLazyComponent(function() -- line: 209
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Challenge.HybridOverlayPage)
end)
local v69 = createLazyComponent(function() -- line: 212
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Challenge.HybridWebView)
end)
local v70 = createLazyComponent(function() -- line: 215
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.ChallengeDialog).ChallengeDialogModalContainer
end)
local v71 = createLazyComponent(function() -- line: 218
	-- upvalues: Modules (copy)
	return require(Modules.AvatarExperience.Common.Components.RoactNavigation.AppRouterWrapper.AvatarExperienceWrapper)
end)
local v72 = createLazyComponent(function() -- line: 221
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.AmpUpsell).IDVUpsellContainer
end)
local v73 = createLazyComponent(function() -- line: 224
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.AmpUpsell).VPCUpsellContainer
end)
local v74 = createLazyComponent(function() -- line: 227
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.AmpUpsell.RobloxSubscriptionUpsellScreen)
end)
local v75 = createLazyComponent(function() -- line: 230
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.AgeVerification.AgeVerificationModal)
end)
local v76 = createLazyComponent(function() -- line: 233
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.RobuxUpsell.RobuxUpsellContainer)
end)
local v77 = createLazyComponent(function() -- line: 236
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Subscription.Purchase.SubscriptionPurchaseContainer)
end)
local v78 = createLazyComponent(function() -- line: 239
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.BuyRobux.BuyRobuxContainer)
end)
local v79 = createLazyComponent(function() -- line: 242
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.AbuseReporting.ReportContainer)
end)
local v80 = createLazyComponent(function() -- line: 245
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.Games.SponsoredTooltipPeekView)
end)
local v81 = createLazyComponent(function() -- line: 248
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.AppBlox).InfoPeekView
end)
local v82 = createLazyComponent(function() -- line: 251
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.AmpUpsell.AccountSettingsUpsellWrapper)
end)
local v83 = createLazyComponent(function() -- line: 254
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.AmpUpsell.AmpWizardContainerWrapper)
end)
local v84 = createLazyComponent(function() -- line: 257
	-- upvalues: Modules (copy)
	return require(Modules.LuaApp.Components.AccountUnlock.AccountUnlockDeepLinkPageWrapper)
end)
local v85 = createLazyComponent(function() -- line: 260
	-- upvalues: CorePackages (copy)
	return require(CorePackages.Workspace.Packages.PhoneUpsell).VoiceTrialUpsell
end)
local t3 = {
	GetFFlagEnableUnifiedStaticWebViews = require(Modules.LuaApp.Flags.GetFFlagEnableUnifiedStaticWebViews),
	GetFFlagLuaAppUseSettingsNativeWrapper = require(Modules.LuaApp.Flags.GetFFlagLuaAppUseSettingsNativeWrapper),
	GetFFlagLuaAppLuaBuyRobuxPage = require(Modules.LuaApp.Flags.GetFFlagLuaAppLuaBuyRobuxPage),
	GetFFlagEnableAccountSettingsUpsell = require(Modules.LuaApp.Flags.GetFFlagEnableAccountSettingsUpsell),
	GetFFlagEnableAmpUpsellWizard = require(Modules.LuaApp.Flags.GetFFlagEnableAmpUpsellWizard),
	GetFFlagEnableAmpIDVUpsellSupport = require(CorePackages.Workspace.Packages.AmpUpsell).GetFFlagEnableAmpIDVUpsellSupport,
	GetFFlagEnableAmpSubscriptionUpsell = require(CorePackages.Workspace.Packages.AmpUpsell).GetFFlagEnableAmpSubscriptionUpsell,
	GetFFlagLuaAppChallengeDialogContainerPageEnabled = require(CorePackages.Workspace.Packages.ChallengeDialog).GetFFlagLuaAppChallengeDialogContainerPageEnabled,
	GetFFlagEnableTransparentNativeChallengeWrapper = require(Modules.LuaApp.Flags.GetFFlagEnableTransparentNativeChallengeWrapper)
}
local UseGameDetailsPeekView = require(Modules.LuaApp.Flags.UseGameDetailsPeekView)
local FFlagEnableLuaLoginRevamp = SharedFlags.FFlagEnableLuaLoginRevamp
local GetFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow
local GetFFlagEnableVoiceTrialUpsellCard = require(Modules.LuaApp.Flags.GetFFlagEnableVoiceTrialUpsellCard)
local GetFFlagEnableSecurityAlertDeeplink = SharedFlags.GetFFlagEnableSecurityAlertDeeplink
local FFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local GetFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local FFlagTutorialUpsellEnabled = SharedFlags.FFlagTutorialUpsellEnabled
local FFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled

local function getLegacyNavigationOptions(s1: string) -- line: 287
	-- upvalues: AppPageProperties (copy), UseGameDetailsPeekView (copy), AppPage (copy), AvatarScreen (copy)
	local v98 = (AppPageProperties[s1] or {}).renderUnderlyingPage or false
	local v99 = v98

	if UseGameDetailsPeekView() and s1 == AppPage.GameDetail or (s1 == AvatarScreen.ItemDetails or s1 == AppPage.SocialMessageToast or s1 == AppPage.AccountSelectorPeekView or s1 == AppPage.AccountSwitchingAddAccountPeekView or s1 == AppPage.AvatarExperienceWrapperTransparent or s1 == AppPage.SponsoredTooltipPeekView or s1 == AppPage.InfoPeekView) then
		v99 = false
	end

	return {
		transparent = v98,
		overlayEnabled = v99
	}
end

return function(_) -- line: 311
	-- upvalues: AppPage (copy), FFlagLuaAppEnableStratusStreamingTestOnly (copy), Roact (copy), v31 (copy), wrapPageInScreenGui (copy), t2 (copy), FFlagEnableLuaLoginRevamp (copy), GetFFlagEnableLuafiedRecoveryFlow (copy), FFlagAppNavMyStatsTab (copy), u32 (ref), FlagSettings (copy), v53 (copy), v35 (copy), FFlagShareTargetGameCleanup (copy), v52 (copy), t1 (copy), FFlagLuaAppSduiEventDetailsEnabled (copy), v47 (copy), Cryo (copy), v43 (copy), v44 (copy), v45 (copy), v48 (copy), v62 (copy), v50 (copy), t3 (copy), v65 (copy), v56 (copy), NotificationType (copy), v49 (copy), v51 (copy), v71 (copy), v67 (copy), UrlBuilder (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy), FFlagEnableBlackbird (copy), v36 (copy), v58 (copy), WebViewWindow (copy), v54 (copy), v55 (copy), v76 (copy), v77 (copy), v60 (copy), v61 (copy), v57 (copy), v64 (copy), v42 (copy), v68 (copy), v70 (copy), v79 (copy), v75 (copy), v69 (copy), v38 (copy), v39 (copy), v40 (copy), v59 (copy), v66 (copy), v46 (copy), v41 (copy), v37 (copy), v82 (copy), v83 (copy), FFlagEnableAccountUnlockDeepLink (copy), v84 (copy), v72 (copy), v73 (copy), v74 (copy), FFlagPasskeyUpsellEnabled (copy), FFlagTutorialUpsellEnabled (copy), v63 (copy), v80 (copy), v81 (copy), GetFFlagEnableVoiceTrialUpsellCard (copy), v85 (copy), GetFFlagEnableSecurityAlertDeeplink (copy), wrapAppPageForRoactNavigation (copy), getLegacyNavigationOptions (copy), Modules (copy), createLazyComponent (copy), FFlagEnableArgus (copy), FFlagMomentsWatchSessionalization (copy), FFlagEnableArgusImmersiveNav (copy), IsVRAppBuild (copy), GuiService (copy), v78 (copy), FFlagReworkPurchaseRobuxPage (copy), ScreenKind (copy), GlobalNavDisplayOption (copy), CorePackages (copy), GetFFlagEnablePlatformRestrictedEventReceiver (copy)
	local t4 = {}

	for v102, v103 in {
		[AppPage.None] = function() -- line: 313
			return nil
		end,
		[AppPage.VideoServer] = if not FFlagLuaAppEnableStratusStreamingTestOnly then nil else function() -- line: 317
			-- upvalues: Roact (copy), v31 (copy)
			return Roact.createElement(v31)
		end,
		[AppPage.UAppBlock] = function(p2) -- line: 321
			-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			return wrapPageInScreenGui(t2.UAppBlockPage, AppPage.UAppBlock, p2)
		end,
		[AppPage.LoginV2] = function(p3) -- line: 324
			-- upvalues: FFlagEnableLuaLoginRevamp (copy), wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			if FFlagEnableLuaLoginRevamp then
				return wrapPageInScreenGui(t2.LoginV2MonoWrapper, AppPage.Login, p3)
			end

			return nil
		end,
		[AppPage.AccountRecovery] = function(p4) -- line: 330
			-- upvalues: GetFFlagEnableLuafiedRecoveryFlow (copy), wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			if GetFFlagEnableLuafiedRecoveryFlow() then
				return wrapPageInScreenGui(t2.AccountRecoveryMonoWrapper, AppPage.AccountRecovery, p4)
			end

			return nil
		end,
		[AppPage.MyStats] = if not FFlagAppNavMyStatsTab then nil else function(p5, _, p7) -- line: 341
			-- upvalues: wrapPageInScreenGui (copy), u32 (ref), AppPage (copy)
			return wrapPageInScreenGui(u32, AppPage.MyStats, p5, p7)
		end,
		[AppPage.LuobuSignUpPage] = function(p8) -- line: 345
			-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			return wrapPageInScreenGui(t2.LuobuSignUpPage, AppPage.LuobuSignUpPage, p8)
		end,
		[AppPage.WeChatLoginWrapper] = function(p9) -- line: 348
			-- upvalues: FlagSettings (copy), wrapPageInScreenGui (copy), v53 (copy), AppPage (copy)
			if FlagSettings.WeChatLoginEnabled() then
				return wrapPageInScreenGui(v53, AppPage.WeChatLoginWrapper, p9)
			end

			return nil
		end,
		[AppPage.GameDetail] = function(p10) -- line: 354
			-- upvalues: wrapPageInScreenGui (copy), v35 (copy), AppPage (copy)
			return wrapPageInScreenGui(v35, AppPage.GameDetail, p10)
		end,
		[AppPage.ShareGameToChat] = not FFlagShareTargetGameCleanup and function(p11, p12) -- line: 359
			-- upvalues: wrapPageInScreenGui (copy), v52 (copy), AppPage (copy)
			return wrapPageInScreenGui(v52, AppPage.ShareGameToChat, p11, {
				placeId = p12
			})
		end or nil,
		[AppPage.Birthday] = function(p13) -- line: 364
			-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			return wrapPageInScreenGui(t2.BirthdayPage, AppPage.Birthday, p13)
		end,
		[AppPage.SafetySupport] = function(p14) -- line: 367
			-- upvalues: wrapPageInScreenGui (copy), t1 (copy), AppPage (copy)
			return wrapPageInScreenGui(t1.SafetySupportPage, AppPage.SafetySupport, p14)
		end,
		[AppPage.Accessibility] = function(p15) -- line: 370
			-- upvalues: wrapPageInScreenGui (copy), t1 (copy), AppPage (copy)
			return wrapPageInScreenGui(t1.DeviceSettingsPage, AppPage.Accessibility, p15)
		end,
		[AppPage.AppInformation] = function(p16) -- line: 373
			-- upvalues: wrapPageInScreenGui (copy), t1 (copy), AppPage (copy)
			return wrapPageInScreenGui(t1.AppInformation, AppPage.AppInformation, p16)
		end,
		[AppPage.DevSubs] = function(p17, p18) -- line: 376
			-- upvalues: wrapPageInScreenGui (copy), t1 (copy), AppPage (copy)
			local v121 = p18 and {
				selectedGame = p18
			}

			return wrapPageInScreenGui(t1.DevSubsPage, AppPage.DevSubs, p17, v121)
		end,
		[AppPage.EventDetails] = if FFlagLuaAppSduiEventDetailsEnabled then nil else function(p19, p20, p21) -- line: 381
			-- upvalues: wrapPageInScreenGui (copy), v47 (copy), AppPage (copy), Cryo (copy)
			return wrapPageInScreenGui(v47, AppPage.EventDetails, p19, Cryo.Dictionary.join(p21 or {}, {
				virtualEventId = p20
			}))
		end,
		[AppPage.AccountSelectorPeekView] = function(p22, _, p24) -- line: 390
			-- upvalues: wrapPageInScreenGui (copy), v43 (copy), AppPage (copy)
			return wrapPageInScreenGui(v43, AppPage.AccountSelectorPeekView, p22, p24)
		end,
		[AppPage.AccountSwitchingAddAccountPeekView] = function(p25, _, p27) -- line: 398
			-- upvalues: wrapPageInScreenGui (copy), v44 (copy), AppPage (copy)
			return wrapPageInScreenGui(v44, AppPage.AccountSwitchingAddAccountPeekView, p25, p27)
		end,
		[AppPage.ShareVirtualEventModal] = function(p28, _, p30) -- line: 406
			-- upvalues: wrapPageInScreenGui (copy), v45 (copy), AppPage (copy)
			return wrapPageInScreenGui(v45, AppPage.ShareVirtualEventModal, p28, p30)
		end,
		[AppPage.EventNotificationsModal] = function(p31, _, p33) -- line: 409
			-- upvalues: wrapPageInScreenGui (copy), v48 (copy), AppPage (copy)
			return wrapPageInScreenGui(v48, AppPage.EventNotificationsModal, p31, p33)
		end,
		[AppPage.TencentHelp] = function(p34, p35, p36) -- line: 417
			-- upvalues: Roact (copy), v62 (copy)
			return Roact.createElement(v62, {
				navigationProps = p34,
				detail = p35,
				extraProps = p36
			})
		end,
		[AppPage.TencentNoticeCenter] = function(p37) -- line: 424
			-- upvalues: wrapPageInScreenGui (copy), t1 (copy), AppPage (copy)
			return wrapPageInScreenGui(t1.TencentNoticeCenterPage, AppPage.TencentNoticeCenter, p37)
		end,
		[AppPage.TencentNoticeContent] = function(p38, _, p40) -- line: 427
			-- upvalues: wrapPageInScreenGui (copy), t1 (copy), AppPage (copy)
			return wrapPageInScreenGui(t1.TencentNoticeContentPage, AppPage.TencentNoticeContent, p38, p40)
		end,
		[AppPage.GenericWebPage] = function(p41, p42, p43) -- line: 435
			-- upvalues: Roact (copy), v50 (copy)
			return Roact.createElement(v50, {
				isVisible = p41.isVisible,
				DisplayOrder = p41.displayOrder,
				url = p42,
				title = p43.title,
				titleKey = p43.titleKey,
				searchParams = p43.searchParams,
				transitionAnimation = p43 and p43.transitionAnimation or nil,
				onClose = p43 and p43.onClose or nil
			})
		end,
		[AppPage.GenericOpaqueWebPage] = function(p44, p45, p46) -- line: 447
			-- upvalues: Roact (copy), v50 (copy)
			return Roact.createElement(v50, {
				isVisible = p44.isVisible,
				DisplayOrder = p44.displayOrder,
				url = p45,
				title = p46.title,
				titleKey = p46.titleKey,
				searchParams = p46.searchParams,
				transitionAnimation = p46 and p46.transitionAnimation or nil,
				onClose = p46 and p46.onClose or nil
			})
		end,
		[AppPage.SettingsSubPage] = function(p47, p48, p49) -- line: 459
			-- upvalues: t3 (copy), Roact (copy), v65 (copy), v56 (copy), NotificationType (copy)
			if t3.GetFFlagLuaAppUseSettingsNativeWrapper() then
				return Roact.createElement(v65, {
					url = p48,
					titleKey = p49.titleKey,
					windowCloseCallback = p49 and p49.onClose or nil,
					isVisible = p47.isVisible,
					displayOrder = p47.displayOrder
				})
			end

			return Roact.createElement(v56, {
				isVisible = p47.isVisible,
				DisplayOrder = p47.displayOrder,
				notificationType = p49.notificationType or NotificationType.OPEN_SETTINGS_WEBVIEW,
				url = p48,
				title = p49.title,
				titleKey = p49.titleKey,
				searchParams = if not t3.GetFFlagEnableUnifiedStaticWebViews() then nil else p49.searchParams,
				transitionAnimation = p49 and p49.transitionAnimation or nil,
				onClose = p49 and p49.onClose or nil
			})
		end,
		[AppPage.YouTubePlayer] = function(p50, p51, p52) -- line: 482
			-- upvalues: Roact (copy), v49 (copy)
			return Roact.createElement(v49, {
				isVisible = p50.isVisible,
				DisplayOrder = p50.displayOrder,
				url = p51,
				title = p52.title,
				transitionAnimation = p52 and p52.transitionAnimation or nil
			})
		end,
		[AppPage.ScanQrCode] = function(p53, _, p55) -- line: 491
			-- upvalues: Roact (copy), v51 (copy), NotificationType (copy)
			return Roact.createElement(v51, {
				isVisible = p53.isVisible,
				DisplayOrder = p53.displayOrder,
				transitionAnimation = p55 and p55.transitionAnimation or nil,
				notificationType = NotificationType.SCAN_QR_CODE
			})
		end,
		[AppPage.AvatarExperienceWrapper] = function(p56, _, p58) -- line: 499
			-- upvalues: wrapPageInScreenGui (copy), v71 (copy), AppPage (copy)
			return wrapPageInScreenGui(v71, AppPage.AvatarExperienceWrapper, p56, p58)
		end,
		[AppPage.AvatarExperienceWrapperTransparent] = function(p59, _, p61) -- line: 507
			-- upvalues: wrapPageInScreenGui (copy), v71 (copy), AppPage (copy)
			return wrapPageInScreenGui(v71, AppPage.AvatarExperienceWrapperTransparent, p59, p61)
		end,
		[AppPage.BuildersClub] = function(p62, _, p64) -- line: 515
			-- upvalues: t3 (copy), Roact (copy), v67 (copy), UrlBuilder (copy), GetFFlagWebViewServiceHasBackButtonVisibility (copy), v51 (copy), NotificationType (copy)
			if t3.GetFFlagEnableUnifiedStaticWebViews() then
				return Roact.createElement(v67, {
					titleKey = "CommonUI.Features.Label.Premium",
					url = UrlBuilder.fromString("www:premium/membership")(),
					transitionAnimation = p64.transitionAnimation,
					hasBackButton = not GetFFlagWebViewServiceHasBackButtonVisibility() and nil,
					overlayProps = {
						isVisible = p62.isVisible,
						DisplayOrder = p62.displayOrder
					}
				})
			end

			return Roact.createElement(v51, {
				titleTextLocalizationKey = "CommonUI.Features.Label.Premium",
				isVisible = p62.isVisible,
				DisplayOrder = p62.displayOrder,
				notificationType = NotificationType.OPEN_BUILDERS_CLUB,
				transitionAnimation = p64 and p64.transitionAnimation or nil
			})
		end,
		[AppPage.Blackbird] = if not FFlagEnableBlackbird then nil else function(p65, _, p67) -- line: 539
			-- upvalues: Roact (copy), v36 (copy)
			return Roact.createElement(v36, {
				isVisible = p65.isVisible,
				DisplayOrder = p65.displayOrder,
				transitionAnimation = p67.transitionAnimation
			})
		end,
		[AppPage.Payment] = function(p68, p69, p70) -- line: 547
			-- upvalues: Roact (copy), v58 (copy), t3 (copy), UrlBuilder (copy)
			return Roact.createElement(v58, {
				url = if not t3.GetFFlagEnableUnifiedStaticWebViews() or (not p70 or p70.analyticId == nil) then if not t3.GetFFlagEnableUnifiedStaticWebViews() then nil else UrlBuilder.fromString("www:upgrades/paymentmethods?ap={productId}")({
					productId = p69
				}) else UrlBuilder.fromString("www:upgrades/paymentmethods?ap={productId}&analyticId={analyticId}")({
					productId = p69,
					analyticId = p70.analyticId
				}),
				isVisible = p68.isVisible,
				DisplayOrder = p68.displayOrder,
				transitionAnimation = p70 and p70.transitionAnimation or nil
			})
		end,
		[AppPage.Notifications] = function(p71, _, p73) -- line: 566
			-- upvalues: t3 (copy), Roact (copy), v67 (copy), UrlBuilder (copy), WebViewWindow (copy), v51 (copy), NotificationType (copy)
			if t3.GetFFlagEnableUnifiedStaticWebViews() then
				return Roact.createElement(v67, {
					titleKey = "Feature.AccountSettings.Heading.Tab.Notifications",
					url = UrlBuilder.fromString("www:notificationstream/embedded")(),
					windowType = WebViewWindow.Dialog,
					transitionAnimation = p73.transitionAnimation,
					searchParams = p73.searchParams,
					windowCloseCallback = p73.onClose,
					overlayProps = {
						isVisible = p71.isVisible,
						DisplayOrder = p71.displayOrder
					}
				})
			end

			return Roact.createElement(v51, {
				titleTextLocalizationKey = "Feature.AccountSettings.Heading.Tab.Notifications",
				isVisible = p71.isVisible,
				DisplayOrder = p71.displayOrder,
				notificationType = NotificationType.VIEW_NOTIFICATIONS,
				transitionAnimation = p73 and p73.transitionAnimation or nil,
				onClose = p73 and p73.onClose or nil
			})
		end,
		[AppPage.LogoutConfirmation] = function(p74, _, p76) -- line: 592
			-- upvalues: Roact (copy), v51 (copy), NotificationType (copy)
			return Roact.createElement(v51, {
				isVisible = p74.isVisible,
				DisplayOrder = p74.displayOrder,
				notificationType = NotificationType.ACTION_LOG_OUT,
				transitionAnimation = p76 and p76.transitionAnimation or nil
			})
		end,
		[AppPage.AddFriends] = function(p77, _, p79) -- line: 600
			-- upvalues: t3 (copy), Roact (copy), v67 (copy), UrlBuilder (copy), v51 (copy), NotificationType (copy)
			if t3.GetFFlagEnableUnifiedStaticWebViews() then
				return Roact.createElement(v67, {
					titleKey = "CommonUI.Features.Label.Friends",
					url = UrlBuilder.fromString("www:users/friends#!/friend-requests?onlyShowContents=true")(),
					transitionAnimation = p79.transitionAnimation,
					searchParams = {
						searchType = "Players"
					},
					windowCloseCallback = p79.onClose,
					overlayProps = {
						isVisible = p77.isVisible,
						DisplayOrder = p77.displayOrder
					}
				})
			end

			return Roact.createElement(v51, {
				titleTextLocalizationKey = "CommonUI.Features.Label.Friends",
				isVisible = p77.isVisible,
				DisplayOrder = p77.displayOrder,
				notificationType = NotificationType.UNIVERSAL_FRIENDS,
				transitionAnimation = p79 and p79.transitionAnimation or nil,
				onClose = p79 and p79.onClose or nil
			})
		end,
		[AppPage.ViewUserProfile] = function(p80, p81, p82) -- line: 627
			-- upvalues: Roact (copy), v54 (copy)
			return Roact.createElement(v54, {
				isVisible = p80.isVisible,
				DisplayOrder = p80.displayOrder,
				userId = p81,
				onClose = p82 and p82.onClose or nil
			})
		end,
		[AppPage.ViewProfile] = function(p83, p84) -- line: 635
			-- upvalues: Roact (copy), v55 (copy)
			return Roact.createElement(v55, {
				isVisible = p83.isVisible,
				DisplayOrder = p83.displayOrder,
				url = p84
			})
		end,
		[AppPage.LoginNative] = function(p85, _, p87) -- line: 642
			-- upvalues: Roact (copy), v51 (copy), NotificationType (copy)
			return Roact.createElement(v51, {
				isVisible = p85.isVisible,
				DisplayOrder = p85.displayOrder,
				notificationType = NotificationType.ACTION_LOG_IN,
				transitionAnimation = p87 and p87.transitionAnimation or nil
			})
		end,
		[AppPage.CaptchaNative] = function(p88, _, p90) -- line: 650
			-- upvalues: Roact (copy), t2 (copy)
			local v194 = p90.captchaType == "signup"

			if p90.captchaType == "login" or v194 then
				local t5 = {
					webViewVisible = false,
					isVisible = p88.isVisible,
					DisplayOrder = p88.displayOrder,
					captchaType = p90.captchaType,
					cvalueType = p90.cvalueType,
					cvalue = p90.cvalue,
					dxBlob = p90.dxBlob,
					captchaId = p90.captchaId,
					captchaCallback = p90.captchaCallback,
					backNavigationDisabledWhileLoading = p90.backNavigationDisabledWhileLoading,
					transitionAnimation = p90 and p90.transitionAnimation or nil
				}

				return Roact.createElement(t2.CaptchaPageBrowserServiceWrapper, t5)
			end

			return Roact.createElement(t2.CaptchaPageBrowserServiceWrapper, {
				webViewVisible = false,
				isVisible = p88.isVisible,
				DisplayOrder = p88.displayOrder,
				captchaType = p90.captchaType,
				cvalueType = p90.cvalueType,
				cvalue = p90.cvalue,
				captchaCallback = p90.captchaCallback,
				backNavigationDisabledWhileLoading = p90.backNavigationDisabledWhileLoading,
				transitionAnimation = p90 and p90.transitionAnimation or nil
			})
		end,
		[AppPage.RobuxUpsell] = function(p91, _, p93) -- line: 682
			-- upvalues: wrapPageInScreenGui (copy), v76 (copy), AppPage (copy)
			return wrapPageInScreenGui(v76, AppPage.RobuxUpsell, p91, p93)
		end,
		[AppPage.SubscriptionPurchase] = function(p94, _, p96) -- line: 685
			-- upvalues: wrapPageInScreenGui (copy), v77 (copy), AppPage (copy)
			return wrapPageInScreenGui(v77, AppPage.SubscriptionPurchase, p94, p96)
		end,
		[AppPage.ShareSheet] = function(p97, _, p99) -- line: 693
			-- upvalues: Roact (copy), v60 (copy)
			return Roact.createElement(v60, {
				isVisible = p97.isVisible,
				DisplayOrder = p97.displayOrder,
				data = p99
			})
		end,
		[AppPage.SdkShare] = function(p100, _, p102) -- line: 700
			-- upvalues: Roact (copy), v61 (copy)
			return Roact.createElement(v61, {
				isVisible = p100.isVisible,
				DisplayOrder = p100.displayOrder,
				data = p102
			})
		end,
		[AppPage.ReportAbuse] = function(p103, p104, p105) -- line: 707
			-- upvalues: Roact (copy), v57 (copy)
			return Roact.createElement(v57, {
				isVisible = p103.isVisible,
				DisplayOrder = p103.displayOrder,
				url = p104,
				onClose = p105 and p105.onClose or nil
			})
		end,
		[AppPage.PhoneVerification] = function(_, _, p108) -- line: 715
			-- upvalues: Roact (copy), v64 (copy)
			return Roact.createElement(v64, p108)
		end,
		[AppPage.EditUsername] = function(_, _, p111) -- line: 718
			-- upvalues: Roact (copy), v42 (copy)
			return Roact.createElement(v42, p111)
		end,
		[AppPage.ChallengeHybridOverlayPage] = function(p112, _, p114) -- line: 721
			-- upvalues: wrapPageInScreenGui (copy), v68 (copy), AppPage (copy)
			return wrapPageInScreenGui(v68, AppPage.ChallengeHybridOverlayPage, p112, p114)
		end,
		[AppPage.ChallengeDialogModalContainer] = if not t3.GetFFlagLuaAppChallengeDialogContainerPageEnabled() then nil else function(p115, _, p117) -- line: 730
			-- upvalues: wrapPageInScreenGui (copy), v70 (copy), AppPage (copy)
			return wrapPageInScreenGui(v70, AppPage.ChallengeDialogModalContainer, p115, p117)
		end,
		[AppPage.ReportDialog] = function(p118) -- line: 739
			-- upvalues: wrapPageInScreenGui (copy), v79 (copy), AppPage (copy)
			return wrapPageInScreenGui(v79, AppPage.ReportDialog, p118)
		end,
		[AppPage.AgeVerificationRequired] = function(p119, p120) -- line: 742
			-- upvalues: wrapPageInScreenGui (copy), v75 (copy), AppPage (copy)
			local v226 = p120 and {
				universeId = p120
			} or nil

			return wrapPageInScreenGui(v75, AppPage.AgeVerificationRequired, p119, v226)
		end,
		[AppPage.ChallengeHybridWebView] = function(p121, _, p123) -- line: 754
			-- upvalues: Roact (copy), v69 (copy), Cryo (copy)
			return Roact.createElement(v69, Cryo.Dictionary.join(p123, {
				appContainerNavigation = p121
			}))
		end,
		[AppPage.InviteLinkExpiredModal] = function(p124, _, p126) -- line: 762
			-- upvalues: wrapPageInScreenGui (copy), v38 (copy), AppPage (copy)
			return wrapPageInScreenGui(v38, AppPage.InviteLinkExpiredModal, p124, p126)
		end,
		[AppPage.ShareLinkInvalidModal] = function(p127, _, p129) -- line: 770
			-- upvalues: wrapPageInScreenGui (copy), v39 (copy), AppPage (copy)
			return wrapPageInScreenGui(v39, AppPage.ShareLinkInvalidModal, p127, p129)
		end,
		[AppPage.ProfileQRCodePage] = function(p130, _, p132) -- line: 778
			-- upvalues: wrapPageInScreenGui (copy), v40 (copy), AppPage (copy)
			return wrapPageInScreenGui(v40, AppPage.ProfileQRCodePage, p130, p132)
		end,
		[AppPage.AccountInfo] = function(p133, p134, p135) -- line: 781
			-- upvalues: Roact (copy), v59 (copy), Cryo (copy)
			return Roact.createElement(v59, Cryo.Dictionary.join(p135, {
				isVisible = p133.isVisible,
				displayOrder = p133.displayOrder,
				url = p134
			}))
		end,
		[AppPage.ParentVerification] = function(_, p137) -- line: 792
			-- upvalues: Roact (copy), v66 (copy)
			return Roact.createElement(v66, {
				url = p137
			})
		end,
		[AppPage.EmailVerification] = function(_, p139) -- line: 797
			-- upvalues: Roact (copy), v66 (copy)
			return Roact.createElement(v66, {
				url = p139
			})
		end,
		[AppPage.VerifiedBadgeModal] = function(p140, _, p142) -- line: 802
			-- upvalues: wrapPageInScreenGui (copy), v46 (copy), AppPage (copy)
			return wrapPageInScreenGui(v46, AppPage.VerifiedBadgeModal, p140, p142)
		end,
		[AppPage.SocialMessageToast] = function(p143, _, p145) -- line: 805
			-- upvalues: wrapPageInScreenGui (copy), v41 (copy), AppPage (copy)
			return wrapPageInScreenGui(v41, AppPage.SocialMessageToast, p143, p145)
		end,
		[AppPage.PassesPage] = function(p146, p147, p148) -- line: 808
			-- upvalues: Cryo (copy), wrapPageInScreenGui (copy), v37 (copy), AppPage (copy)
			local t6 = {
				universeId = p147
			}

			if p148 then
				t6 = Cryo.Dictionary.join(p148, t6)
			end

			return wrapPageInScreenGui(v37, AppPage.PassesPage, p146, t6)
		end,
		[AppPage.AccountSettingsUpsell] = if not t3.GetFFlagEnableAccountSettingsUpsell() then nil else function(p149, _, p151) -- line: 818
			-- upvalues: wrapPageInScreenGui (copy), v82 (copy), AppPage (copy)
			return wrapPageInScreenGui(v82, AppPage.AccountSettingsUpsell, p149, p151)
		end,
		[AppPage.AmpWizardContainer] = if not t3.GetFFlagEnableAmpUpsellWizard() then nil else function(p152, _, p154) -- line: 828
			-- upvalues: wrapPageInScreenGui (copy), v83 (copy), AppPage (copy)
			return wrapPageInScreenGui(v83, AppPage.AmpWizardContainer, p152, p154)
		end,
		[AppPage.AccountUnlock] = if not FFlagEnableAccountUnlockDeepLink then nil else function(p155, _, p157) -- line: 838
			-- upvalues: wrapPageInScreenGui (copy), v84 (copy), AppPage (copy)
			return wrapPageInScreenGui(v84, AppPage.AccountUnlock, p155, p157)
		end,
		[AppPage.IDVUpsellContainer] = if not t3.GetFFlagEnableAmpIDVUpsellSupport() then nil else function(p158, _, p160) -- line: 848
			-- upvalues: wrapPageInScreenGui (copy), v72 (copy), AppPage (copy)
			return wrapPageInScreenGui(v72, AppPage.IDVUpsellContainer, p158, p160)
		end,
		[AppPage.VPCUpsellContainer] = function(p161, _, p163) -- line: 852
			-- upvalues: wrapPageInScreenGui (copy), v73 (copy), AppPage (copy)
			return wrapPageInScreenGui(v73, AppPage.VPCUpsellContainer, p161, p163)
		end,
		[AppPage.RobloxSubscriptionUpsell] = if not t3.GetFFlagEnableAmpSubscriptionUpsell() then nil else function(p164, _, p166) -- line: 856
			-- upvalues: wrapPageInScreenGui (copy), v74 (copy), AppPage (copy)
			return wrapPageInScreenGui(v74, AppPage.RobloxSubscriptionUpsell, p164, p166)
		end,
		[AppPage.AddAuthMethodPage] = function(p167) -- line: 865
			-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			return wrapPageInScreenGui(t2.AddAuthMethodPage, AppPage.AddAuthMethodPage, p167)
		end,
		[AppPage.PasskeyUpsellScreen] = if not FFlagPasskeyUpsellEnabled then nil else function(p168, _, p170) -- line: 869
			-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
			return wrapPageInScreenGui(t2.PasskeyUpsellScreen, AppPage.PasskeyUpsellScreen, p168, p170)
		end,
		[AppPage.TutorialUpsellScreen] = if not FFlagTutorialUpsellEnabled then nil else function(p171, _, p173) -- line: 879
			-- upvalues: wrapPageInScreenGui (copy), v63 (copy), AppPage (copy)
			return wrapPageInScreenGui(v63, AppPage.TutorialUpsellScreen, p171, p173)
		end,
		[AppPage.SponsoredTooltipPeekView] = function(p174, _, p176) -- line: 888
			-- upvalues: wrapPageInScreenGui (copy), v80 (copy), AppPage (copy)
			return wrapPageInScreenGui(v80, AppPage.SponsoredTooltipPeekView, p174, p176)
		end,
		[AppPage.InfoPeekView] = function(p177, _, p179) -- line: 896
			-- upvalues: wrapPageInScreenGui (copy), v81 (copy), AppPage (copy)
			return wrapPageInScreenGui(v81, AppPage.InfoPeekView, p177, p179)
		end,
		[AppPage.VoiceTrialUpsell] = if not GetFFlagEnableVoiceTrialUpsellCard() then nil else function(p180, _, p182) -- line: 900
			-- upvalues: wrapPageInScreenGui (copy), v85 (copy), AppPage (copy)
			return wrapPageInScreenGui(v85, AppPage.VoiceTrialUpsell, p180, p182)
		end,
		[AppPage.SecurityAlertInfo] = if not GetFFlagEnableSecurityAlertDeeplink() then nil else function(p183, p184, p185) -- line: 905
			-- upvalues: Roact (copy), v56 (copy), NotificationType (copy), t3 (copy)
			return Roact.createElement(v56, {
				titleKey = "Feature.SecurityFeedback.Header.NewLogin",
				isVisible = p183.isVisible,
				DisplayOrder = p183.displayOrder,
				notificationType = NotificationType.OPEN_CUSTOM_WEBVIEW,
				url = p184,
				searchParams = if not t3.GetFFlagEnableUnifiedStaticWebViews() then nil else p185.searchParams,
				transitionAnimation = p185 and p185.transitionAnimation or nil,
				onClose = p185 and p185.onClose or nil
			})
		end
	} do
		table.insert(t4, {
			[v102] = {
				screen = wrapAppPageForRoactNavigation(v103, v102),
				navigationOptions = getLegacyNavigationOptions(v102)
			}
		})
	end

	table.insert(t4, {
		[AppPage.AvatarExperienceRoot] = {
			getScreen = function() -- line: 934
				-- upvalues: Modules (copy)
				return require(Modules.AvatarExperience.Common.Components.RoactNavigation.AvatarExperienceRootContainer)
			end,
			navigationOptions = {
				hasSubNavigation = true
			}
		}
	})
	table.insert(t4, {
		[AppPage.Chat] = createLazyComponent(function() -- line: 944
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.SocialTab.SocialTabUniversalAppWrapper.Container)
		end)
	})

	if FFlagEnableArgus then
		if FFlagMomentsWatchSessionalization then
			table.insert(t4, {
				[AppPage.Moments] = {
					getScreen = function() -- line: 953
						-- upvalues: Modules (copy)
						return require(Modules.LuaApp.Components.Moments.MomentsTabEntryContainer)
					end,
					navigationOptions = {
						hasSubNavigation = true
					}
				}
			})
		else
			table.insert(t4, {
				[AppPage.Moments] = createLazyComponent(function() -- line: 963
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Moments.MomentsTabEntryContainer)
				end)
			})
		end

		if FFlagEnableArgusImmersiveNav then
			table.insert(t4, {
				[AppPage.MomentsImmersive] = createLazyComponent(function() -- line: 970
					-- upvalues: Modules (copy)
					return require(Modules.LuaApp.Components.Moments.MomentsImmersiveRouteContainer)
				end)
			})
		end
	end

	table.insert(t4, {
		[AppPage.PurchaseRobux] = {
			screen = wrapAppPageForRoactNavigation(function(p186, p187, p188) -- line: 979
				-- upvalues: t3 (copy), IsVRAppBuild (copy), GuiService (copy), wrapPageInScreenGui (copy), v78 (copy), AppPage (copy), FFlagReworkPurchaseRobuxPage (copy), UrlBuilder (copy), Roact (copy), v58 (copy)
				if t3.GetFFlagLuaAppLuaBuyRobuxPage() and IsVRAppBuild() or GuiService:IsTenFootInterface() then
					return wrapPageInScreenGui(v78, AppPage.PurchaseRobux, p186, p188)
				end

				local v296 = nil

				if FFlagReworkPurchaseRobuxPage then
					v296 = UrlBuilder.fromString("www:Upgrades/Robux.aspx?analyticId={analyticId|}&product_id={productId|}")(p188)
				end

				return Roact.createElement(v58, {
					url = if not FFlagReworkPurchaseRobuxPage then if not t3.GetFFlagEnableUnifiedStaticWebViews() then if not p187 then nil else UrlBuilder.fromString("www:Upgrades/Robux.aspx?analyticId={analyticId}")({
						analyticId = p187
					}) else UrlBuilder.fromString("www:Upgrades/Robux.aspx")() else v296,
					isVisible = p186.isVisible,
					DisplayOrder = p186.displayOrder,
					transitionAnimation = p188 and p188.transitionAnimation or nil
				})
			end, AppPage.PurchaseRobux),
			navigationOptions = Cryo.Dictionary.join({
				screenKind = ScreenKind.FullScreen,
				globalNavDisplayOption = GlobalNavDisplayOption.HideAll
			}, (getLegacyNavigationOptions(AppPage.PurchaseRobux)))
		}
	})
	table.insert(t4, {
		[AppPage.ReportScreen] = {
			screen = createLazyComponent(function() -- line: 1017
				-- upvalues: CorePackages (copy)
				return require(CorePackages.Workspace.Packages.AbuseReporting).ReportScreen
			end),
			navigationOptions = {
				screenKind = ScreenKind.FullScreen,
				globalNavDisplayOption = GlobalNavDisplayOption.HideAll
			}
		}
	})
	table.insert(t4, {
		[AppPage.ChallengeNativeWrapper] = {
			screen = createLazyComponent(function() -- line: 1029
				-- upvalues: Modules (copy)
				return require(Modules.LuaApp.Components.Challenge.NativeWrapper)
			end),
			navigationOptions = {
				transparent = not not t3.GetFFlagEnableTransparentNativeChallengeWrapper() or nil,
				globalNavDisplayOption = GlobalNavDisplayOption.OptionGroupOnly
			}
		}
	})
	table.insert(t4, {
		[AppPage.FAEUpsell] = {
			screen = createLazyComponent(function() -- line: 1041
				-- upvalues: CorePackages (copy)
				return require(CorePackages.Workspace.Packages.AmpUpsell).FAEUpsellContainer
			end),
			navigationOptions = getLegacyNavigationOptions(AppPage.FAEUpsell)
		}
	})
	table.insert(t4, {
		[AppPage.NotApprovedPage] = {
			screen = wrapAppPageForRoactNavigation(function(p189, _, p191) -- line: 1051
				-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
				return wrapPageInScreenGui(t2.NotApprovedPage, AppPage.NotApprovedPage, p189, p191)
			end, AppPage.NotApprovedPage),
			navigationOptions = {
				screenKind = ScreenKind.FullScreen,
				globalNavDisplayOption = GlobalNavDisplayOption.HideAll
			}
		}
	})

	if GetFFlagEnablePlatformRestrictedEventReceiver() then
		table.insert(t4, {
			[AppPage.PlatformLockedPage] = {
				screen = wrapAppPageForRoactNavigation(function(p192, _, p194) -- line: 1073
					-- upvalues: wrapPageInScreenGui (copy), t2 (copy), AppPage (copy)
					return wrapPageInScreenGui(t2.PlatformLockedPage, AppPage.PlatformLockedPage, p192, p194)
				end, AppPage.PlatformLockedPage),
				navigationOptions = {
					screenKind = ScreenKind.FullScreen,
					globalNavDisplayOption = GlobalNavDisplayOption.HideAll
				}
			}
		})
	end

	return t4
end
