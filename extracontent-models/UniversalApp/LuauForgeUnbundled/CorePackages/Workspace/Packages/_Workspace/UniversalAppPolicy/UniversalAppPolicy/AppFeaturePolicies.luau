local UserInputService = game:GetService("UserInputService")

local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/AppCommonLib").IsVRAppBuild
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/AppCommonLib").isTenFootInterface

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/Cryo")
local colorMode = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/Foundation").Enums.ColorMode
local values = Cryo.Dictionary.values(colorMode)
local CrossPlayCapabilities = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/UniversalAppPolicy/Enum/CrossPlayCapabilities")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/SharedFlags")
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local isRunningInStudio = require("@game/CorePackages/Workspace/Packages/_Workspace/UniversalAppPolicy/AppCommonLib").isRunningInStudio
local getFFlagDisableCDLQrCodeForMaquettes = SharedFlags.GetFFlagDisableCDLQrCodeForMaquettes
local getFFlagUseEnablePremiumUserFeaturesAppPolicy = SharedFlags.GetFFlagUseEnablePremiumUserFeaturesAppPolicy
local getFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local getFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft
local getFFlagUseExternalBrowserForAgeGuidelines10ft = SharedFlags.GetFFlagUseExternalBrowserForAgeGuidelines10ft
local getFFlagEnableGateNotificationPreferencesTab = SharedFlags.GetFFlagEnableGateNotificationPreferencesTab
local getFFlagEnableSupportCenter = SharedFlags.GetFFlagEnableSupportCenter
local fFlagLuaAppHomeVngAppUpsell = SharedFlags.FFlagLuaAppHomeVngAppUpsell
local fFlagVngAppUpsellPcLayout = SharedFlags.FFlagVngAppUpsellPcLayout
local fFlagLuaAppParentUpsellPolicy = SharedFlags.FFlagLuaAppParentUpsellPolicy
local fFlagRenameParentEmailForVerificationUpsell = SharedFlags.FFlagRenameParentEmailForVerificationUpsell
local getFFlagSeamlessVoiceConsentToastPolicy = SharedFlags.GetFFlagSeamlessVoiceConsentToastPolicy
local getFFlagEnableMultiPageSignup = SharedFlags.GetFFlagEnableMultiPageSignup

local getFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup = SharedFlags.GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup
local fFlagEnableMicrosoftStorePaymentsPlatform = SharedFlags.FFlagEnableMicrosoftStorePaymentsPlatform
local fFlagEnableMilkyWayPaymentsPlatformV2 = SharedFlags.FFlagEnableMilkyWayPaymentsPlatformV2
local fFlagAppIaScrollAwayGuac = SharedFlags.FFlagAppIaScrollAwayGuac
local fFlagEnableScreentimeMoreTimeOption = SharedFlags.FFlagEnableScreentimeMoreTimeOption
local fFlagEnableFriendsRenamingForAll = SharedFlags.FFlagEnableFriendsRenamingForAll
local getFFlagExpChatGuacChatDisabledReason = SharedFlags.GetFFlagExpChatGuacChatDisabledReason
local fFlagGuacCanRenderTransferOnProfile = SharedFlags.FFlagGuacCanRenderTransferOnProfile
local fFlagEnableFaceIDTextOnAddAuthMethodPage = SharedFlags.FFlagEnableFaceIDTextOnAddAuthMethodPage
local fFlagEnableMorePageExitButtonSupport = SharedFlags.FFlagEnableMorePageExitButtonSupport
local fFlagEnableMorePageDirectionalLayoutRolloutFix = SharedFlags.FFlagEnableMorePageDirectionalLayoutRolloutFix
local fFlagAEGIS2UseGuacToShowEnabledMessage = SharedFlags.FFlagAEGIS2UseGuacToShowEnabledMessage
local fFlagAEGIS2UseGuacToShowFAEUpsell = SharedFlags.FFlagAEGIS2UseGuacToShowFAEUpsell
local fFlagMacMenuBarContentUpdates = SharedFlags.GetFFlagMacMenuBarContentUpdates()

local defineFastFlag = game:DefineFastFlag("LuaAppEnableRecommendedCarouselForDesktop", false)
local defineFastFlag2 = game:DefineFastFlag("DisableWebViewSupportInStudio", false)
local fFlagUsesCancelSearchAppPolicy = SharedFlags.FFlagUsesCancelSearchAppPolicy
local defineFastFlag3 = game:DefineFastFlag("DebugUseLegacyCrossPlayApi", false)
local defineFastString = game:DefineFastString("DebugOverrideCrossPlaySettingsKey", "")
local defineFastString2 = game:DefineFastString("DebugOverrideCrossPlayQueryParam", "")
local defineFastFlag4 = game:DefineFastFlag("DebugCrossPlaySystemUi", false)
local defineFastString3 = game:DefineFastString("DebugOverrideCrossPlayUri", "")
local defineFastString4 = game:DefineFastString("DebugMomentsFeatureList", "")
local defineFastFlag5 = game:DefineFastFlag("GuacAppPolicyDisableSignupCheckbox", false)
local defineFastFlag6 = game:DefineFastFlag("FlyoutDisablePremiumEntrypoint1", false)
local defineFastFlag7 = game:DefineFastFlag("GuacDisableBlackbirdEntrypoints", false)
local defineFastFlag8 = game:DefineFastFlag("FlyoutEnableGiftcardsWithRedeem", false)

local defineFastFlag9 = game:DefineFastFlag("DebugForceShowIllegalContentReportingUI", false)
local fFlagExpChatUseGuacForFOMOUpsell = SharedFlags.FFlagExpChatUseGuacForFOMOUpsell
local fFlagExpChatUseGuacForCrossAgeChat = SharedFlags.FFlagExpChatUseGuacForCrossAgeChat
local fFlagEnableAndroidTvAppPolicies = SharedFlags.FFlagEnableAndroidTvAppPolicies
local fFlagEnableCoreContentAccountType = SharedFlags.FFlagEnableCoreContentAccountType
local fFlagEnableCoreContentBadge = SharedFlags.FFlagEnableCoreContentBadge
local fFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local fFlagEnableNonFlyoutUncheckedBadge = SharedFlags.FFlagEnableNonFlyoutUncheckedBadge
local getFFlagEnableAccountSwitcherUncheckedBadge = SharedFlags.GetFFlagEnableAccountSwitcherUncheckedBadge
local fFlagShowGameAgeRating = SharedFlags.FFlagShowGameAgeRating
local fFlagDefaultKidsToDarkTheme = SharedFlags.FFlagDefaultKidsToDarkTheme
local fFlagLuaAppSupportDisablePlayableWhenLoading = SharedFlags.FFlagLuaAppSupportDisablePlayableWhenLoading
local fFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab
local fFlagAppChatOnConsoles = SharedFlags.FFlagAppChatOnConsoles
local defineFastFlag10 = game:DefineFastFlag("UseOriginalPlatformChatPolicy", false)
local fFlagFriendsChatEnableConversationConsent = SharedFlags.FFlagFriendsChatEnableConversationConsent
local fFlagFriendsChatDiscloseUpdateSecondVersion = SharedFlags.FFlagFriendsChatDiscloseUpdateSecondVersion
local fFlagFriendsChatHasFriendsGate = SharedFlags.FFlagFriendsChatHasFriendsGate
local fFlagAddPinExperienceTargetDestinationGUACPolicy = SharedFlags.FFlagAddPinExperienceTargetDestinationGUACPolicy
local fFlagFlyoutGateLearnPlace = SharedFlags.FFlagFlyoutGateLearnPlace

game:DefineFastFlag("BehaviorCollectionControlEnabled", false)

game:DefineFastFlag("LuaAppPromotionalEmailsCheckboxEnabledInAppPolicy", false)

local getFFlagNotificationsComplianceShouldRestrictStream = SharedFlags.GetFFlagNotificationsComplianceShouldRestrictStream

local function AppFeaturePolicies(rawPolicy)
	local function getVRDefaultPolicy(p2, p3)
		if rawPolicy[p2] ~= nil then
			return rawPolicy[p2]
		end

		if isVRAppBuild() then
			return p3
		end

		return not p3
	end

	return {
		getFriendFinder = function()
			return rawPolicy.FriendFinder or false
		end,
		getGameDetailsMorePage = function()
			return rawPolicy.GameDetailsMorePage or false
		end,
		getGameDetailsSubtitle = function()
			return rawPolicy.GameDetailsSubtitle or false
		end,
		getShowGlobalCounters = function()
			return rawPolicy.GameDetailsShowGlobalCounters or false
		end,
		getGameDetailsPlayWithFriends = function()
			return rawPolicy.GameDetailsPlayWithFriends or false
		end,
		getGameInfoList = function()
			return rawPolicy.GameInfoList or false
		end,
		getGamePlaysAndRatings = function()
			return rawPolicy.GamePlaysAndRatings or false
		end,
		getNotifications = function()
			return rawPolicy.Notifications or false
		end,
		getRecommendedGames = function()
			if defineFastFlag then
				return rawPolicy.RecommendedGames or false
			end

			if isSubjectToDesktopPolicies() then
				return false
			end

			return rawPolicy.RecommendedGames or false
		end,
		getSearchBar = function()
			return rawPolicy.SearchBar or false
		end,
		getMorePageContent = function()
			if defineFastFlag10 then
				return rawPolicy.MorePageContent
			end

			if fFlagAppChatOnConsoles then
				return rawPolicy.MorePageContent2
			end

			return rawPolicy.MorePageContent
		end,
		getAboutPageType = function()
			return rawPolicy.AboutPageType or "CJVAbout"
		end,
		getSettingsPageType = function()
			return rawPolicy.SettingsPageType or "Settings"
		end,
		getSocialLinks = function()
			return rawPolicy.SocialLinks or false
		end,
		getSocialGroupLinks = function()
			return rawPolicy.SocialGroupLinks or false
		end,
		getCommunityLinksEnabled = function()
			return rawPolicy.CommunityLinksEnabled or false
		end,
		getGameInfoShowBadges = function()
			return rawPolicy.GameInfoShowBadges or false
		end,
		getGameInfoShowCreated = function()
			return rawPolicy.GameInfoShowCreated or false
		end,
		getGameInfoShowGamepasses = function()
			return rawPolicy.GameInfoShowGamepasses or false
		end,
		getGameInfoShowGenre = function()
			return rawPolicy.GameInfoShowGenre or false
		end,
		getGameInfoShowSubgenre = function()
			return rawPolicy.GameInfoShowSubgenre or false
		end,
		getGameInfoShowMaxPlayers = function()
			return rawPolicy.GameInfoShowMaxPlayers or false
		end,
		getGameInfoShowServers = function()
			return rawPolicy.GameInfoShowServers or false
		end,
		getGameInfoShowUpdated = function()
			return rawPolicy.GameInfoShowUpdated or false
		end,
		getGameInfoShowAgeRecommendation = function()
			if rawPolicy.GameInfoShowAgeRecommendation == nil then
				return true
			end

			return rawPolicy.GameInfoShowAgeRecommendation
		end,
		getGameInfoShowVoiceAndChatFeatures = function()
			if rawPolicy.GameInfoShowVoiceAndChatFeatures == nil then
				return true
			end

			return rawPolicy.GameInfoShowVoiceAndChatFeatures
		end,
		getSiteMessageBanner = function()
			return rawPolicy.SiteMessageBanner or false
		end,
		getAlertRateLimit = function()
			return rawPolicy.AlertRateLimit or 300
		end,
		getSearchAutoComplete = function()
			return rawPolicy.SearchAutoComplete or false
		end,
		getShowStudioCTA = function()
			return rawPolicy.ShowStudioCTA or false
		end,
		getAppIaScrollAwayEnabled = fFlagAppIaScrollAwayGuac and function()
			return rawPolicy.AppIaScrollAwayEnabled or false
		end or nil,
		getUseOmniRecommendation = function()
			if rawPolicy.UseOmniRecommendation == nil then
				return true
			end

			return rawPolicy.UseOmniRecommendation
		end,
		getUseWidthBasedFormFactorRule = function()
			return rawPolicy.UseWidthBasedFormFactorRule or false
		end,
		getShowYouTubeAgeAlert = function()
			if rawPolicy.ShowYouTubeAgeAlert == nil then
				return true
			end

			return rawPolicy.ShowYouTubeAgeAlert
		end,
		getShowVideoThumbnails = function()
			return rawPolicy.ShowVideoThumbnails or false
		end,
		getHomeIcon = function()
			return rawPolicy.HomeIcon or "LuaApp/icons/ic-roblox-close"
		end,
		getGameInfoListShowRNVDeveloper = function()
			return rawPolicy.GameInfoListShowRNVDeveloper or false
		end,
		getGameInfoListDeveloper = function()
			return rawPolicy.GameInfoListDeveloper or false
		end,
		getShowDisplayName = function()
			if rawPolicy.ShowDisplayName == nil then
				return true
			end

			return rawPolicy.ShowDisplayName
		end,
		getShowAlias = function()
			if rawPolicy.ShowUserAlias == nil then
				return true
			end

			return rawPolicy.ShowUserAlias
		end,
		getCatalogReportingDisabled = function()
			return rawPolicy.CatalogReportingDisabled or false
		end,
		getGameReportingDisabled = function()
			return rawPolicy.GameReportingDisabled or false
		end,
		getGamesPageCreationCenterTitle = function()
			return rawPolicy.GamesPageCreationCenterTitle or false
		end,
		shouldUseExternalBrowserForDisclaimerLinks = function()
			return rawPolicy.UseExternalBrowserForDisclaimerLinks or false
		end,
		shouldUseExternalBrowserForMorePageItem = function()
			return rawPolicy.UseExternalBrowserForMoreLinks or false
		end,
		getCatalogShow3dView = function()
			return rawPolicy.CatalogShow3dView or false
		end,
		getItemDetailsFullView = function()
			return rawPolicy.ItemDetailsFullView or false
		end,
		getCatalogCommunityCreations = function()
			return rawPolicy.CatalogCommunityCreations or false
		end,
		getCatalogPremiumCategory = function()
			return rawPolicy.CatalogPremiumCategory or false
		end,
		getShowCatalogPremiumContent = function()
			return rawPolicy.CatalogPremiumContent or false
		end,
		getRobloxCreatedItemsCreatedByLuobu = function()
			if rawPolicy.RobloxCreatedItemsCreatedByLuobu == nil then
				return true
			end

			return rawPolicy.RobloxCreatedItemsCreatedByLuobu
		end,
		getHomePageFriendSection = function()
			return rawPolicy.HomePageFriendSection or false
		end,
		getHomePageProfileLink = function()
			return rawPolicy.HomePageProfileLink or false
		end,
		getPurchasePromptIncludingWarning = function()
			if rawPolicy.PurchasePromptIncludingWarning == nil then
				return true
			end

			return rawPolicy.PurchasePromptIncludingWarning
		end,
		getCheckUserAgreementsUpdatedOnLogin = function()
			if rawPolicy.CheckUserAgreementsUpdatedOnLogin == nil then
				return true
			end

			return rawPolicy.CheckUserAgreementsUpdatedOnLogin
		end,
		getAddUserAgreementIdsToSignupRequest = function()
			return rawPolicy.AddUserAgreementIdsToSignupRequest or false
		end,
		RequireExplicitVoiceConsent = function()
			return rawPolicy.RequireExplicitVoiceConsent or false
		end,
		getRequireExplicitAvatarVideoConsent = function()
			return rawPolicy.RequireExplicitAvatarVideoConsent or false
		end,
		getShowVoiceUpsellV2 = function()
			return rawPolicy.ShowVoiceUpsellV2 or false
		end,
		getShouldShowGroupsTile = function()
			return rawPolicy.ShouldShowGroupsTile or false
		end,
		useLuobuAuthentication = function()
			return rawPolicy.UseLuobuAuthentication or false
		end,
		useWechatQQAuthentication = function()
			return rawPolicy.UseWechatQQAuthentication or false
		end,
		useMSDKWebAuthentication = function()
			return rawPolicy.UseMSDKWebAuthentication or false
		end,
		getQrFriendingEnabled = function()
			return rawPolicy.QrFriendingEnabled or false
		end,
		getShouldShowCameraPermissionInAgreementsPrompt = function()
			return rawPolicy.ShouldShowCameraPermissionInAgreementsPrompt or false
		end,
		getExperienceInviteShareLinkEnabled = function()
			return rawPolicy.ExperienceInviteShareLinkEnabled or false
		end,
		getCsatSurveyRestrictTextInput = function()
			return rawPolicy.CsatSurveyRestrictTextInput or false
		end,
		useGridPageLayout = function()
			if isVRAppBuild() then
				if rawPolicy.UseGridPageLayout ~= nil then
					return rawPolicy.UseGridPageLayout
				end

				if isVRAppBuild() then
					return true
				end

				return false
			elseif rawPolicy.UseGridPageLayout == nil then
				return isSubjectToDesktopPolicies()
			else
				return rawPolicy.UseGridPageLayout
			end
		end,
		usePhoneSearchDiscoverEntry = function()
			if rawPolicy.UsePhoneSearchDiscoverEntry == nil then
				return not isSubjectToDesktopPolicies()
			end

			return rawPolicy.UsePhoneSearchDiscoverEntry
		end,
		getShouldSystemBarUsuallyBePresent = function()
			if isVRAppBuild() then
				if rawPolicy.ShouldSystemBarUsuallyBePresentForVR ~= nil then
					return rawPolicy.ShouldSystemBarUsuallyBePresentForVR
				end

				if isVRAppBuild() then
					return true
				end

				return false
			elseif isTenFootInterface() then
				return true
			else
				return rawPolicy.ShouldSystemBarUsuallyBePresent or false
			end
		end,
		getContactImporterEnabled = function()
			if isSubjectToDesktopPolicies() then
				return false
			end

			return rawPolicy.ContactImporterEnabled or false
		end,
		getShouldShowSettingsPermissionsAdditionalInstructions = function()
			return rawPolicy.shouldShowSettingsPermissionsAdditionalInstructions or false
		end,
		getUseVRFTUXPanel = function()
			if rawPolicy.UseVRFTUXPanel ~= nil then
				return rawPolicy.UseVRFTUXPanel
			end

			if isVRAppBuild() then
				return true
			end

			return false
		end,
		getWebViewSupport = function()
			if isRunningInStudio() then
				if defineFastFlag2 then
					return false
				end
			else
				if rawPolicy.EnableWebViewSupport ~= nil then
					return rawPolicy.EnableWebViewSupport
				end

				if isVRAppBuild() then
					return false
				end
			end

			return true
		end,
		getUseLuafiedReportFlow = function()
			if isVRAppBuild() and getFFlagLuafiedReportEntryPoints() then
				if rawPolicy.UseLuafiedReportFlow ~= nil then
					return rawPolicy.UseLuafiedReportFlow
				end

				if isVRAppBuild() then
					return true
				end

				return false
			elseif getFFlagEnableAbuseReport10ft() then
				return rawPolicy.UseLuafiedReportFlow or false
			else
				return nil
			end
		end,
		getThrottleFramerate = function()
			if rawPolicy.ThrottleFramerate ~= nil then
				return rawPolicy.ThrottleFramerate
			end

			if isVRAppBuild() then
				return false
			end

			return true
		end,
		getUseRoundedCorners = function()
			if not isVRAppBuild() then
				return false
			end

			if rawPolicy.UseRoundedCorners ~= nil then
				return rawPolicy.UseRoundedCorners
			end

			if isVRAppBuild() then
				return true
			end

			return false
		end,
		getGameInfoShowChatFeatures = function(): boolean
			return false
		end,
		getDisplayCheckboxInVoiceConsent = function()
			if getFFlagSeamlessVoiceConsentToastPolicy() then
				return rawPolicy.DisplayCheckboxInVoiceConsent or false
			end

			return false
		end,
		getExperienceChatAvailability = function()
			if getFFlagExpChatGuacChatDisabledReason() then
				return rawPolicy.ExperienceChatAvailability or "unknown"
			end

			return "unknown"
		end,
		getInCommsRegionBubble = function()
			if fFlagAEGIS2UseGuacToShowEnabledMessage then
				return rawPolicy.InCommsRegionBubble or false
			end

			return false
		end,
		getShowInExpFAEUpsell = function()
			if fFlagAEGIS2UseGuacToShowFAEUpsell then
				return rawPolicy.ShowInExpFAEUpsell or false
			end

			return false
		end,
		getUseAmpV2WizardForVpc = function()
			return rawPolicy.UseAmpV2WizardForVpc or false
		end,
		getAmpV2VpcExcludedRequestTypes = function()
			return rawPolicy.AmpV2VpcExcludedRequestTypes or {}
		end,
		getShowFOMOUpsell = function()
			if fFlagExpChatUseGuacForFOMOUpsell then
				return rawPolicy.ShowFOMOUpsell or false
			end

			return false
		end,
		getShowCrossAgeChat = function()
			if fFlagExpChatUseGuacForCrossAgeChat then
				return rawPolicy.ShowCrossAgeExpChat or false
			end

			return false
		end,
		getCanSeeChatTerminology = function()
			return rawPolicy.canSeeChatTerminology or false
		end,
		getAllowCameraMovements = function()
			if rawPolicy.AllowCameraMovements ~= nil then
				return rawPolicy.AllowCameraMovements
			end

			if isVRAppBuild() then
				return false
			end

			return true
		end,
		getShouldSkipAvatarLandingPage = function()
			if rawPolicy.ShouldSkipAvatarLandingPage ~= nil then
				return rawPolicy.ShouldSkipAvatarLandingPage
			end

			if isVRAppBuild() then
				return true
			end

			return false
		end,
		getShowPassesOnExperienceDetails = function()
			return rawPolicy.ShowPassesOnExperienceDetails or false
		end,
		getDisableCDLQrCodeForMaquettes = function()
			if getFFlagDisableCDLQrCodeForMaquettes() then
				return rawPolicy.DisableCDLQrCodeForMaquettes
			end

			return false
		end,
		getDisableIAPEntryPoint = function()
			return rawPolicy.DisableIAPEntryPoint or false
		end,
		getEnforceAgeRestrictedLogin = function()
			return rawPolicy.EnforceAgeRestrictedLogin or false
		end,
		getUrlAuthRoutes = function()
			local routes = rawPolicy.Routes or {}

			if routes then
				return routes.auth or {}
			end

			return {}
		end,
		getShowDisconnectButton = function()
			return rawPolicy.ShowDisconnectButton or false
		end,
		getUseSingleSignOn = function()
			if isRunningInStudio() then
				return false
			end

			return rawPolicy.UseSingleSignOn or false
		end,
		getGridCarouselSeeAllTilesEnabled = function()
			return rawPolicy.UseGridCarouselSeeAllTiles or false
		end,
		getSearchWithoutNavigatingEnabled = function()
			if isTenFootInterface() then
				return false
			end

			return rawPolicy.SingleSearchPageNoNavigation or false
		end,
		getGameListCategoryScrollListEnabled = function()
			return rawPolicy.GetGamesListCategoryTabs or false
		end,
		getForceTheme = function()
			local mapped = Cryo.List.map(values, function(value)
				return value:lower()
			end)

			if rawPolicy.ForceTheme and Cryo.List.find(mapped, rawPolicy.ForceTheme:lower()) then
				return rawPolicy.ForceTheme
			end

			return nil
		end,
		enableExperienceDetailsPanel = function()
			return rawPolicy.EnableExperienceDetailsPanel or false
		end,
		getDisableRegularLogin = function(): boolean
			return not (rawPolicy.EnableWebViewSupport or rawPolicy.EnableRegularLoginWithoutWebViewSupport)
				or false
		end,
		getAllowPlatformAccountSwitching = function()
			return rawPolicy.AllowPlatformAccountSwitching or false
		end,
		useLegacyCrossPlayApi = function()
			return defineFastFlag3 or rawPolicy.useLegacyCrossPlayApi or false
		end,
		useCrossPlaySystemUi = function()
			return defineFastFlag4 or rawPolicy.useCrossPlaySystemUi or false
		end,
		getCrossPlayUri = function()
			if defineFastString3 == "" then
				return rawPolicy.crossPlayUri or ""
			end

			return defineFastString3
		end,
		getCrossPlayCapabilities = function()
			return Cryo.List.foldLeft(rawPolicy.crossPlayCapabilities or {}, function(p2, p3)
				if Cryo.List.find(p2, p3) then
					return p2
				end

				return Cryo.List.join(p2, { CrossPlayCapabilities[p3] })
			end, {})
		end,
		getCrossPlaySettingsKey = function()
			if defineFastString == "" then
				return rawPolicy.crossPlaySettingsKey or ""
			end

			return defineFastString
		end,
		getCrossPlayQueryParam = function()
			if defineFastString2 == "" then
				return rawPolicy.crossPlayQueryParam or ""
			end

			return defineFastString2
		end,
		getPromotionalEmailsCheckboxEnabled = function()
			if game:GetFastFlag("LuaAppPromotionalEmailsCheckboxEnabledInAppPolicy") then
				return rawPolicy.PromotionalEmailsCheckboxEnabled or false
			end

			return false
		end,
		getPromotionalEmailsOptInByDefault = function()
			if game:GetFastFlag("LuaAppPromotionalEmailsCheckboxEnabledInAppPolicy") then
				return rawPolicy.PromotionalEmailsOptInByDefault or false
			end

			return false
		end,
		getSupportsOverscan = function()
			return rawPolicy.SupportsOverscan or false
		end,
		getUseConsoleGameJoinCard = function()
			return rawPolicy.UseConsoleGameJoinCard or false
		end,
		getPlatformDisplayName = function()
			return rawPolicy.platformDisplayName or ""
		end,
		getPlatformAccountName = function()
			return rawPolicy.platformAccountName or nil
		end,
		getSupportsProfileSwitching = function()
			return rawPolicy.supportsProfileSwitching or false
		end,
		getMountAllOmniFeedItems = function()
			return rawPolicy.mountAllOmniFeedItems or false
		end,
		getFriendCodeQrCodeScannerEnabled = function()
			return rawPolicy.FriendCodeQrCodeScannerEnabled or false
		end,
		getInviteFriendsDisabled = function()
			return rawPolicy.InviteFriendsDisabled or false
		end,
		getRealNamesInDisplayNamesEnabled = function()
			return rawPolicy.RealNamesInDisplayNamesEnabled or false
		end,
		getProfileShareLinkEnabled = function()
			return rawPolicy.ProfileShareLinkEnabled
		end,
		getProfileCopyLinkEnabled = function()
			return rawPolicy.ProfileCopyLinkEnabled
		end,
		getEnablePremiumUserFeatures = function()
			if getFFlagUseEnablePremiumUserFeaturesAppPolicy() then
				return rawPolicy.EnablePremiumUserFeatures or false
			end

			return nil
		end,
		getEnableDualLogin = function()
			return rawPolicy.enableDualLogin or false
		end,
		getUseExternalBrowserForAgeGuidelines = function()
			if getFFlagUseExternalBrowserForAgeGuidelines10ft() then
				return rawPolicy.UseExternalBrowserForAgeGuidelines or false
			end

			return nil
		end,
		getEnableHomePageAgeBlock = function()
			return rawPolicy.EnableHomePageAgeBlock or false
		end,
		getEnableUAppAccessBlock = function()
			return rawPolicy.EnableUAppAccessBlock or false
		end,
		getUAppBlockPageTextMapKey = function()
			return rawPolicy.UAppBlockPageTextMapKey or nil
		end,
		getUAppBlockPageShouldDisableLogOut = function()
			return rawPolicy.UAppBlockPageShouldDisableLogOut or nil
		end,
		getContactsToastEnabled = function()
			return rawPolicy.ContactsToastEnabled or false
		end,
		getEnableProfileQrCode = function()
			return rawPolicy.EnableProfileQrCode or false
		end,
		getCanRenderTransferOnProfile = function()
			if fFlagGuacCanRenderTransferOnProfile then
				return rawPolicy.CanRenderTransferOnProfile or false
			end

			return false
		end,
		getShowVNGLoginWithExistingAccountQuickLoginButton = function()
			return rawPolicy.ShowVNGLoginWithExistingAccountQuickLoginButton or false
		end,
		getUseCrossDeviceLoginByDefault = function()
			return rawPolicy.UseCrossDeviceLoginByDefault or false
		end,
		getShowVNGAge12Badge = function()
			return rawPolicy.ShowVNGAge12Badge or false
		end,
		getShowBrazilContentRatingLogo = function()
			return rawPolicy.ShowBrazilContentRatingLogo or false
		end,
		getUseVNGUserAgreementPopup = function()
			return rawPolicy.UseVNGUserAgreementPopup or false
		end,
		getRedirectBuyRobuxToVNG = function()
			return rawPolicy.RedirectBuyRobuxToVNG or false
		end,
		getShowVNGTosForRobuxUpsell = function()
			return rawPolicy.ShowVNGTosForRobuxUpsell or false
		end,
		getBlockVNGU12SignUpOnClientSide = function()
			return rawPolicy.BlockVNGU12SignUpOnClientSide or false
		end,
		getMetaSignupMinimumAge = function()
			if isVRAppBuild() then
				return tonumber(rawPolicy.MetaSignupMinimumAge) or 10
			end

			return nil
		end,
		getUseAgeInput = function()
			return rawPolicy.UseAgeInput or false
		end,
		getLoginUsernameOnly = function()
			return rawPolicy.LoginUsernameOnly or false
		end,
		getDisableEmailOTPLogin = function()
			return rawPolicy.DisableEmailOTPLogin or false
		end,
		getDisableLoginForgotButton = function()
			return rawPolicy.DisableLoginForgotButton or false
		end,
		getDisableLogOutEmailUpsell = function()
			return rawPolicy.DisableLogOutEmailUpsell or false
		end,
		getVerifiedSignupCountry = function()
			return rawPolicy.verifiedSignupCountry or false
		end,
		getParentalConsentAgreementId = function()
			return rawPolicy.parentalConsentAgreementId or ""
		end,
		getIsStrictComplianceEnabled = function()
			return rawPolicy.isStrictComplianceEnabled or false
		end,
		getUseKoreaKISAUserAgreementPopup = function()
			return rawPolicy.useKoreaKISAUserAgreementPopup or false
		end,
		getEnableNotificationPreferencesPage = function()
			if getFFlagEnableGateNotificationPreferencesTab() then
				return rawPolicy.EnableNotificationPreferencesPage or false
			end

			return nil
		end,
		getVNGFormRequired = function()
			return rawPolicy.VNGFormRequired or false
		end,
		getUpsellVoiceForPhoneVerification = function()
			return rawPolicy.UpsellVoiceForPhoneVerification or false
		end,
		getIsLinkedVRModeAvailable = function(): boolean
			local platform = UserInputService:GetPlatform()
			return platform == Enum.Platform.Windows or platform == Enum.Platform.UWP
		end,
		getShouldShowPhoneUpsell = function()
			return rawPolicy.ShouldShowPhoneUpsell or false
		end,
		getTermsOfUseLink = function()
			return rawPolicy.TermsOfUseLink or ""
		end,
		getPrivacyPolicyLink = function()
			return rawPolicy.PrivacyPolicyLink or ""
		end,
		getVngAppUpsell = function()
			if fFlagLuaAppHomeVngAppUpsell then
				return rawPolicy.VngAppUpsell or false
			end

			return false
		end,
		getVngAppUpsellPcLayout = fFlagVngAppUpsellPcLayout and function()
			return rawPolicy.VngAppUpsellPcLayout or false
		end or nil,
		getShouldHideContactImporterUpsell = function()
			return rawPolicy.ShouldHideContactImporterUpsell or false
		end,
		getContactImporterEncouraged = function()
			return rawPolicy.contactImporterEncouraged or false
		end,
		getFriendRequestNicknamesEnabled = function(): boolean
			return false
		end,
		getShouldShowVpcPlayButtonUpsells = fFlagLuaAppParentUpsellPolicy and function()
			return rawPolicy.shouldShowVpcPlayButtonUpsells or false
		end or nil,
		getDisablePlayableWhenLoading = fFlagLuaAppSupportDisablePlayableWhenLoading and function()
			return rawPolicy.DisablePlayableWhenLoading or false
		end or nil,
		getRenamePaymentsToSpendingTab = function()
			return rawPolicy.renamePaymentsToSpendingTab or false
		end,
		getNotificationsCanReceiveStream = function()
			if getFFlagNotificationsComplianceShouldRestrictStream() then
				return rawPolicy.notificationsCanAccessStream or false
			end

			return nil
		end,
		getNotificationsCanReceivePush = function()
			return rawPolicy.notificationsCanAccessPush or false
		end,
		getPushNotificationsUpsell = function()
			return rawPolicy.ShouldShowPushNotificationsUpsell or false
		end,
		getNotificationsCanReceiveExperience = function()
			if rawPolicy.notificationsCanAccessExperience == nil then
				return true
			end

			return rawPolicy.notificationsCanAccessExperience
		end,
		getDisableResellingCollectiblesForCompliance = function()
			return rawPolicy.DisableResellingCollectiblesForCompliance or false
		end,
		getShowIllegalContentReportingUI = function()
			return defineFastFlag9 or rawPolicy.ShowIllegalContentReportingUI or false
		end,
		getEligibleForContentPostFeed = function()
			return rawPolicy.EligibleForContentPostFeed or false
		end,
		getEligibleForExternalContentSharing = function()
			return rawPolicy.EligibleForExternalContentSharing or false
		end,
		getEnableContinuousLoad = function()
			return rawPolicy.EnableContinuousLoad or false
		end,
		getEnableAggregateLikesFavoritesCount = function()
			return rawPolicy.EnableAggregateLikesFavoritesCount or false
		end,
		getShowUpdatedCameraPath = function()
			return rawPolicy.showUpdatedCameraPath or false
		end,
		getRenameParentEmailForVerificationUpsell = function()
			if fFlagRenameParentEmailForVerificationUpsell() then
				return rawPolicy.renameParentEmailForVerificationUpsell or false
			end

			return false
		end,
		getKeystrokeCollectionEnabled = function()
			if game:GetFastFlag("BehaviorCollectionControlEnabled") then
				return rawPolicy.EnableKeystrokeCollection or false
			end

			return false
		end,
		getCanUsePlatformChat = function()
			if defineFastFlag10 then
				return rawPolicy.CanUsePlatformChat or false
			end

			if fFlagAppChatOnConsoles then
				return rawPolicy.CanUsePlatformChat2 or false
			end

			return rawPolicy.CanUsePlatformChat or false
		end,
		getCanSeeChatTab = function()
			if defineFastFlag10 then
				return rawPolicy.CanSeeChatTab or false
			end

			if fFlagAppChatOnConsoles then
				return rawPolicy.CanSeeChatTab2 or false
			end

			return rawPolicy.CanSeeChatTab or false
		end,
		getCanSeeFriendsTab = function(): boolean
			local v5 = {
				ContextCard = true,
				ContextCardUkCopy = fFlagFriendsChatDiscloseUpdateSecondVersion,
				ConversationConsent = fFlagFriendsChatEnableConversationConsent,
				FriendCountGate = fFlagFriendsChatHasFriendsGate,
				VR = false,
				Console = false,
				Gamepad = false
			}

			for k, v6 in rawPolicy.FriendsTabRequiredCapabilities or {} do
				if not v5[v6] then
					return false
				end
			end

			return true
		end,
		getHidesGamesTab = function()
			if fFlagEnableAndroidTvAppPolicies then
				return rawPolicy.HidesGamesTab or false
			end

			return false
		end,
		getShowDisclaimerLinkForUnderageSignupsOnAllSignupPages = function()
			if not (getFFlagEnableMultiPageSignup() and rawPolicy.ShowTermsAndPrivacyPolicyLinksForAllPagesU13Signup ~= nil) then
				return true
			end

			return rawPolicy.ShowTermsAndPrivacyPolicyLinksForAllPagesU13Signup
		end,
		getAgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages = function()
			local fIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup = getFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup()

			if not (getFFlagEnableMultiPageSignup() and rawPolicy.AgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages ~= nil) then
				return fIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup
			end

			return rawPolicy.AgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages
		end,
		getRobuxUpsellFlowMobile = function()
			return rawPolicy.useMobileRobuxUpsellFlow or false
		end,
		getUsePaymentPlatformMicrosoftStore = function()
			if fFlagEnableMicrosoftStorePaymentsPlatform then
				return rawPolicy.usePaymentPlatformMicrosoftStore or false
			end

			return false
		end,
		getMicSettingsDirectionsLocaleKey = function()
			return rawPolicy.micSettingsDirectionsLocaleKey or nil
		end,
		getMicSettingsDeeplinkDirectionsLocaleKey = function()
			return rawPolicy.micSettingsDeeplinkDirectionsLocaleKey or nil
		end,
		getRequiresAppRestartOnMicAccessChange = function()
			return rawPolicy.requiresAppRestartOnMicAccessChange or false
		end,
		getRenameFriendsToConnections = function()
			if fFlagEnableFriendsRenamingForAll then
				return true
			end

			return rawPolicy.renameFriendsToConnections or false
		end,
		getShareSheetEnabled = function()
			return rawPolicy.shareSheetEnabled or false
		end,
		getShowAppIconSetting = function()
			return rawPolicy.ShowAppIconSetting or false
		end,
		getCanAccessTrustedContacts = function()
			return rawPolicy.canAccessTrustedContacts or false
		end,
		getExperienceDetailsNoticeType = function()
			return rawPolicy.experienceDetailsNoticeType or nil
		end,
		getRequiresOSAFriendingEducation = function()
			return rawPolicy.requiresOSAFriendingEducation or false
		end,
		getSocialGraphSyncEnabled = function()
			return rawPolicy.SocialGraphSyncEnabled or false
		end,
		getAccountDisambiguationDisabled = function()
			return rawPolicy.AccountDisambiguationDisabled or false
		end,
		getHasWebViewSupportForFAE = function()
			return rawPolicy.hasWebViewSupportForFAE or false
		end,
		getLinkedAuthEndpointsEnabled = function()
			return rawPolicy.LinkedAuthEndpointsEnabled or false
		end,
		getLinkingPlatform = function()
			return rawPolicy.LinkingPlatform or nil
		end,
		getUsePaymentPlatformMilkyWayStore = function()
			if fFlagEnableMilkyWayPaymentsPlatformV2 then
				return rawPolicy.usePaymentPlatformMilkyWayStore or false
			end

			return false
		end,
		getScreentimeMoreTimeOptionEnabled = function()
			if fFlagEnableScreentimeMoreTimeOption then
				return rawPolicy.ScreentimeMoreTimeOptionEnabled or false
			end

			return false
		end,
		getDisablePremiumEntrypoint = function()
			if defineFastFlag6 then
				return rawPolicy.DisablePremiumEntrypoint or rawPolicy.DisablePremiumEntryPoint or false
			end

			return false
		end,
		getDisableBlackbirdEntrypoints = function()
			if defineFastFlag7 then
				return rawPolicy.DisableBlackbirdEntrypoints or false
			end

			return false
		end,
		getEnableGiftcardsWithRedeem = function()
			if defineFastFlag8 then
				return rawPolicy.EnableGiftcardsWithRedeem or false
			end

			return false
		end,
		getGiftCardSourceRefOverride = function()
			return rawPolicy.GiftCardSourceRefOverride or ""
		end,
		getSignupCheckboxDisabled = function()
			if defineFastFlag5 then
				return rawPolicy.DisableSignupCheckbox or false
			end

			return false
		end,
		getShouldShowFaceIDText = function()
			if fFlagEnableFaceIDTextOnAddAuthMethodPage then
				return rawPolicy.ShouldShowFaceIDText or false
			end

			return false
		end,
		getExcludeCrossDeviceSignIn = function()
			return rawPolicy.ExcludeCrossDeviceSignIn or false
		end,
		getExcludePasskeyLogin = function()
			return rawPolicy.ExcludePasskeyLogin or false
		end,
		getExcludeExternalIdentityLogin = function(): boolean
			return rawPolicy.ExcludeExternalIdentityLogin ~= false
		end,
		getExternalIdentityAppleUsesBrowserSignIn = function()
			return rawPolicy.ExternalIdentityAppleUsesBrowserSignIn or false
		end,
		getExcludeExternalIdentityOtherSignInOptions = function(): boolean
			return rawPolicy.ExcludeExternalIdentityOtherSignInOptions ~= false
		end,
		getExcludeUsernamePasswordSignIn = function()
			return rawPolicy.ExcludeUsernamePasswordSignIn or false
		end,
		getExcludeEmailPasswordSignIn = function()
			return rawPolicy.ExcludeEmailPasswordSignIn or false
		end,
		getExcludePhoneNumberPasswordSignIn = function()
			return rawPolicy.ExcludePhoneNumberPasswordSignIn or false
		end,
		getExcludeAccountSwitcher = function()
			return rawPolicy.ExcludeAccountSwitcher or false
		end,
		getAccountSwitcherEnabled = function()
			return rawPolicy.AccountSwitcherEnabled or false
		end,
		getAccountPickerEnabled = function()
			return rawPolicy.AccountPickerEnabled or false
		end,
		getExcludeUsernameUpdateModeration = function()
			return rawPolicy.ExcludeUsernameUpdateModeration or false
		end,
		getMorePageExitButtonEnabled = fFlagEnableMorePageExitButtonSupport and function()
			return rawPolicy.MorePageExitButtonEnabled or false
		end or nil,
		getMoreGridDirectionalLayoutPreferred = fFlagEnableMorePageDirectionalLayoutRolloutFix and function()
			return rawPolicy.MoreGridDirectionalLayoutPreferred or false
		end or nil,
		getShouldUseDMCCALegalDisclosureInApp = function()
			return rawPolicy.ShouldUseDMCCALegalDisclosureInApp or false
		end,
		getCanAccessParty = function()
			if rawPolicy.CanAccessParty == nil then
				return true
			end

			return rawPolicy.CanAccessParty
		end,
		getRedeemTileEnabled = function()
			return rawPolicy.RedeemTileEnabled or false
		end,
		getMomentsFeatureList = function()
			if defineFastString4 and defineFastString4 ~= "" then
				return string.split(defineFastString4, ",")
			end

			if rawPolicy.MomentsFeatureList == nil then
				return {}
			end

			return rawPolicy.MomentsFeatureList
		end,
		getShowInContextPersonalizedRecommendationsMomentsFeed = function()
			return rawPolicy.showInContextPersonalizedRecommendationsMomentsFeed or false
		end,
		getSupportCenterEnabled = getFFlagEnableSupportCenter() and function()
			return rawPolicy.SupportCenterEnabled or false
		end or nil,
		getShouldUseVibrationInsteadOfHaptics = function()
			return rawPolicy.ShouldUseVibrationInsteadOfHaptics or false
		end,
		getRawPolicy = function()
			return rawPolicy
		end,
		getStickyShortcutBarEnabled = function()
			return rawPolicy.StickyShortcutBarEnabled or false
		end,
		getAccountType = fFlagEnableCoreContentAccountType and function()
			return rawPolicy.AccountType
		end or nil,
		getCoreContentBadgeText = fFlagEnableCoreContentBadge and function()
			return rawPolicy.CoreContentBadgeText
		end or nil,
		getShowUncheckedBadge = (fFlagEnableFlyoutUncheckedBadge or fFlagEnableNonFlyoutUncheckedBadge) and function()
			return rawPolicy.ShowUncheckedBadge
		end or nil,
		getShowUncheckedBadgeForAccountSwitcher = function()
			if getFFlagEnableAccountSwitcherUncheckedBadge() then
				return rawPolicy.ShowUncheckedBadge
			end

			return false
		end,
		getShowGameAgeRating = fFlagShowGameAgeRating and function()
			return rawPolicy.ShowGameAgeRating or false
		end or nil,
		getShowBadgeOver12 = not fFlagShowGameAgeRating and function()
			return rawPolicy.ShowBadgeOver12 or false
		end or nil,
		getDefaultTheme = fFlagDefaultKidsToDarkTheme and function()
			return rawPolicy.DefaultTheme
		end or nil,
		getDevicePreferencesPersistentPresenceVariant = fFlagMacMenuBarContentUpdates and function()
			return rawPolicy.DevicePreferencesPersistentPresenceVariant
		end or nil,
		getCancelSearchOnLostFocus = fFlagUsesCancelSearchAppPolicy and function()
			if rawPolicy.CancelSearchOnLostFocus == nil then
				return true
			end

			return rawPolicy.CancelSearchOnLostFocus
		end or nil,
		getCanViewBuild = fFlagAppNavMyStatsTab and function()
			return rawPolicy.CanViewBuild or false
		end or nil,
		getCanUseBuild = fFlagAppNavMyStatsTab and function()
			return rawPolicy.CanUseBuild or false
		end or nil,
		getShouldFullscreenElementsIgnoreSafeArea = function()
			return rawPolicy.ShouldFullscreenElementsIgnoreSafeArea or false
		end,
		getPinExperienceTargetDestination = fFlagAddPinExperienceTargetDestinationGUACPolicy and function()
			return rawPolicy.PinExperienceTargetDestination or "HomeScreen"
		end or nil,
		getFlyoutSidePanelEnabled = function()
			return rawPolicy.FlyoutSidePanelEnabled or false
		end,
		getLearnPlaceEnabled = function()
			if fFlagFlyoutGateLearnPlace then
				return rawPolicy.LearnPlaceEnabled or false
			end

			return true
		end
	}
end

return AppFeaturePolicies
