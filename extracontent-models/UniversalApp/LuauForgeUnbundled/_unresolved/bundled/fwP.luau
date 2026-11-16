local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Cryo = require(CorePackages.Packages.Cryo)
require("@game/CorePackages/Workspace/Packages/Navigation")
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface
local createLazyComponent = require("@game/CorePackages/Workspace/Packages/RoactUtils").Components.createLazyComponent

local module = require("@luauforge/bundled/fwQ")
local module2 = require("@luauforge/bundled/fxb")
local module3 = require("@luauforge/bundled/dCo")
local module4 = require("@luauforge/bundled/fot")
local module5 = require("@luauforge/bundled/fsq")
local module6 = require("@luauforge/bundled/fus")
local module7 = require("@luauforge/bundled/dDE")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagShareTargetGameCleanup = SharedFlags.FFlagShareTargetGameCleanup
local fFlagEnableBlackbird = SharedFlags.FFlagEnableBlackbird
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagEnableArgus = SharedFlags.FFlagEnableArgus
local fFlagEnableArgusImmersiveNav = SharedFlags.FFlagEnableArgusImmersiveNav
local fFlagEnableAccountUnlockDeepLink = SharedFlags.FFlagEnableAccountUnlockDeepLink
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagEnableLoginV2Modalization = SharedFlags.FFlagEnableLoginV2Modalization
local fFlagLuaAppEnableHomepageOneByTwoTile = SharedFlags.FFlagLuaAppEnableHomepageOneByTwoTile
local module9 = require("@luauforge/bundled/fxc")
local fFlagEnableBuyRobuxNewRouting = SharedFlags.FFlagEnableBuyRobuxNewRouting

local module10 = require("@luauforge/bundled/fui")

local fFlagLuaAppEnableStratusStreamingTestOnly = SharedFlags.FFlagLuaAppEnableStratusStreamingTestOnly
local fFlagLuaAppCloudClientPlayButtonOffer = SharedFlags.FFlagLuaAppCloudClientPlayButtonOffer
local fFlagEnablePlusReferralDashboard = SharedFlags.FFlagEnablePlusReferralDashboard

local lazyComponent = createLazyComponent(function()
	return require("@luauforge/deferred/fxd").VideoServerScreenContainer
end)

local v5 = {
	["SafetySupportPage"] = createLazyComponent(function()
		return require("@luauforge/deferred/fxZ")
	end),
	DeviceSettingsPage = createLazyComponent(function()
		return require("@luauforge/deferred/fyu")
	end),
	AppInformation = createLazyComponent(function()
		return require("@luauforge/deferred/fAh")
	end),
	DevSubsPage = createLazyComponent(function()
		return require("@luauforge/deferred/fAi")
	end),
	TencentNoticeCenterPage = createLazyComponent(function()
		return require("@luauforge/deferred/fAw")
	end),
	TencentNoticeContentPage = createLazyComponent(function()
		return require("@luauforge/deferred/fAF")
	end)
}

local v6 = {
	["LoginV2MonoWrapper"] = createLazyComponent(function()
		return require("@luauforge/bundled/fAG")
	end),
	AccountRecoveryMonoWrapper = createLazyComponent(function()
		return require("@luauforge/bundled/fIX")
	end),
	UAppBlockPage = createLazyComponent(function()
		return require("@luauforge/bundled/fMB")
	end),
	LandingPage = createLazyComponent(function()
		return require("@luauforge/bundled/fMF")
	end),
	PioneerPostAuthPage = createLazyComponent(function()
		return require("@luauforge/bundled/fTu")
	end),
	LuobuLandingPage = createLazyComponent(function()
		return require("@luauforge/bundled/fNB")
	end),
	BirthdayPage = createLazyComponent(function()
		return require("@luauforge/deferred/fTG")
	end),
	LuobuSignUpPage = createLazyComponent(function()
		return require("@luauforge/bundled/fTN")
	end),
	AddAuthMethodPage = createLazyComponent(function()
		return require("@luauforge/deferred/fUa")
	end),
	PasskeyUpsellScreen = createLazyComponent(function()
		return require("@luauforge/deferred/fUm").Components.PasskeyUpsellScreen
	end),
	PlatformLockedPage = createLazyComponent(function()
		return require("@luauforge/deferred/fUn").Components.PlatformLockedPage
	end),
	BirthdayCompliancePage = createLazyComponent(function()
		return require("@luauforge/bundled/fRq").Components.BirthdayCompliancePage
	end),
	CaptchaPageBrowserServiceWrapper = createLazyComponent(function()
		return require("@luauforge/deferred/fUH")
	end),
	NotApprovedPage = createLazyComponent(function()
		return require("@luauforge/deferred/fUK").NotApprovedPageV2
	end)
}

local lazyComponent2 = createLazyComponent(function()
	return require("@luauforge/deferred/fWD")
end)

local lazyComponent3 = createLazyComponent(function()
	return require("@luauforge/deferred/gaG")
end)

local lazyComponent4 = createLazyComponent(function()
	return require("@luauforge/deferred/gaI")
end)

local lazyComponent5 = createLazyComponent(function()
	return require("@luauforge/bundled/gaU").InviteLinkExpiredModal
end)

local lazyComponent6 = createLazyComponent(function()
	return require("@luauforge/deferred/gbp").ShareLinkInvalidModal
end)

local lazyComponent7 = createLazyComponent(function()
	return require("@luauforge/bundled/eeE").ProfileQRCodeEntryPoint
end)

local lazyComponent8 = createLazyComponent(function()
	return require("@luauforge/deferred/gbE").RootScreen
end)

local lazyComponent9 = createLazyComponent(function()
	return require("@luauforge/deferred/gbX")
end)

local lazyComponent10 = createLazyComponent(function()
	return require("@luauforge/bundled/fPl").AccountSelectorPeekView
end)

local lazyComponent11 = createLazyComponent(function()
	return require("@luauforge/bundled/fPl").AccountSwitchingAddAccountPeekView
end)

local lazyComponent12 = createLazyComponent(function()
	return require("@luauforge/deferred/fYS").ShareEventModal
end)

local lazyComponent13 = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/_Workspace/ItemDetails/VerifiedBadges").AboutVerifiedBadgeModal
end)

local lazyComponent14 = createLazyComponent(function()
	return require("@luauforge/deferred/gbY")
end)

local lazyComponent15 = createLazyComponent(function()
	return require("@luauforge/deferred/gbZ")
end)

local lazyComponent16 = createLazyComponent(function()
	return require("@luauforge/deferred/gca")
end)

local lazyComponent17 = createLazyComponent(function()
	return require("@luauforge/deferred/gaH")
end)

local lazyComponent18 = createLazyComponent(function()
	return require("@luauforge/deferred/gcb")
end)

local lazyComponent19 = createLazyComponent(function()
	return require("@luauforge/deferred/gcc")
end)

local lazyComponent20 = createLazyComponent(function()
	return require("@luauforge/deferred/gdq")
end)

local lazyComponent21 = createLazyComponent(function()
	return require("@luauforge/deferred/gdu")
end)

local lazyComponent22 = createLazyComponent(function()
	return require("@luauforge/deferred/gdv")
end)

local lazyComponent23 = createLazyComponent(function()
	return require("@luauforge/deferred/gdw")
end)

local lazyComponent24 = createLazyComponent(function()
	return require("@luauforge/deferred/gdx")
end)

local lazyComponent25 = createLazyComponent(function()
	return require("@luauforge/deferred/gdy")
end)

local lazyComponent26 = createLazyComponent(function()
	return require("@luauforge/deferred/gdP")
end)

local lazyComponent27 = createLazyComponent(function()
	return require("@luauforge/deferred/gdV")
end)

local lazyComponent28 = createLazyComponent(function()
	return require("@luauforge/deferred/gdW")
end)

local lazyComponent29 = createLazyComponent(function()
	return require("@luauforge/deferred/geh")
end)

local lazyComponent30 = createLazyComponent(function()
	return require("@luauforge/deferred/gei").Components.TutorialUpsellScreen
end)

local lazyComponent31 = createLazyComponent(function()
	return require("@luauforge/deferred/gev")
end)

local lazyComponent32 = createLazyComponent(function()
	return require("@luauforge/deferred/gdS")
end)

local lazyComponent33 = createLazyComponent(function()
	return require("@luauforge/deferred/gew")
end)

local lazyComponent34 = createLazyComponent(function()
	return require("@luauforge/deferred/fuc")
end)

local lazyComponent35 = createLazyComponent(function()
	return require("@luauforge/deferred/gez")
end)

local lazyComponent36 = createLazyComponent(function()
	return require("@luauforge/deferred/geA")
end)

local lazyComponent37 = createLazyComponent(function()
	return require("@luauforge/bundled/dFS").ChallengeDialogModalContainer
end)

local lazyComponent38 = createLazyComponent(function()
	return require("@luauforge/deferred/geK")
end)

local lazyComponent39 = createLazyComponent(function()
	return require("@luauforge/bundled/eeI").IDVUpsellContainer
end)

local lazyComponent40 = createLazyComponent(function()
	return require("@luauforge/bundled/eeI").VPCUpsellContainer
end)

local lazyComponent41 = createLazyComponent(function()
	return require("@luauforge/deferred/gqT")
end)

local lazyComponent42 = createLazyComponent(function()
	return require("@luauforge/deferred/gqV")
end)

local lazyComponent43 = createLazyComponent(function()
	return require("@luauforge/deferred/gqW")
end)

local lazyComponent44 = createLazyComponent(function()
	return require("@luauforge/bundled/grd").PlusReferralDashboardContainer
end)

local lazyComponent45 = createLazyComponent(function()
	return require("@luauforge/deferred/gur")
end)

local lazyComponent46 = createLazyComponent(function()
	return require("@luauforge/deferred/guS")
end)

local lazyComponent47 = createLazyComponent(function()
	return require("@luauforge/deferred/guT")
end)

local lazyComponent48 = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").InfoPeekView
end)

local lazyComponent49 = createLazyComponent(function()
	return require("@luauforge/deferred/guU")
end)

local lazyComponent50 = createLazyComponent(function()
	return require("@luauforge/deferred/guV")
end)

local lazyComponent51 = createLazyComponent(function()
	return require("@luauforge/deferred/gwO")
end)

local lazyComponent52 = createLazyComponent(function()
	return require("@luauforge/deferred/gxy").VoiceTrialUpsell
end)

local v7 = {
	GetFFlagEnableUnifiedStaticWebViews = require("@luauforge/bundled/fQI"),
	GetFFlagLuaAppUseSettingsNativeWrapper = require("@luauforge/bundled/gdU"),
	GetFFlagLuaAppLuaBuyRobuxPage = require("@luauforge/bundled/gdG"),
	GetFFlagEnableAccountSettingsUpsell = require("@luauforge/bundled/gze"),
	GetFFlagEnableAmpUpsellWizard = require("@luauforge/bundled/gzf"),
	GetFFlagEnableAmpIDVUpsellSupport = require("@luauforge/bundled/eeI").GetFFlagEnableAmpIDVUpsellSupport,
	GetFFlagEnableAmpSubscriptionUpsell = require("@luauforge/bundled/eeI").GetFFlagEnableAmpSubscriptionUpsell,
	GetFFlagLuaAppChallengeDialogContainerPageEnabled = require("@luauforge/bundled/dFS").GetFFlagLuaAppChallengeDialogContainerPageEnabled,
	GetFFlagEnableTransparentNativeChallengeWrapper = require("@luauforge/bundled/gzg")
}

local module11 = require("@luauforge/bundled/fsG")
local getFFlagEnableLuafiedRecoveryFlow = SharedFlags.GetFFlagEnableLuafiedRecoveryFlow
local module12 = require("@luauforge/bundled/dHl")
local getFFlagEnableSecurityAlertDeeplink = SharedFlags.GetFFlagEnableSecurityAlertDeeplink
local fFlagPasskeyUpsellEnabled = SharedFlags.FFlagPasskeyUpsellEnabled
local fFlagEnablePioneerPostAuthGameJoin = SharedFlags.FFlagEnablePioneerPostAuthGameJoin
local getFFlagEnablePlatformRestrictedEventReceiver = SharedFlags.GetFFlagEnablePlatformRestrictedEventReceiver
local fFlagLuaAppBirthdayComplianceGate = SharedFlags.FFlagLuaAppBirthdayComplianceGate
local fFlagTutorialUpsellEnabled = SharedFlags.FFlagTutorialUpsellEnabled
local fFlagLuaAppSduiEventDetailsEnabled = SharedFlags.FFlagLuaAppSduiEventDetailsEnabled

local function getLegacyNavigationOptions(p2)
	local v8 = module7[p2] or {}

	local renderUnderlyingPage = v8.renderUnderlyingPage or false
	local v9

	if module11() and p2 == appPage.GameDetail then
		v9 = false
	elseif
		p2 == avatarScreen.ItemDetails
		or p2 == appPage.SocialMessageToast
		or p2 == appPage.AccountSelectorPeekView
		or p2 == appPage.AccountSwitchingAddAccountPeekView
		or p2 == appPage.AvatarExperienceWrapperTransparent
		or p2 == appPage.SponsoredTooltipPeekView
		or p2 == appPage.InfoPeekView
		or fFlagEnableLoginV2Modalization and p2 == appPage.LoginV2
	then
		v9 = false
	else
		v9 = renderUnderlyingPage
	end

	local v10 = if fFlagEnableSplitPane then v8.splitPaneEligibility else nil

	return {
		transparent = renderUnderlyingPage,
		overlayEnabled = v9,
		splitPaneEligibility = v10
	}
end

return function(p2)
	local result = {}

	for k, v9 in {
		[appPage.None] = function(): nil
			return nil
		end,
		[appPage.VideoServer] = (fFlagLuaAppEnableStratusStreamingTestOnly or fFlagLuaAppCloudClientPlayButtonOffer) and function()
			return Roact.createElement(lazyComponent)
		end or nil,
		[appPage.UAppBlock] = function(p3)
			return module2(v6.UAppBlockPage, appPage.UAppBlock, p3)
		end,
		[appPage.LoginV2] = function(p3)
			local v9 = fFlagEnableLoginV2Modalization and { isVisible = p3.isVisible } or nil
			return module2(v6.LoginV2MonoWrapper, appPage.Login, p3, v9)
		end,
		[appPage.AccountRecovery] = function(p3)
			if getFFlagEnableLuafiedRecoveryFlow() then
				return module2(v6.AccountRecoveryMonoWrapper, appPage.AccountRecovery, p3)
			end

			return nil
		end,
		[appPage.LuobuSignUpPage] = function(p3)
			return module2(v6.LuobuSignUpPage, appPage.LuobuSignUpPage, p3)
		end,
		[appPage.WeChatLoginWrapper] = function(p3)
			if module3.WeChatLoginEnabled() then
				return module2(lazyComponent20, appPage.WeChatLoginWrapper, p3)
			end

			return nil
		end,
		[appPage.GameDetail] = function(p3)
			return module2(lazyComponent2, appPage.GameDetail, p3)
		end,
		[appPage.ShareGameToChat] = not fFlagShareTargetGameCleanup and function(p3, p4)
			return module2(lazyComponent19, appPage.ShareGameToChat, p3, {
				placeId = p4
			})
		end or nil,
		[appPage.Birthday] = function(p3)
			return module2(v6.BirthdayPage, appPage.Birthday, p3)
		end,
		[appPage.SafetySupport] = function(p3)
			return module2(v5.SafetySupportPage, appPage.SafetySupport, p3)
		end,
		[appPage.Accessibility] = function(p3)
			return module2(v5.DeviceSettingsPage, appPage.Accessibility, p3)
		end,
		[appPage.AppInformation] = function(p3)
			return module2(v5.AppInformation, appPage.AppInformation, p3)
		end,
		[appPage.DevSubs] = function(p3, p4)
			return module2(v5.DevSubsPage, appPage.DevSubs, p3, p4 and {
				selectedGame = p4
			})
		end,
		[appPage.EventDetails] = not fFlagLuaAppSduiEventDetailsEnabled and function(p3, p4, options)
			return module2(
				lazyComponent14,
				appPage.EventDetails,
				p3,
				Cryo.Dictionary.join(options or {}, { virtualEventId = p4 })
			)
		end or nil,
		[appPage.AccountSelectorPeekView] = function(p3, p4, p5)
			return module2(lazyComponent10, appPage.AccountSelectorPeekView, p3, p5)
		end,
		[appPage.AccountSwitchingAddAccountPeekView] = function(p3, p4, p5)
			return module2(lazyComponent11, appPage.AccountSwitchingAddAccountPeekView, p3, p5)
		end,
		[appPage.ShareVirtualEventModal] = function(p3, p4, p5)
			return module2(lazyComponent12, appPage.ShareVirtualEventModal, p3, p5)
		end,
		[appPage.EventNotificationsModal] = function(p3, p4, p5)
			return module2(lazyComponent15, appPage.EventNotificationsModal, p3, p5)
		end,
		[appPage.TencentHelp] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent29, {
				navigationProps = p3,
				detail = p4,
				extraProps = p5
			})
		end,
		[appPage.TencentNoticeCenter] = function(p3)
			return module2(v5.TencentNoticeCenterPage, appPage.TencentNoticeCenter, p3)
		end,
		[appPage.TencentNoticeContent] = function(p3, p4, p5)
			return module2(v5.TencentNoticeContentPage, appPage.TencentNoticeContent, p3, p5)
		end,
		[appPage.GenericWebPage] = function(p3, p4, props)
			local createElement = Roact.createElement
			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				url = p4,
				title = props.title,
				titleKey = props.titleKey,
				showDomainAsTitle = 0,
				searchParams = 0,
				transitionAnimation = 0,
				onClose = 0
			}
			local v11 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.showDomainAsTitle else nil
			v10.showDomainAsTitle = v11
			v10.searchParams = props.searchParams
			local v12 = if props then props.transitionAnimation or nil else nil
			v10.transitionAnimation = v12
			v10.onClose = props and props.onClose or nil
			return createElement(lazyComponent17, v10)
		end,
		[appPage.GenericOpaqueWebPage] = function(p3, p4, props)
			local createElement = Roact.createElement
			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				url = p4,
				title = props.title,
				titleKey = props.titleKey,
				showDomainAsTitle = 0,
				searchParams = 0,
				transitionAnimation = 0,
				onClose = 0
			}
			local v11 = if fFlagLuaAppEnableHomepageOneByTwoTile then props.showDomainAsTitle else nil
			v10.showDomainAsTitle = v11
			v10.searchParams = props.searchParams
			local v12 = if props then props.transitionAnimation or nil else nil
			v10.transitionAnimation = v12
			v10.onClose = props and props.onClose or nil
			return createElement(lazyComponent17, v10)
		end,
		[appPage.SettingsSubPage] = function(p3, p4, props)
			if v7.GetFFlagLuaAppUseSettingsNativeWrapper() then
				return Roact.createElement(lazyComponent32, {
					url = p4,
					titleKey = props.titleKey,
					windowCloseCallback = props and props.onClose or nil,
					isVisible = p3.isVisible,
					displayOrder = p3.displayOrder
				})
			end

			local createElement = Roact.createElement
			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				notificationType = props.notificationType or module4.OPEN_SETTINGS_WEBVIEW,
				url = p4,
				title = props.title,
				titleKey = props.titleKey,
				searchParams = 0,
				transitionAnimation = 0,
				onClose = 0
			}
			local v11 = if v7.GetFFlagEnableUnifiedStaticWebViews() then props.searchParams else nil
			v10.searchParams = v11
			local v12 = if props then props.transitionAnimation or nil else nil
			v10.transitionAnimation = v12
			v10.onClose = props and props.onClose or nil
			return createElement(lazyComponent23, v10)
		end,
		[appPage.YouTubePlayer] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent16, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				url = p4,
				title = p5.title,
				transitionAnimation = p5 and p5.transitionAnimation or nil
			})
		end,
		[appPage.ScanQrCode] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent18, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				transitionAnimation = p5 and p5.transitionAnimation or nil,
				notificationType = module4.SCAN_QR_CODE
			})
		end,
		[appPage.AvatarExperienceWrapper] = function(p3, p4, p5)
			return module2(lazyComponent38, appPage.AvatarExperienceWrapper, p3, p5)
		end,
		[appPage.AvatarExperienceWrapperTransparent] = function(p3, p4, p5)
			return module2(lazyComponent38, appPage.AvatarExperienceWrapperTransparent, p3, p5)
		end,
		[appPage.BuildersClub] = function(p3, p4, p5)
			if not v7.GetFFlagEnableUnifiedStaticWebViews() then
				return Roact.createElement(lazyComponent18, {
					isVisible = p3.isVisible,
					DisplayOrder = p3.displayOrder,
					notificationType = module4.OPEN_BUILDERS_CLUB,
					titleTextLocalizationKey = "CommonUI.Features.Label.Premium",
					transitionAnimation = p5 and p5.transitionAnimation or nil
				})
			end

			local createElement = Roact.createElement
			local v10 = {
				url = module5.fromString("www:premium/membership")(),
				titleKey = "CommonUI.Features.Label.Premium",
				transitionAnimation = p5.transitionAnimation,
				hasBackButton = 0,
				overlayProps = 0
			}
			local v11 = if module10() then false else nil
			v10.hasBackButton = v11
			v10.overlayProps = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder
			}
			return createElement(lazyComponent34, v10)
		end,
		[appPage.Blackbird] = fFlagEnableBlackbird and function(p3, p4, p5)
			return Roact.createElement(lazyComponent3, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				transitionAnimation = p5.transitionAnimation
			})
		end or nil,
		[appPage.Payment] = function(p3, p4, p5)
			local createElement = Roact.createElement
			local v11

			if v7.GetFFlagEnableUnifiedStaticWebViews() and p5 and p5.analyticId ~= nil then
				v11 = module5.fromString("www:upgrades/paymentmethods?ap={productId}&analyticId={analyticId}")({
					productId = p4,
					analyticId = p5.analyticId
				})
			elseif v7.GetFFlagEnableUnifiedStaticWebViews() then
				v11 = module5.fromString("www:upgrades/paymentmethods?ap={productId}")({
					productId = p4
				})
			end

			return createElement(lazyComponent25, {
				url = v11,
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				transitionAnimation = p5 and p5.transitionAnimation or nil
			})
		end,
		[appPage.Notifications] = function(p3, p4, props)
			if v7.GetFFlagEnableUnifiedStaticWebViews() then
				return Roact.createElement(lazyComponent34, {
					url = module5.fromString("www:notificationstream/embedded")(),
					titleKey = "Feature.AccountSettings.Heading.Tab.Notifications",
					windowType = module6.Dialog,
					transitionAnimation = props.transitionAnimation,
					searchParams = props.searchParams,
					windowCloseCallback = props.onClose,
					overlayProps = {
						isVisible = p3.isVisible,
						DisplayOrder = p3.displayOrder
					}
				})
			end

			local createElement = Roact.createElement
			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				notificationType = module4.VIEW_NOTIFICATIONS,
				transitionAnimation = 0,
				titleTextLocalizationKey = "Feature.AccountSettings.Heading.Tab.Notifications",
				onClose = 0
			}
			local v11 = if props then props.transitionAnimation or nil else nil
			v10.transitionAnimation = v11

			v10.onClose = props and props.onClose or nil
			return createElement(lazyComponent18, v10)
		end,
		[appPage.LogoutConfirmation] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent18, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				notificationType = module4.ACTION_LOG_OUT,
				transitionAnimation = p5 and p5.transitionAnimation or nil
			})
		end,
		[appPage.AddFriends] = function(p3, p4, p5)
			if v7.GetFFlagEnableUnifiedStaticWebViews() then
				return Roact.createElement(lazyComponent34, {
					url = module5.fromString("www:users/friends#!/friend-requests?onlyShowContents=true")(),
					titleKey = "CommonUI.Features.Label.Friends",
					transitionAnimation = p5.transitionAnimation,
					searchParams = { searchType = "Players" },
					windowCloseCallback = p5.onClose,
					overlayProps = {
						isVisible = p3.isVisible,
						DisplayOrder = p3.displayOrder
					}
				})
			end

			local createElement = Roact.createElement
			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				notificationType = module4.UNIVERSAL_FRIENDS,
				transitionAnimation = 0,
				titleTextLocalizationKey = "CommonUI.Features.Label.Friends",
				onClose = 0
			}
			local v11 = if p5 then p5.transitionAnimation or nil else nil
			v10.transitionAnimation = v11

			v10.onClose = p5 and p5.onClose or nil
			return createElement(lazyComponent18, v10)
		end,
		[appPage.ViewUserProfile] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent21, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				userId = p4,
				onClose = p5 and p5.onClose or nil
			})
		end,
		[appPage.ViewProfile] = function(p3, p4)
			return Roact.createElement(lazyComponent22, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				url = p4
			})
		end,
		[appPage.LoginNative] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent18, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				notificationType = module4.ACTION_LOG_IN,
				transitionAnimation = p5 and p5.transitionAnimation or nil
			})
		end,
		[appPage.CaptchaNative] = function(p3, p4, props)
			local v9 = props.captchaType == "signup"

			if props.captchaType ~= "login" and not v9 then
				return Roact.createElement(v6.CaptchaPageBrowserServiceWrapper, {
					isVisible = p3.isVisible,
					DisplayOrder = p3.displayOrder,
					captchaType = props.captchaType,
					cvalueType = props.cvalueType,
					cvalue = props.cvalue,
					captchaCallback = props.captchaCallback,
					backNavigationDisabledWhileLoading = props.backNavigationDisabledWhileLoading,
					transitionAnimation = props and props.transitionAnimation or nil,
					webViewVisible = false
				})
			end

			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				captchaType = props.captchaType,
				cvalueType = props.cvalueType,
				cvalue = props.cvalue,
				dxBlob = props.dxBlob,
				captchaId = props.captchaId,
				captchaCallback = props.captchaCallback,
				backNavigationDisabledWhileLoading = props.backNavigationDisabledWhileLoading,
				transitionAnimation = props and props.transitionAnimation or nil,
				webViewVisible = false
			}

			return Roact.createElement(v6.CaptchaPageBrowserServiceWrapper, v10)
		end,
		[appPage.SubscriptionPurchase] = function(p3, p4, p5)
			return module2(lazyComponent43, appPage.SubscriptionPurchase, p3, p5)
		end,
		[appPage.ShareSheet] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent27, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				data = p5
			})
		end,
		[appPage.SdkShare] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent28, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				data = p5
			})
		end,
		[appPage.ReportAbuse] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent24, {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				url = p4,
				onClose = p5 and p5.onClose or nil
			})
		end,
		[appPage.PhoneVerification] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent31, p5)
		end,
		[appPage.EditUsername] = function(p3, p4, p5)
			return Roact.createElement(lazyComponent9, p5)
		end,
		[appPage.ChallengeHybridOverlayPage] = function(p3, p4, p5)
			return module2(lazyComponent35, appPage.ChallengeHybridOverlayPage, p3, p5)
		end,
		[appPage.ChallengeDialogModalContainer] = v7.GetFFlagLuaAppChallengeDialogContainerPageEnabled() and function(p3, p4, p5)
			return module2(lazyComponent37, appPage.ChallengeDialogModalContainer, p3, p5)
		end or nil,
		[appPage.ReportDialog] = function(p3)
			return module2(lazyComponent46, appPage.ReportDialog, p3)
		end,
		[appPage.AgeVerificationRequired] = function(p3, p4)
			return module2(
				lazyComponent42,
				appPage.AgeVerificationRequired,
				p3,
				p4 and { universeId = p4 } or nil
			)
		end,
		[appPage.ChallengeHybridWebView] = function(p3, p4, p5)
			return Roact.createElement(
				lazyComponent36,
				Cryo.Dictionary.join(p5, { appContainerNavigation = p3 })
			)
		end,
		[appPage.InviteLinkExpiredModal] = function(p3, p4, p5)
			return module2(lazyComponent5, appPage.InviteLinkExpiredModal, p3, p5)
		end,
		[appPage.ShareLinkInvalidModal] = function(p3, p4, p5)
			return module2(lazyComponent6, appPage.ShareLinkInvalidModal, p3, p5)
		end,
		[appPage.ProfileQRCodePage] = function(p3, p4, p5)
			return module2(lazyComponent7, appPage.ProfileQRCodePage, p3, p5)
		end,
		[appPage.AccountInfo] = function(p3, p4, p5)
			return Roact.createElement(
				lazyComponent26,
				Cryo.Dictionary.join(p5, {
					isVisible = p3.isVisible,
					displayOrder = p3.displayOrder,
					url = p4
				})
			)
		end,
		[appPage.ParentVerification] = function(p3, p4)
			return Roact.createElement(lazyComponent33, { url = p4 })
		end,
		[appPage.EmailVerification] = function(p3, p4)
			return Roact.createElement(lazyComponent33, { url = p4 })
		end,
		[appPage.VerifiedBadgeModal] = function(p3, p4, p5)
			return module2(lazyComponent13, appPage.VerifiedBadgeModal, p3, p5)
		end,
		[appPage.SocialMessageToast] = function(p3, p4, p5)
			return module2(lazyComponent8, appPage.SocialMessageToast, p3, p5)
		end,
		[appPage.PassesPage] = function(p3, p4, p5)
			local joined = { universeId = p4 }

			if p5 then
				joined = Cryo.Dictionary.join(p5, joined)
			end

			return module2(lazyComponent4, appPage.PassesPage, p3, joined)
		end,
		[appPage.AccountSettingsUpsell] = v7.GetFFlagEnableAccountSettingsUpsell() and function(p3, p4, p5)
			return module2(lazyComponent49, appPage.AccountSettingsUpsell, p3, p5)
		end or nil,
		[appPage.AmpWizardContainer] = v7.GetFFlagEnableAmpUpsellWizard() and function(p3, p4, p5)
			return module2(lazyComponent50, appPage.AmpWizardContainer, p3, p5)
		end or nil,
		[appPage.AccountUnlock] = fFlagEnableAccountUnlockDeepLink and function(p3, p4, p5)
			return module2(lazyComponent51, appPage.AccountUnlock, p3, p5)
		end or nil,
		[appPage.IDVUpsellContainer] = v7.GetFFlagEnableAmpIDVUpsellSupport() and function(p3, p4, p5)
			return module2(lazyComponent39, appPage.IDVUpsellContainer, p3, p5)
		end or nil,
		[appPage.VPCUpsellContainer] = function(p3, p4, p5)
			return module2(lazyComponent40, appPage.VPCUpsellContainer, p3, p5)
		end,
		[appPage.RobloxSubscriptionUpsell] = v7.GetFFlagEnableAmpSubscriptionUpsell() and function(p3, p4, p5)
			return module2(lazyComponent41, appPage.RobloxSubscriptionUpsell, p3, p5)
		end or nil,
		[appPage.AddAuthMethodPage] = function(p3)
			return module2(v6.AddAuthMethodPage, appPage.AddAuthMethodPage, p3)
		end,
		[appPage.PasskeyUpsellScreen] = fFlagPasskeyUpsellEnabled and function(p3, p4, p5)
			return module2(v6.PasskeyUpsellScreen, appPage.PasskeyUpsellScreen, p3, p5)
		end or nil,
		[appPage.TutorialUpsellScreen] = fFlagTutorialUpsellEnabled and function(p3, p4, p5)
			return module2(lazyComponent30, appPage.TutorialUpsellScreen, p3, p5)
		end or nil,
		[appPage.SponsoredTooltipPeekView] = function(p3, p4, p5)
			return module2(lazyComponent47, appPage.SponsoredTooltipPeekView, p3, p5)
		end,
		[appPage.InfoPeekView] = function(p3, p4, p5)
			return module2(lazyComponent48, appPage.InfoPeekView, p3, p5)
		end,
		[appPage.VoiceTrialUpsell] = module12() and function(p3, p4, p5)
			return module2(lazyComponent52, appPage.VoiceTrialUpsell, p3, p5)
		end or nil,
		[appPage.SecurityAlertInfo] = getFFlagEnableSecurityAlertDeeplink() and function(p3, p4, props)
			local createElement = Roact.createElement
			local v10 = {
				isVisible = p3.isVisible,
				DisplayOrder = p3.displayOrder,
				titleKey = "Feature.SecurityFeedback.Header.NewLogin",
				notificationType = module4.OPEN_CUSTOM_WEBVIEW,
				url = p4,
				searchParams = 0,
				transitionAnimation = 0,
				onClose = 0
			}

			local v11 = if v7.GetFFlagEnableUnifiedStaticWebViews() then props.searchParams else nil
			v10.searchParams = v11
			local v12 = if props then props.transitionAnimation or nil else nil
			v10.transitionAnimation = v12
			v10.onClose = props and props.onClose or nil
			return createElement(lazyComponent23, v10)
		end or nil
	} do
		table.insert(result, {
			[k] = {
				screen = module(v9, k),
				navigationOptions = getLegacyNavigationOptions(k)
			}
		})
	end

	if fFlagAppNavMyStatsTab then
		local v9 = {
			[appPage.Build] = {
				getScreen = function()
					return require("@luauforge/deferred/gzh")
				end,
				navigationOptions = Cryo.Dictionary.join(getLegacyNavigationOptions(appPage.Build), {
					hasSubNavigation = true
				})
			}
		}
		table.insert(result, v9)
	end

	local v9 = {
		[appPage.AvatarExperienceRoot] = {
			getScreen = function()
				return require("@luauforge/deferred/gNs")
			end,
			navigationOptions = { hasSubNavigation = true }
		}
	}
	table.insert(result, v9)

	local v10 = {
		[appPage.Chat] = createLazyComponent(function()
			return require("@luauforge/deferred/gYJ")
		end)
	}
	table.insert(result, v10)

	if fFlagEnableArgus then
		local v11 = {
			[appPage.Moments] = {
				getScreen = function()
					return require("@luauforge/deferred/hvG")
				end,
				navigationOptions = { hasSubNavigation = true }
			}
		}
		table.insert(result, v11)

		if fFlagEnableArgusImmersiveNav then
			local v12 = {
				[appPage.MomentsImmersive] = createLazyComponent(function()
					return require("@luauforge/deferred/hvZ")
				end)
			}
			table.insert(result, v12)
		end
	end

	local v11 = {
		[appPage.PurchaseRobux] = {
			screen = module(function(p3, p4, props)
				if v7.GetFFlagLuaAppLuaBuyRobuxPage() and isVRAppBuild() or isTenFootInterface() then
					return module2(lazyComponent45, appPage.PurchaseRobux, p3, props)
				end

				local v12

				if module9 then
					v12 = module5.fromString("www:Upgrades/Robux.aspx?analyticId={analyticId|}&product_id={productId|}")(props)
				end

				if
					fFlagEnableBuyRobuxNewRouting
					and v7.GetFFlagEnableUnifiedStaticWebViews()
					and not isVRAppBuild()
				then
					local buyRobuxUniversalApp = require("@luauforge/bundled/hwb").BuyRobuxUniversalApp
					local productId = props and props.productId

					if module9 then
						p4 = props and props.analyticId
					end

					local createElement = Roact.createElement
					local v14 = if productId ~= nil then tostring(productId) else nil
					local v15 = if p4 ~= nil then tostring(p4) else nil
					return createElement(buyRobuxUniversalApp, {
						productId = v14,
						analyticId = v15,
						isVisible = p3.isVisible,
						displayOrder = p3.displayOrder,
						transitionAnimation = props and props.transitionAnimation or nil,
						pageWrapper = lazyComponent25,
						callsite = "UniversalApp.PurchaseRobux"
					})
				else
					local createElement = Roact.createElement

					if not module9 then
						if v7.GetFFlagEnableUnifiedStaticWebViews() then
							v12 = module5.fromString("www:Upgrades/Robux.aspx")()
						elseif p4 then
							v12 = module5.fromString("www:Upgrades/Robux.aspx?analyticId={analyticId}")({
								analyticId = p4
							})
						else
							v12 = nil
						end
					end

					return createElement(lazyComponent25, {
						url = v12,
						isVisible = p3.isVisible,
						DisplayOrder = p3.displayOrder,
						transitionAnimation = props and props.transitionAnimation or nil
					})
				end
			end, appPage.PurchaseRobux),
			navigationOptions = getLegacyNavigationOptions(appPage.PurchaseRobux)
		}
	}
	table.insert(result, v11)

	local v12 = {
		[appPage.ReportScreen] = {
			screen = createLazyComponent(function()
				return require("@luauforge/bundled/hyW").ReportScreen
			end)
		}
	}
	table.insert(result, v12)

	local v13 = {
		[appPage.ChallengeNativeWrapper] = {
			screen = createLazyComponent(function()
				return require("@luauforge/deferred/hzH")
			end),
			navigationOptions = {
				transparent = v7.GetFFlagEnableTransparentNativeChallengeWrapper() and true or nil
			}
		}
	}
	table.insert(result, v13)

	local v14 = {
		[appPage.FAEUpsell] = {
			screen = createLazyComponent(function()
				return require("@luauforge/bundled/eeI").FAEUpsellContainer
			end),
			navigationOptions = getLegacyNavigationOptions(appPage.FAEUpsell)
		}
	}
	table.insert(result, v14)

	local v15 = {
		[appPage.NotApprovedPage] = {
			screen = module(function(p3, p4, p5)
				return module2(v6.NotApprovedPage, appPage.NotApprovedPage, p3, p5)
			end, appPage.NotApprovedPage)
		}
	}
	table.insert(result, v15)

	if getFFlagEnablePlatformRestrictedEventReceiver() then
		local v16 = {
			[appPage.PlatformLockedPage] = {
				screen = module(function(p3, p4, p5)
					return module2(v6.PlatformLockedPage, appPage.PlatformLockedPage, p3, p5)
				end, appPage.PlatformLockedPage)
			}
		}
		table.insert(result, v16)
	end

	if fFlagLuaAppBirthdayComplianceGate then
		local v16 = {
			[appPage.BirthdayCompliancePage] = {
				screen = module(function(p3, p4, p5)
					return module2(v6.BirthdayCompliancePage, appPage.BirthdayCompliancePage, p3, p5)
				end, appPage.BirthdayCompliancePage),
				navigationOptions = Cryo.Dictionary.join(
					getLegacyNavigationOptions(appPage.BirthdayCompliancePage),
					{ overlayEnabled = false }
				)
			}
		}
		table.insert(result, v16)
	end

	if fFlagEnablePioneerPostAuthGameJoin then
		local v16 = {
			[appPage.PioneerPostAuth] = {
				screen = module(function(p3, p4, p5)
					return module2(v6.PioneerPostAuthPage, appPage.PioneerPostAuth, p3, p5)
				end, appPage.PioneerPostAuth)
			}
		}
		table.insert(result, v16)
	end

	if fFlagEnablePlusReferralDashboard then
		local v16 = {
			[appPage.PlusReferralDashboard] = {
				screen = module(function(p3, p4, p5)
					return module2(lazyComponent44, appPage.PlusReferralDashboard, p3, p5)
				end, appPage.PlusReferralDashboard),
				navigationOptions = getLegacyNavigationOptions(appPage.PlusReferralDashboard)
			}
		}
		table.insert(result, v16)
	end

	return result
end
