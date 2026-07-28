local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local ParentParent = script.Parent.Parent
local IsVRAppBuild = require(ParentParent.AppCommonLib).IsVRAppBuild
local Cryo = require(ParentParent.Cryo)
local Constants = require(ParentParent.UIBlox).App.Style.Constants
local v7 = Cryo.Dictionary.values(Constants.ThemeName)
local CrossPlayCapabilities = require(script.Parent.Enum.CrossPlayCapabilities)
local SharedFlags = require(ParentParent.SharedFlags)
local isSubjectToDesktopPolicies = SharedFlags.isSubjectToDesktopPolicies
local isRunningInStudio = require(ParentParent.AppCommonLib).isRunningInStudio
local GetFFlagUseVoiceExitBetaLanguage = SharedFlags.GetFFlagUseVoiceExitBetaLanguage
local GetFFlagDisableCDLQrCodeForMaquettes = SharedFlags.GetFFlagDisableCDLQrCodeForMaquettes
local GetFFlagUseEnablePremiumUserFeaturesAppPolicy = SharedFlags.GetFFlagUseEnablePremiumUserFeaturesAppPolicy
local GetFFlagLuafiedReportEntryPoints = SharedFlags.GetFFlagLuafiedReportEntryPoints
local GetFFlagEnableAbuseReport10ft = SharedFlags.GetFFlagEnableAbuseReport10ft
local GetFFlagUseExternalBrowserForAgeGuidelines10ft = SharedFlags.GetFFlagUseExternalBrowserForAgeGuidelines10ft
local GetFFlagEnableGateNotificationPreferencesTab = SharedFlags.GetFFlagEnableGateNotificationPreferencesTab
local GetFFlagEnableSupportCenter = SharedFlags.GetFFlagEnableSupportCenter
local FFlagLuaAppHomeVngAppUpsell = SharedFlags.FFlagLuaAppHomeVngAppUpsell
local FFlagVngAppUpsellPcLayout = SharedFlags.FFlagVngAppUpsellPcLayout
local FFlagFriendRequestNicknames = SharedFlags.FFlagFriendRequestNicknames
local FFlagLuaAppParentUpsellPolicy = SharedFlags.FFlagLuaAppParentUpsellPolicy
local FFlagRenameParentEmailForVerificationUpsell = SharedFlags.FFlagRenameParentEmailForVerificationUpsell
local GetFFlagSeamlessVoiceConsentToastPolicy = SharedFlags.GetFFlagSeamlessVoiceConsentToastPolicy
local GetFFlagEnableMultiPageSignup = SharedFlags.GetFFlagEnableMultiPageSignup
local GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup = SharedFlags.GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup
local FFlagEnableMicrosoftStorePaymentsPlatform = SharedFlags.FFlagEnableMicrosoftStorePaymentsPlatform
local FFlagEnableMilkyWayPaymentsPlatformV2 = SharedFlags.FFlagEnableMilkyWayPaymentsPlatformV2
local FFlagAppIaScrollAwayGuac = SharedFlags.FFlagAppIaScrollAwayGuac
local FFlagEnableScreentimeMoreTimeOption = SharedFlags.FFlagEnableScreentimeMoreTimeOption
local FFlagEnableFriendsRenamingForAll = SharedFlags.FFlagEnableFriendsRenamingForAll
local GetFFlagExpChatGuacChatDisabledReason = SharedFlags.GetFFlagExpChatGuacChatDisabledReason
local FFlagGuacCanRenderTransferOnProfile = SharedFlags.FFlagGuacCanRenderTransferOnProfile
local FFlagAuthSecExclusions = SharedFlags.FFlagAuthSecExclusions
local FFlagEnableFaceIDTextOnAddAuthMethodPage = SharedFlags.FFlagEnableFaceIDTextOnAddAuthMethodPage
local FFlagEnableMorePageExitButtonSupport = SharedFlags.FFlagEnableMorePageExitButtonSupport
local FFlagEnableMorePageDirectionalLayoutRolloutFix = SharedFlags.FFlagEnableMorePageDirectionalLayoutRolloutFix
local FFlagEnableUnifiedProductPurchaseFlow = SharedFlags.FFlagEnableUnifiedProductPurchaseFlow
local FFlagAEGIS2UseGuacToShowEnabledMessage = SharedFlags.FFlagAEGIS2UseGuacToShowEnabledMessage
local FFlagAEGIS2UseGuacToShowFAEUpsell = SharedFlags.FFlagAEGIS2UseGuacToShowFAEUpsell
local v42 = SharedFlags.GetFFlagMacMenuBarContentUpdates()
local v43 = game:DefineFastFlag("LuaAppEnableRecommendedCarouselForDesktop", false)
local v44 = game:DefineFastFlag("DisableWebViewSupportInStudio", false)
local FFlagUsesCancelSearchAppPolicy = SharedFlags.FFlagUsesCancelSearchAppPolicy
local v46 = game:DefineFastFlag("DebugUseLegacyCrossPlayApi", false)
local v47 = game:DefineFastString("DebugOverrideCrossPlaySettingsKey", "")
local v48 = game:DefineFastString("DebugOverrideCrossPlayQueryParam", "")
local v49 = game:DefineFastFlag("DebugCrossPlaySystemUi", false)
local v50 = game:DefineFastString("DebugOverrideCrossPlayUri", "")
local v51 = game:DefineFastFlag("GuacAppPolicyDisableSignupCheckbox", false)
local v52 = game:DefineFastFlag("FlyoutDisablePremiumEntrypoint1", false)
local v53 = game:DefineFastFlag("GuacDisableBlackbirdEntrypoints", false)
local v54 = game:DefineFastFlag("FlyoutEnableGiftcardsWithRedeem", false)
local v55 = game:DefineFastFlag("DebugForceShowIllegalContentReportingUI", false)
local FFlagEnableLeftNavOnConsole = SharedFlags.FFlagEnableLeftNavOnConsole
local FFlagExpChatUseGuacForFOMOUpsell = SharedFlags.FFlagExpChatUseGuacForFOMOUpsell
local FFlagExpChatUseGuacForCrossAgeChat = SharedFlags.FFlagExpChatUseGuacForCrossAgeChat
local FFlagEnableAndroidTvAppPolicies = SharedFlags.FFlagEnableAndroidTvAppPolicies
local FFlagSduiAppPolicyBindings = SharedFlags.FFlagSduiAppPolicyBindings
local FFlagGuacStickyShortcutBarEnabled = SharedFlags.FFlagGuacStickyShortcutBarEnabled
local FFlagEnableCoreContentAccountType = SharedFlags.FFlagEnableCoreContentAccountType
local FFlagEnableCoreContentBadge = SharedFlags.FFlagEnableCoreContentBadge
local FFlagEnableCoreContentThemeUseGuacForTokenOverrides = SharedFlags.FFlagEnableCoreContentThemeUseGuacForTokenOverrides
local FFlagEnableFlyoutUncheckedBadge = SharedFlags.FFlagEnableFlyoutUncheckedBadge
local FFlagEnableNonFlyoutUncheckedBadge = SharedFlags.FFlagEnableNonFlyoutUncheckedBadge
local GetFFlagEnableAccountSwitcherUncheckedBadge = SharedFlags.GetFFlagEnableAccountSwitcherUncheckedBadge
local FFlagAddTopBarPoliciesToUniversalPolicies = SharedFlags.FFlagAddTopBarPoliciesToUniversalPolicies
local FFlagDefaultKidsToDarkTheme = SharedFlags.FFlagDefaultKidsToDarkTheme
local FFlagLuaAppSupportDisablePlayableWhenLoading = SharedFlags.FFlagLuaAppSupportDisablePlayableWhenLoading
local FFlagAppChatRenameGuacPolicyEnabled = SharedFlags.FFlagAppChatRenameGuacPolicyEnabled
local FFlagAppNavMyStatsTab = SharedFlags.FFlagAppNavMyStatsTab

game:DefineFastFlag("BehaviorCollectionControlEnabled", false)
game:DefineFastFlag("LuaAppPromotionalEmailsCheckboxEnabledInAppPolicy", false)

local GetFFlagNotificationsComplianceShouldRestrictStream = SharedFlags.GetFFlagNotificationsComplianceShouldRestrictStream

local function AppFeaturePolicies(p1) -- line: 91
	-- upvalues: IsVRAppBuild (copy), v43 (copy), isSubjectToDesktopPolicies (copy), FFlagAppIaScrollAwayGuac (copy), FFlagEnableLeftNavOnConsole (copy), GuiService (copy), isRunningInStudio (copy), v44 (copy), GetFFlagLuafiedReportEntryPoints (copy), GetFFlagEnableAbuseReport10ft (copy), GetFFlagUseVoiceExitBetaLanguage (copy), GetFFlagSeamlessVoiceConsentToastPolicy (copy), GetFFlagExpChatGuacChatDisabledReason (copy), FFlagAEGIS2UseGuacToShowEnabledMessage (copy), FFlagAEGIS2UseGuacToShowFAEUpsell (copy), FFlagExpChatUseGuacForFOMOUpsell (copy), FFlagExpChatUseGuacForCrossAgeChat (copy), FFlagAppChatRenameGuacPolicyEnabled (copy), GetFFlagDisableCDLQrCodeForMaquettes (copy), Cryo (copy), v7 (copy), v46 (copy), v49 (copy), v50 (copy), CrossPlayCapabilities (copy), v47 (copy), v48 (copy), GetFFlagUseEnablePremiumUserFeaturesAppPolicy (copy), GetFFlagUseExternalBrowserForAgeGuidelines10ft (copy), FFlagGuacCanRenderTransferOnProfile (copy), GetFFlagEnableGateNotificationPreferencesTab (copy), UserInputService (copy), FFlagLuaAppHomeVngAppUpsell (copy), FFlagVngAppUpsellPcLayout (copy), FFlagFriendRequestNicknames (copy), FFlagLuaAppParentUpsellPolicy (copy), FFlagLuaAppSupportDisablePlayableWhenLoading (copy), GetFFlagNotificationsComplianceShouldRestrictStream (copy), v55 (copy), FFlagRenameParentEmailForVerificationUpsell (copy), FFlagEnableAndroidTvAppPolicies (copy), GetFFlagEnableMultiPageSignup (copy), GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup (copy), FFlagEnableMicrosoftStorePaymentsPlatform (copy), FFlagEnableFriendsRenamingForAll (copy), FFlagEnableMilkyWayPaymentsPlatformV2 (copy), FFlagEnableScreentimeMoreTimeOption (copy), v52 (copy), v53 (copy), v54 (copy), v51 (copy), FFlagEnableFaceIDTextOnAddAuthMethodPage (copy), FFlagAuthSecExclusions (copy), FFlagEnableMorePageExitButtonSupport (copy), FFlagEnableMorePageDirectionalLayoutRolloutFix (copy), FFlagEnableUnifiedProductPurchaseFlow (copy), GetFFlagEnableSupportCenter (copy), FFlagSduiAppPolicyBindings (copy), FFlagGuacStickyShortcutBarEnabled (copy), FFlagEnableCoreContentAccountType (copy), FFlagEnableCoreContentBadge (copy), FFlagEnableCoreContentThemeUseGuacForTokenOverrides (copy), FFlagEnableFlyoutUncheckedBadge (copy), FFlagEnableNonFlyoutUncheckedBadge (copy), GetFFlagEnableAccountSwitcherUncheckedBadge (copy), FFlagAddTopBarPoliciesToUniversalPolicies (copy), FFlagDefaultKidsToDarkTheme (copy), v42 (copy), FFlagUsesCancelSearchAppPolicy (copy), FFlagAppNavMyStatsTab (copy)
	local function getVRDefaultPolicy(p2, p3) -- line: 92
		-- upvalues: p1 (copy), IsVRAppBuild (copy)
		if p1[p2] ~= nil then
			return p1[p2]
		end

		if IsVRAppBuild() then
			return p3
		end

		return not p3
	end

	return {
		getFriendFinder = function() -- line: 103
			-- upvalues: p1 (copy)
			return p1.FriendFinder or false
		end,
		getGameDetailsMorePage = function() -- line: 106
			-- upvalues: p1 (copy)
			return p1.GameDetailsMorePage or false
		end,
		getGameDetailsSubtitle = function() -- line: 109
			-- upvalues: p1 (copy)
			return p1.GameDetailsSubtitle or false
		end,
		getShowGlobalCounters = function() -- line: 112
			-- upvalues: p1 (copy)
			return p1.GameDetailsShowGlobalCounters or false
		end,
		getGameDetailsPlayWithFriends = function() -- line: 115
			-- upvalues: p1 (copy)
			return p1.GameDetailsPlayWithFriends or false
		end,
		getGameInfoList = function() -- line: 118
			-- upvalues: p1 (copy)
			return p1.GameInfoList or false
		end,
		getGamePlaysAndRatings = function() -- line: 121
			-- upvalues: p1 (copy)
			return p1.GamePlaysAndRatings or false
		end,
		getNotifications = function() -- line: 124
			-- upvalues: p1 (copy)
			return p1.Notifications or false
		end,
		getRecommendedGames = function() -- line: 127
			-- upvalues: v43 (copy), p1 (copy), isSubjectToDesktopPolicies (copy)
			if v43 then
				return p1.RecommendedGames or false
			end

			if isSubjectToDesktopPolicies() then
				return false
			end

			return p1.RecommendedGames or false
		end,
		getSearchBar = function() -- line: 137
			-- upvalues: p1 (copy)
			return p1.SearchBar or false
		end,
		getMorePageContent = function() -- line: 140
			-- upvalues: p1 (copy)
			return p1.MorePageContent
		end,
		getAboutPageType = function() -- line: 143
			-- upvalues: p1 (copy)
			return p1.AboutPageType or "CJVAbout"
		end,
		getSettingsPageType = function() -- line: 146
			-- upvalues: p1 (copy)
			return p1.SettingsPageType or "Settings"
		end,
		getSocialLinks = function() -- line: 149
			-- upvalues: p1 (copy)
			return p1.SocialLinks or false
		end,
		getSocialGroupLinks = function() -- line: 152
			-- upvalues: p1 (copy)
			return p1.SocialGroupLinks or false
		end,
		getCommunityLinksEnabled = function() -- line: 155
			-- upvalues: p1 (copy)
			return p1.CommunityLinksEnabled or false
		end,
		getGameInfoShowBadges = function() -- line: 158
			-- upvalues: p1 (copy)
			return p1.GameInfoShowBadges or false
		end,
		getGameInfoShowCreated = function() -- line: 161
			-- upvalues: p1 (copy)
			return p1.GameInfoShowCreated or false
		end,
		getGameInfoShowGamepasses = function() -- line: 164
			-- upvalues: p1 (copy)
			return p1.GameInfoShowGamepasses or false
		end,
		getGameInfoShowGenre = function() -- line: 167
			-- upvalues: p1 (copy)
			return p1.GameInfoShowGenre or false
		end,
		getGameInfoShowSubgenre = function() -- line: 170
			-- upvalues: p1 (copy)
			return p1.GameInfoShowSubgenre or false
		end,
		getGameInfoShowMaxPlayers = function() -- line: 173
			-- upvalues: p1 (copy)
			return p1.GameInfoShowMaxPlayers or false
		end,
		getGameInfoShowServers = function() -- line: 176
			-- upvalues: p1 (copy)
			return p1.GameInfoShowServers or false
		end,
		getGameInfoShowUpdated = function() -- line: 179
			-- upvalues: p1 (copy)
			return p1.GameInfoShowUpdated or false
		end,
		getGameInfoShowAgeRecommendation = function() -- line: 182
			-- upvalues: p1 (copy)
			if p1.GameInfoShowAgeRecommendation == nil then
				return true
			end

			return p1.GameInfoShowAgeRecommendation
		end,
		getGameInfoShowVoiceAndChatFeatures = function() -- line: 188
			-- upvalues: p1 (copy)
			if p1.GameInfoShowVoiceAndChatFeatures == nil then
				return true
			end

			return p1.GameInfoShowVoiceAndChatFeatures
		end,
		getSiteMessageBanner = function() -- line: 194
			-- upvalues: p1 (copy)
			return p1.SiteMessageBanner or false
		end,
		getAlertRateLimit = function() -- line: 197
			-- upvalues: p1 (copy)
			return p1.AlertRateLimit or 300
		end,
		getSearchAutoComplete = function() -- line: 201
			-- upvalues: p1 (copy)
			return p1.SearchAutoComplete or false
		end,
		getShowStudioCTA = function() -- line: 204
			-- upvalues: p1 (copy)
			return p1.ShowStudioCTA or false
		end,
		getAppIaScrollAwayEnabled = if not FFlagAppIaScrollAwayGuac then nil else function() -- line: 208
			-- upvalues: p1 (copy)
			return p1.AppIaScrollAwayEnabled or false
		end,
		getUseOmniRecommendation = function() -- line: 212
			-- upvalues: p1 (copy)
			if p1.UseOmniRecommendation == nil then
				return true
			end

			return p1.UseOmniRecommendation
		end,
		getUseWidthBasedFormFactorRule = function() -- line: 220
			-- upvalues: p1 (copy)
			return p1.UseWidthBasedFormFactorRule or false
		end,
		getShowYouTubeAgeAlert = function() -- line: 223
			-- upvalues: p1 (copy)
			if p1.ShowYouTubeAgeAlert == nil then
				return true
			end

			return p1.ShowYouTubeAgeAlert
		end,
		getShowVideoThumbnails = function() -- line: 229
			-- upvalues: p1 (copy)
			return p1.ShowVideoThumbnails or false
		end,
		getHomeIcon = function() -- line: 232
			-- upvalues: p1 (copy)
			return p1.HomeIcon or "LuaApp/icons/ic-roblox-close"
		end,
		getGameInfoListShowRNVDeveloper = function() -- line: 235
			-- upvalues: p1 (copy)
			return p1.GameInfoListShowRNVDeveloper or false
		end,
		getGameInfoListDeveloper = function() -- line: 238
			-- upvalues: p1 (copy)
			return p1.GameInfoListDeveloper or false
		end,
		getShowDisplayName = function() -- line: 241
			-- upvalues: p1 (copy)
			if p1.ShowDisplayName == nil then
				return true
			end

			return p1.ShowDisplayName
		end,
		getShowAlias = function() -- line: 247
			-- upvalues: p1 (copy)
			if p1.ShowUserAlias == nil then
				return true
			end

			return p1.ShowUserAlias
		end,
		getCatalogReportingDisabled = function() -- line: 253
			-- upvalues: p1 (copy)
			return p1.CatalogReportingDisabled or false
		end,
		getGameReportingDisabled = function() -- line: 256
			-- upvalues: p1 (copy)
			return p1.GameReportingDisabled or false
		end,
		getGamesPageCreationCenterTitle = function() -- line: 259
			-- upvalues: p1 (copy)
			return p1.GamesPageCreationCenterTitle or false
		end,
		shouldUseExternalBrowserForDisclaimerLinks = function() -- line: 262
			-- upvalues: p1 (copy)
			return p1.UseExternalBrowserForDisclaimerLinks or false
		end,
		shouldUseExternalBrowserForMorePageItem = function() -- line: 265
			-- upvalues: p1 (copy)
			return p1.UseExternalBrowserForMoreLinks or false
		end,
		getCatalogShow3dView = function() -- line: 268
			-- upvalues: p1 (copy)
			return p1.CatalogShow3dView or false
		end,
		getItemDetailsFullView = function() -- line: 271
			-- upvalues: p1 (copy)
			return p1.ItemDetailsFullView or false
		end,
		getCatalogCommunityCreations = function() -- line: 274
			-- upvalues: p1 (copy)
			return p1.CatalogCommunityCreations or false
		end,
		getCatalogPremiumCategory = function() -- line: 277
			-- upvalues: p1 (copy)
			return p1.CatalogPremiumCategory or false
		end,
		getShowCatalogPremiumContent = function() -- line: 280
			-- upvalues: p1 (copy)
			return p1.CatalogPremiumContent or false
		end,
		getRobloxCreatedItemsCreatedByLuobu = function() -- line: 283
			-- upvalues: p1 (copy)
			if p1.RobloxCreatedItemsCreatedByLuobu == nil then
				return true
			end

			return p1.RobloxCreatedItemsCreatedByLuobu
		end,
		getHomePageFriendSection = function() -- line: 289
			-- upvalues: p1 (copy)
			return p1.HomePageFriendSection or false
		end,
		getHomePageProfileLink = function() -- line: 292
			-- upvalues: p1 (copy)
			return p1.HomePageProfileLink or false
		end,
		getPurchasePromptIncludingWarning = function() -- line: 295
			-- upvalues: p1 (copy)
			if p1.PurchasePromptIncludingWarning == nil then
				return true
			end

			return p1.PurchasePromptIncludingWarning
		end,
		getCheckUserAgreementsUpdatedOnLogin = function() -- line: 301
			-- upvalues: p1 (copy)
			if p1.CheckUserAgreementsUpdatedOnLogin == nil then
				return true
			end

			return p1.CheckUserAgreementsUpdatedOnLogin
		end,
		getAddUserAgreementIdsToSignupRequest = function() -- line: 307
			-- upvalues: p1 (copy)
			return p1.AddUserAgreementIdsToSignupRequest or false
		end,
		RequireExplicitVoiceConsent = function() -- line: 310
			-- upvalues: p1 (copy)
			return p1.RequireExplicitVoiceConsent or false
		end,
		getRequireExplicitAvatarVideoConsent = function() -- line: 313
			-- upvalues: p1 (copy)
			return p1.RequireExplicitAvatarVideoConsent or false
		end,
		getShowVoiceUpsellV2 = function() -- line: 316
			-- upvalues: p1 (copy)
			return p1.ShowVoiceUpsellV2 or false
		end,
		getShouldShowGroupsTile = function() -- line: 319
			-- upvalues: p1 (copy)
			return p1.ShouldShowGroupsTile or false
		end,
		useLuobuAuthentication = function() -- line: 322
			-- upvalues: p1 (copy)
			return p1.UseLuobuAuthentication or false
		end,
		useWechatQQAuthentication = function() -- line: 325
			-- upvalues: p1 (copy)
			return p1.UseWechatQQAuthentication or false
		end,
		useMSDKWebAuthentication = function() -- line: 328
			-- upvalues: p1 (copy)
			return p1.UseMSDKWebAuthentication or false
		end,
		getQrFriendingEnabled = function() -- line: 331
			-- upvalues: p1 (copy)
			return p1.QrFriendingEnabled or false
		end,
		getShouldShowCameraPermissionInAgreementsPrompt = function() -- line: 334
			-- upvalues: p1 (copy)
			return p1.ShouldShowCameraPermissionInAgreementsPrompt or false
		end,
		getExperienceInviteShareLinkEnabled = function() -- line: 337
			-- upvalues: p1 (copy)
			return p1.ExperienceInviteShareLinkEnabled or false
		end,
		getCsatSurveyRestrictTextInput = function() -- line: 340
			-- upvalues: p1 (copy)
			return p1.CsatSurveyRestrictTextInput or false
		end,
		useGridPageLayout = function() -- line: 343
			-- upvalues: IsVRAppBuild (copy), p1 (copy), isSubjectToDesktopPolicies (copy)
			if IsVRAppBuild() then
				if p1.UseGridPageLayout ~= nil then
					return p1.UseGridPageLayout
				end

				if IsVRAppBuild() then
					return true
				end

				return false
			end

			if p1.UseGridPageLayout == nil then
				return isSubjectToDesktopPolicies()
			end

			return p1.UseGridPageLayout
		end,
		usePhoneSearchDiscoverEntry = function() -- line: 354
			-- upvalues: p1 (copy), isSubjectToDesktopPolicies (copy)
			if p1.UsePhoneSearchDiscoverEntry == nil then
				return not isSubjectToDesktopPolicies()
			end

			return p1.UsePhoneSearchDiscoverEntry
		end,
		getShouldSystemBarUsuallyBePresent = function() -- line: 361
			-- upvalues: IsVRAppBuild (copy), p1 (copy), FFlagEnableLeftNavOnConsole (copy), GuiService (copy)
			if IsVRAppBuild() then
				if p1.ShouldSystemBarUsuallyBePresentForVR ~= nil then
					return p1.ShouldSystemBarUsuallyBePresentForVR
				end

				if IsVRAppBuild() then
					return true
				end

				return false
			end

			if FFlagEnableLeftNavOnConsole and GuiService:IsTenFootInterface() then
				return true
			end

			return p1.ShouldSystemBarUsuallyBePresent or false
		end,
		getContactImporterEnabled = function() -- line: 374
			-- upvalues: isSubjectToDesktopPolicies (copy), p1 (copy)
			if isSubjectToDesktopPolicies() then
				return false
			end

			return p1.ContactImporterEnabled or false
		end,
		getShouldShowSettingsPermissionsAdditionalInstructions = function() -- line: 382
			-- upvalues: p1 (copy)
			return p1.shouldShowSettingsPermissionsAdditionalInstructions or false
		end,
		getUseVRFTUXPanel = function() -- line: 386
			-- upvalues: p1 (copy), IsVRAppBuild (copy)
			if p1.UseVRFTUXPanel ~= nil then
				return p1.UseVRFTUXPanel
			end

			if IsVRAppBuild() then
				return true
			end

			return false
		end,
		getWebViewSupport = function() -- line: 389
			-- upvalues: isRunningInStudio (copy), v44 (copy), p1 (copy), IsVRAppBuild (copy)
			if isRunningInStudio() then
				if v44 then
					return false
				end

				return true
			end

			if p1.EnableWebViewSupport ~= nil then
				return p1.EnableWebViewSupport
			end

			if IsVRAppBuild() then
				return false
			end

			return true
		end,
		getUseLuafiedReportFlow = function() -- line: 400
			-- upvalues: IsVRAppBuild (copy), GetFFlagLuafiedReportEntryPoints (copy), p1 (copy), GetFFlagEnableAbuseReport10ft (copy)
			if IsVRAppBuild() and GetFFlagLuafiedReportEntryPoints() then
				if p1.UseLuafiedReportFlow ~= nil then
					return p1.UseLuafiedReportFlow
				end

				if IsVRAppBuild() then
					return true
				end

				return false
			end

			if GetFFlagEnableAbuseReport10ft() then
				return p1.UseLuafiedReportFlow or false
			end

			return nil
		end,
		getThrottleFramerate = function() -- line: 409
			-- upvalues: p1 (copy), IsVRAppBuild (copy)
			if p1.ThrottleFramerate ~= nil then
				return p1.ThrottleFramerate
			end

			if IsVRAppBuild() then
				return false
			end

			return true
		end,
		getUseRoundedCorners = function() -- line: 412
			-- upvalues: IsVRAppBuild (copy), p1 (copy)
			if IsVRAppBuild() then
				if p1.UseRoundedCorners ~= nil then
					return p1.UseRoundedCorners
				end

				if IsVRAppBuild() then
					return true
				end

				return false
			end

			return false
		end,
		getGameInfoShowChatFeatures = function() -- line: 419
			-- upvalues: GetFFlagUseVoiceExitBetaLanguage (copy), p1 (copy)
			if GetFFlagUseVoiceExitBetaLanguage() then
				return p1.GameInfoShowChatFeatures or false
			end

			return false
		end,
		getDisplayCheckboxInVoiceConsent = function() -- line: 425
			-- upvalues: GetFFlagSeamlessVoiceConsentToastPolicy (copy), p1 (copy)
			if GetFFlagSeamlessVoiceConsentToastPolicy() then
				return p1.DisplayCheckboxInVoiceConsent or false
			end

			return false
		end,
		getExperienceChatAvailability = function() -- line: 431
			-- upvalues: GetFFlagExpChatGuacChatDisabledReason (copy), p1 (copy)
			if GetFFlagExpChatGuacChatDisabledReason() then
				return p1.ExperienceChatAvailability or "unknown"
			end

			return "unknown"
		end,
		getInCommsRegionBubble = function() -- line: 437
			-- upvalues: FFlagAEGIS2UseGuacToShowEnabledMessage (copy), p1 (copy)
			if FFlagAEGIS2UseGuacToShowEnabledMessage then
				return p1.InCommsRegionBubble or false
			end

			return false
		end,
		getShowInExpFAEUpsell = function() -- line: 443
			-- upvalues: FFlagAEGIS2UseGuacToShowFAEUpsell (copy), p1 (copy)
			if FFlagAEGIS2UseGuacToShowFAEUpsell then
				return p1.ShowInExpFAEUpsell or false
			end

			return false
		end,
		getShowFOMOUpsell = function() -- line: 449
			-- upvalues: FFlagExpChatUseGuacForFOMOUpsell (copy), p1 (copy)
			if FFlagExpChatUseGuacForFOMOUpsell then
				return p1.ShowFOMOUpsell or false
			end

			return false
		end,
		getShowCrossAgeChat = function() -- line: 456
			-- upvalues: FFlagExpChatUseGuacForCrossAgeChat (copy), p1 (copy)
			if FFlagExpChatUseGuacForCrossAgeChat then
				return p1.ShowCrossAgeExpChat or false
			end

			return false
		end,
		getCanSeeChatTerminology = function() -- line: 463
			-- upvalues: FFlagAppChatRenameGuacPolicyEnabled (copy), p1 (copy)
			if FFlagAppChatRenameGuacPolicyEnabled then
				return p1.canSeeChatTerminology or false
			end

			return false
		end,
		getAllowCameraMovements = function() -- line: 470
			-- upvalues: p1 (copy), IsVRAppBuild (copy)
			if p1.AllowCameraMovements ~= nil then
				return p1.AllowCameraMovements
			end

			if IsVRAppBuild() then
				return false
			end

			return true
		end,
		getShouldSkipAvatarLandingPage = function() -- line: 473
			-- upvalues: p1 (copy), IsVRAppBuild (copy)
			if p1.ShouldSkipAvatarLandingPage ~= nil then
				return p1.ShouldSkipAvatarLandingPage
			end

			if IsVRAppBuild() then
				return true
			end

			return false
		end,
		getShowPassesOnExperienceDetails = function() -- line: 476
			-- upvalues: p1 (copy)
			return p1.ShowPassesOnExperienceDetails or false
		end,
		getDisableCDLQrCodeForMaquettes = function() -- line: 479
			-- upvalues: GetFFlagDisableCDLQrCodeForMaquettes (copy), p1 (copy)
			if GetFFlagDisableCDLQrCodeForMaquettes() then
				return p1.DisableCDLQrCodeForMaquettes
			end

			return false
		end,
		getDisableIAPEntryPoint = function() -- line: 486
			-- upvalues: p1 (copy)
			return p1.DisableIAPEntryPoint or false
		end,
		getEnforceAgeRestrictedLogin = function() -- line: 489
			-- upvalues: p1 (copy)
			return p1.EnforceAgeRestrictedLogin or false
		end,
		getUrlAuthRoutes = function() -- line: 492
			-- upvalues: p1 (copy)
			local v79 = p1.Routes or {}

			if v79 then
				return v79.auth or {}
			end

			return {}
		end,
		getShowDisconnectButton = function() -- line: 501
			-- upvalues: p1 (copy)
			return p1.ShowDisconnectButton or false
		end,
		getUseSingleSignOn = function() -- line: 504
			-- upvalues: isRunningInStudio (copy), p1 (copy)
			if isRunningInStudio() then
				return false
			end

			return p1.UseSingleSignOn or false
		end,
		getGridCarouselSeeAllTilesEnabled = function() -- line: 511
			-- upvalues: p1 (copy)
			return p1.UseGridCarouselSeeAllTiles or false
		end,
		getSearchWithoutNavigatingEnabled = function() -- line: 514
			-- upvalues: FFlagEnableLeftNavOnConsole (copy), GuiService (copy), p1 (copy)
			if FFlagEnableLeftNavOnConsole and GuiService:IsTenFootInterface() then
				return false
			end

			return p1.SingleSearchPageNoNavigation or false
		end,
		getGameListCategoryScrollListEnabled = function() -- line: 520
			-- upvalues: p1 (copy)
			return p1.GetGamesListCategoryTabs or false
		end,
		getForceTheme = function() -- line: 523
			-- upvalues: Cryo (copy), v7 (copy), p1 (copy)
			local v80 = Cryo.List.map(v7, function(p4) -- line: 524
				return p4:lower()
			end)

			if p1.ForceTheme and Cryo.List.find(v80, p1.ForceTheme:lower()) then
				return p1.ForceTheme
			end

			return nil
		end,
		enableExperienceDetailsPanel = function() -- line: 533
			-- upvalues: p1 (copy)
			return p1.EnableExperienceDetailsPanel or false
		end,
		getDisableRegularLogin = function() -- line: 536
			-- upvalues: p1 (copy)
			return not p1.EnableWebViewSupport and (not p1.EnableRegularLoginWithoutWebViewSupport or false)
		end,
		getAllowPlatformAccountSwitching = function() -- line: 539
			-- upvalues: p1 (copy)
			return p1.AllowPlatformAccountSwitching or false
		end,
		useLegacyCrossPlayApi = function() -- line: 542
			-- upvalues: v46 (copy), p1 (copy)
			return v46 or (p1.useLegacyCrossPlayApi or false)
		end,
		useCrossPlaySystemUi = function() -- line: 545
			-- upvalues: v49 (copy), p1 (copy)
			return v49 or (p1.useCrossPlaySystemUi or false)
		end,
		getCrossPlayUri = function() -- line: 548
			-- upvalues: v50 (copy), p1 (copy)
			if v50 ~= "" then
				return v50
			end

			return p1.crossPlayUri or ""
		end,
		getCrossPlayCapabilities = function() -- line: 555
			-- upvalues: Cryo (copy), p1 (copy), CrossPlayCapabilities (copy)
			return Cryo.List.foldLeft(p1.crossPlayCapabilities or {}, function(p5, p6) -- line: 556
				-- upvalues: Cryo (copy), CrossPlayCapabilities (copy)
				if Cryo.List.find(p5, p6) then
					return p5
				end

				return Cryo.List.join(p5, { CrossPlayCapabilities[p6] })
			end, {})
		end,
		getCrossPlaySettingsKey = function() -- line: 566
			-- upvalues: v47 (copy), p1 (copy)
			if v47 ~= "" then
				return v47
			end

			return p1.crossPlaySettingsKey or ""
		end,
		getCrossPlayQueryParam = function() -- line: 573
			-- upvalues: v48 (copy), p1 (copy)
			if v48 ~= "" then
				return v48
			end

			return p1.crossPlayQueryParam or ""
		end,
		getPromotionalEmailsCheckboxEnabled = function() -- line: 580
			-- upvalues: p1 (copy)
			if game:GetFastFlag("LuaAppPromotionalEmailsCheckboxEnabledInAppPolicy") then
				return p1.PromotionalEmailsCheckboxEnabled or false
			end

			return false
		end,
		getPromotionalEmailsOptInByDefault = function() -- line: 587
			-- upvalues: p1 (copy)
			if game:GetFastFlag("LuaAppPromotionalEmailsCheckboxEnabledInAppPolicy") then
				return p1.PromotionalEmailsOptInByDefault or false
			end

			return false
		end,
		getSupportsOverscan = function() -- line: 594
			-- upvalues: p1 (copy)
			return p1.SupportsOverscan or false
		end,
		getPlatformDisplayName = function() -- line: 597
			-- upvalues: p1 (copy)
			return p1.platformDisplayName or ""
		end,
		getPlatformAccountName = function() -- line: 600
			-- upvalues: p1 (copy)
			return p1.platformAccountName or nil
		end,
		getSupportsProfileSwitching = function() -- line: 603
			-- upvalues: p1 (copy)
			return p1.supportsProfileSwitching or false
		end,
		getMountAllOmniFeedItems = function() -- line: 606
			-- upvalues: p1 (copy)
			return p1.mountAllOmniFeedItems or false
		end,
		getFriendCodeQrCodeScannerEnabled = function() -- line: 609
			-- upvalues: p1 (copy)
			return p1.FriendCodeQrCodeScannerEnabled or false
		end,
		getInviteFriendsDisabled = function() -- line: 612
			-- upvalues: p1 (copy)
			return p1.InviteFriendsDisabled or false
		end,
		getRealNamesInDisplayNamesEnabled = function() -- line: 615
			-- upvalues: p1 (copy)
			return p1.RealNamesInDisplayNamesEnabled or false
		end,
		getProfileShareLinkEnabled = function() -- line: 618
			-- upvalues: p1 (copy)
			return p1.ProfileShareLinkEnabled
		end,
		getProfileCopyLinkEnabled = function() -- line: 621
			-- upvalues: p1 (copy)
			return p1.ProfileCopyLinkEnabled
		end,
		getEnablePremiumUserFeatures = function() -- line: 624
			-- upvalues: GetFFlagUseEnablePremiumUserFeaturesAppPolicy (copy), p1 (copy)
			if GetFFlagUseEnablePremiumUserFeaturesAppPolicy() then
				return p1.EnablePremiumUserFeatures or false
			end

			return nil
		end,
		getEnableDualLogin = function() -- line: 630
			-- upvalues: p1 (copy)
			return p1.enableDualLogin or false
		end,
		getUseExternalBrowserForAgeGuidelines = function() -- line: 634
			-- upvalues: GetFFlagUseExternalBrowserForAgeGuidelines10ft (copy), p1 (copy)
			if GetFFlagUseExternalBrowserForAgeGuidelines10ft() then
				return p1.UseExternalBrowserForAgeGuidelines or false
			end

			return nil
		end,
		getEnableHomePageAgeBlock = function() -- line: 641
			-- upvalues: p1 (copy)
			return p1.EnableHomePageAgeBlock or false
		end,
		getEnableUAppAccessBlock = function() -- line: 644
			-- upvalues: p1 (copy)
			return p1.EnableUAppAccessBlock or false
		end,
		getUAppBlockPageTextMapKey = function() -- line: 647
			-- upvalues: p1 (copy)
			return p1.UAppBlockPageTextMapKey or nil
		end,
		getUAppBlockPageShouldDisableLogOut = function() -- line: 650
			-- upvalues: p1 (copy)
			return p1.UAppBlockPageShouldDisableLogOut or nil
		end,
		getContactsToastEnabled = function() -- line: 653
			-- upvalues: p1 (copy)
			return p1.ContactsToastEnabled or false
		end,
		getEnableProfileQrCode = function() -- line: 656
			-- upvalues: p1 (copy)
			return p1.EnableProfileQrCode or false
		end,
		getCanRenderTransferOnProfile = function() -- line: 659
			-- upvalues: FFlagGuacCanRenderTransferOnProfile (copy), p1 (copy)
			if FFlagGuacCanRenderTransferOnProfile then
				return p1.CanRenderTransferOnProfile or false
			end

			return false
		end,
		getShowVNGLoginWithExistingAccountQuickLoginButton = function() -- line: 665
			-- upvalues: p1 (copy)
			return p1.ShowVNGLoginWithExistingAccountQuickLoginButton or false
		end,
		getShowVNGAge12Badge = function() -- line: 668
			-- upvalues: p1 (copy)
			return p1.ShowVNGAge12Badge or false
		end,
		getShowBrazilContentRatingLogo = function() -- line: 671
			-- upvalues: p1 (copy)
			return p1.ShowBrazilContentRatingLogo or false
		end,
		getUseVNGUserAgreementPopup = function() -- line: 674
			-- upvalues: p1 (copy)
			return p1.UseVNGUserAgreementPopup or false
		end,
		getRedirectBuyRobuxToVNG = function() -- line: 677
			-- upvalues: p1 (copy)
			return p1.RedirectBuyRobuxToVNG or false
		end,
		getShowVNGTosForRobuxUpsell = function() -- line: 680
			-- upvalues: p1 (copy)
			return p1.ShowVNGTosForRobuxUpsell or false
		end,
		getBlockVNGU12SignUpOnClientSide = function() -- line: 683
			-- upvalues: p1 (copy)
			return p1.BlockVNGU12SignUpOnClientSide or false
		end,
		getUseAgeInput = function() -- line: 686
			-- upvalues: p1 (copy)
			return p1.UseAgeInput or false
		end,
		getLoginUsernameOnly = function() -- line: 689
			-- upvalues: p1 (copy)
			return p1.LoginUsernameOnly or false
		end,
		getDisableEmailOTPLogin = function() -- line: 692
			-- upvalues: p1 (copy)
			return p1.DisableEmailOTPLogin or false
		end,
		getDisableLoginForgotButton = function() -- line: 695
			-- upvalues: p1 (copy)
			return p1.DisableLoginForgotButton or false
		end,
		getDisableLogOutEmailUpsell = function() -- line: 698
			-- upvalues: p1 (copy)
			return p1.DisableLogOutEmailUpsell or false
		end,
		getVerifiedSignupCountry = function() -- line: 701
			-- upvalues: p1 (copy)
			return p1.verifiedSignupCountry or false
		end,
		getParentalConsentAgreementId = function() -- line: 705
			-- upvalues: p1 (copy)
			return p1.parentalConsentAgreementId or ""
		end,
		getIsStrictComplianceEnabled = function() -- line: 709
			-- upvalues: p1 (copy)
			return p1.isStrictComplianceEnabled or false
		end,
		getUseKoreaKISAUserAgreementPopup = function() -- line: 713
			-- upvalues: p1 (copy)
			return p1.useKoreaKISAUserAgreementPopup or false
		end,
		getEnableNotificationPreferencesPage = function() -- line: 717
			-- upvalues: GetFFlagEnableGateNotificationPreferencesTab (copy), p1 (copy)
			if GetFFlagEnableGateNotificationPreferencesTab() then
				return p1.EnableNotificationPreferencesPage or false
			end

			return nil
		end,
		getVNGFormRequired = function() -- line: 724
			-- upvalues: p1 (copy)
			return p1.VNGFormRequired or false
		end,
		getUpsellVoiceForPhoneVerification = function() -- line: 727
			-- upvalues: p1 (copy)
			return p1.UpsellVoiceForPhoneVerification or false
		end,
		getIsLinkedVRModeAvailable = function() -- line: 730
			-- upvalues: UserInputService (copy)
			local Platform = UserInputService:GetPlatform()

			return Platform == Enum.Platform.Windows or Platform == Enum.Platform.UWP
		end,
		getShouldShowPhoneUpsell = function() -- line: 734
			-- upvalues: p1 (copy)
			return p1.ShouldShowPhoneUpsell or false
		end,
		getTermsOfUseLink = function() -- line: 737
			-- upvalues: p1 (copy)
			return p1.TermsOfUseLink or ""
		end,
		getPrivacyPolicyLink = function() -- line: 740
			-- upvalues: p1 (copy)
			return p1.PrivacyPolicyLink or ""
		end,
		getVngAppUpsell = function() -- line: 743
			-- upvalues: FFlagLuaAppHomeVngAppUpsell (copy), p1 (copy)
			if FFlagLuaAppHomeVngAppUpsell then
				return p1.VngAppUpsell or false
			end

			return false
		end,
		getVngAppUpsellPcLayout = if not FFlagVngAppUpsellPcLayout then nil else function() -- line: 751
			-- upvalues: p1 (copy)
			return p1.VngAppUpsellPcLayout or false
		end,
		getShouldHideContactImporterUpsell = function() -- line: 755
			-- upvalues: p1 (copy)
			return p1.ShouldHideContactImporterUpsell or false
		end,
		getContactImporterEncouraged = function() -- line: 758
			-- upvalues: p1 (copy)
			return p1.contactImporterEncouraged or false
		end,
		getFriendRequestNicknamesEnabled = function() -- line: 761
			-- upvalues: FFlagFriendRequestNicknames (copy), p1 (copy)
			if FFlagFriendRequestNicknames then
				return p1.FriendRequestNicknamesEnabled or false
			end

			return false
		end,
		getShouldShowVpcPlayButtonUpsells = if not FFlagLuaAppParentUpsellPolicy then nil else function() -- line: 769
			-- upvalues: p1 (copy)
			return p1.shouldShowVpcPlayButtonUpsells or false
		end,
		getDisablePlayableWhenLoading = if not FFlagLuaAppSupportDisablePlayableWhenLoading then nil else function() -- line: 774
			-- upvalues: p1 (copy)
			return p1.DisablePlayableWhenLoading or false
		end,
		getRenamePaymentsToSpendingTab = function() -- line: 778
			-- upvalues: p1 (copy)
			return p1.renamePaymentsToSpendingTab or false
		end,
		getNotificationsCanReceiveStream = function() -- line: 783
			-- upvalues: GetFFlagNotificationsComplianceShouldRestrictStream (copy), p1 (copy)
			if GetFFlagNotificationsComplianceShouldRestrictStream() then
				return p1.notificationsCanAccessStream or false
			end

			return nil
		end,
		getNotificationsCanReceivePush = function() -- line: 790
			-- upvalues: p1 (copy)
			return p1.notificationsCanAccessPush or false
		end,
		getPushNotificationsUpsell = function() -- line: 793
			-- upvalues: p1 (copy)
			return p1.ShouldShowPushNotificationsUpsell or false
		end,
		getNotificationsCanReceiveExperience = function() -- line: 796
			-- upvalues: p1 (copy)
			if p1.notificationsCanAccessExperience == nil then
				return true
			end

			return p1.notificationsCanAccessExperience
		end,
		getDisableResellingCollectiblesForCompliance = function() -- line: 802
			-- upvalues: p1 (copy)
			return p1.DisableResellingCollectiblesForCompliance or false
		end,
		getShowIllegalContentReportingUI = function() -- line: 805
			-- upvalues: v55 (copy), p1 (copy)
			return v55 or (p1.ShowIllegalContentReportingUI or false)
		end,
		getEligibleForContentPostFeed = function() -- line: 808
			-- upvalues: p1 (copy)
			return p1.EligibleForContentPostFeed or false
		end,
		getEligibleForExternalContentSharing = function() -- line: 811
			-- upvalues: p1 (copy)
			return p1.EligibleForExternalContentSharing or false
		end,
		getEnableContinuousLoad = function() -- line: 814
			-- upvalues: p1 (copy)
			return p1.EnableContinuousLoad or false
		end,
		getEnableAggregateLikesFavoritesCount = function() -- line: 817
			-- upvalues: p1 (copy)
			return p1.EnableAggregateLikesFavoritesCount or false
		end,
		getShowUpdatedCameraPath = function() -- line: 820
			-- upvalues: p1 (copy)
			return p1.showUpdatedCameraPath or false
		end,
		getRenameParentEmailForVerificationUpsell = function() -- line: 823
			-- upvalues: FFlagRenameParentEmailForVerificationUpsell (copy), p1 (copy)
			if FFlagRenameParentEmailForVerificationUpsell() then
				return p1.renameParentEmailForVerificationUpsell or false
			end

			return false
		end,
		getKeystrokeCollectionEnabled = function() -- line: 830
			-- upvalues: p1 (copy)
			if game:GetFastFlag("BehaviorCollectionControlEnabled") then
				return p1.EnableKeystrokeCollection or false
			end

			return false
		end,
		getCanUsePlatformChat = function() -- line: 838
			-- upvalues: p1 (copy)
			return p1.CanUsePlatformChat or false
		end,
		getCanSeeChatTab = function() -- line: 842
			-- upvalues: p1 (copy)
			return p1.CanSeeChatTab or false
		end,
		getHidesGamesTab = function() -- line: 847
			-- upvalues: FFlagEnableAndroidTvAppPolicies (copy), p1 (copy)
			if FFlagEnableAndroidTvAppPolicies then
				return p1.HidesGamesTab or false
			end

			return false
		end,
		getShowDisclaimerLinkForUnderageSignupsOnAllSignupPages = function() -- line: 855
			-- upvalues: GetFFlagEnableMultiPageSignup (copy), p1 (copy)
			if not GetFFlagEnableMultiPageSignup() then
				return true
			end

			if p1.ShowTermsAndPrivacyPolicyLinksForAllPagesU13Signup == nil then
				return true
			end

			return p1.ShowTermsAndPrivacyPolicyLinksForAllPagesU13Signup
		end,
		getAgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages = function() -- line: 864
			-- upvalues: GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup (copy), GetFFlagEnableMultiPageSignup (copy), p1 (copy)
			local v82 = GetFIntExclusiveFallbackExclusiveUnderageCutoffForMultiPageSignup()

			if not GetFFlagEnableMultiPageSignup() then
				return v82
			end

			if p1.AgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages == nil then
				return v82
			end

			return p1.AgeCutoffForShowDisclaimerLinkForUnderageSignupsOnAllSignupPages
		end,
		getRobuxUpsellFlowMobile = function() -- line: 874
			-- upvalues: p1 (copy)
			return p1.useMobileRobuxUpsellFlow or false
		end,
		getUsePaymentPlatformMicrosoftStore = function() -- line: 877
			-- upvalues: FFlagEnableMicrosoftStorePaymentsPlatform (copy), p1 (copy)
			if FFlagEnableMicrosoftStorePaymentsPlatform then
				return p1.usePaymentPlatformMicrosoftStore or false
			end

			return false
		end,
		getMicSettingsDirectionsLocaleKey = function() -- line: 884
			-- upvalues: p1 (copy)
			return p1.micSettingsDirectionsLocaleKey or nil
		end,
		getMicSettingsDeeplinkDirectionsLocaleKey = function() -- line: 887
			-- upvalues: p1 (copy)
			return p1.micSettingsDeeplinkDirectionsLocaleKey or nil
		end,
		getRequiresAppRestartOnMicAccessChange = function() -- line: 890
			-- upvalues: p1 (copy)
			return p1.requiresAppRestartOnMicAccessChange or false
		end,
		getRenameFriendsToConnections = function() -- line: 893
			-- upvalues: FFlagEnableFriendsRenamingForAll (copy), p1 (copy)
			if FFlagEnableFriendsRenamingForAll then
				return true
			end

			return p1.renameFriendsToConnections or false
		end,
		getShareSheetEnabled = function() -- line: 899
			-- upvalues: p1 (copy)
			return p1.shareSheetEnabled or false
		end,
		getCanAccessTrustedContacts = function() -- line: 902
			-- upvalues: p1 (copy)
			return p1.canAccessTrustedContacts or false
		end,
		getExperienceDetailsNoticeType = function() -- line: 905
			-- upvalues: p1 (copy)
			return p1.experienceDetailsNoticeType or nil
		end,
		getRequiresOSAFriendingEducation = function() -- line: 908
			-- upvalues: p1 (copy)
			return p1.requiresOSAFriendingEducation or false
		end,
		getSocialGraphSyncEnabled = function() -- line: 911
			-- upvalues: p1 (copy)
			return p1.SocialGraphSyncEnabled or false
		end,
		getAccountDisambiguationDisabled = function() -- line: 914
			-- upvalues: p1 (copy)
			return p1.AccountDisambiguationDisabled or false
		end,
		getHasWebViewSupportForFAE = function() -- line: 917
			-- upvalues: p1 (copy)
			return p1.hasWebViewSupportForFAE or false
		end,
		getLinkedAuthEndpointsEnabled = function() -- line: 920
			-- upvalues: p1 (copy)
			return p1.LinkedAuthEndpointsEnabled or false
		end,
		getLinkingPlatform = function() -- line: 923
			-- upvalues: p1 (copy)
			return p1.LinkingPlatform or nil
		end,
		getUsePaymentPlatformMilkyWayStore = function() -- line: 926
			-- upvalues: FFlagEnableMilkyWayPaymentsPlatformV2 (copy), p1 (copy)
			if FFlagEnableMilkyWayPaymentsPlatformV2 then
				return p1.usePaymentPlatformMilkyWayStore or false
			end

			return false
		end,
		getScreentimeMoreTimeOptionEnabled = function() -- line: 932
			-- upvalues: FFlagEnableScreentimeMoreTimeOption (copy), p1 (copy)
			if FFlagEnableScreentimeMoreTimeOption then
				return p1.ScreentimeMoreTimeOptionEnabled or false
			end

			return false
		end,
		getDisablePremiumEntrypoint = function() -- line: 938
			-- upvalues: v52 (copy), p1 (copy)
			if v52 then
				return p1.DisablePremiumEntrypoint or (p1.DisablePremiumEntryPoint or false)
			end

			return false
		end,
		getDisableBlackbirdEntrypoints = function() -- line: 944
			-- upvalues: v53 (copy), p1 (copy)
			if v53 then
				return p1.DisableBlackbirdEntrypoints or false
			end

			return false
		end,
		getEnableGiftcardsWithRedeem = function() -- line: 950
			-- upvalues: v54 (copy), p1 (copy)
			if v54 then
				return p1.EnableGiftcardsWithRedeem or false
			end

			return false
		end,
		getGiftCardSourceRefOverride = function() -- line: 956
			-- upvalues: p1 (copy)
			return p1.GiftCardSourceRefOverride or ""
		end,
		getSignupCheckboxDisabled = function() -- line: 959
			-- upvalues: v51 (copy), p1 (copy)
			if v51 then
				return p1.DisableSignupCheckbox or false
			end

			return false
		end,
		getShouldShowFaceIDText = function() -- line: 965
			-- upvalues: FFlagEnableFaceIDTextOnAddAuthMethodPage (copy), p1 (copy)
			if FFlagEnableFaceIDTextOnAddAuthMethodPage then
				return p1.ShouldShowFaceIDText or false
			end

			return false
		end,
		getExcludeCrossDeviceSignIn = function() -- line: 972
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludeCrossDeviceSignIn or false
			end

			return false
		end,
		getExcludePasskeyLogin = function() -- line: 978
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludePasskeyLogin or false
			end

			return false
		end,
		getExcludeUsernamePasswordSignIn = function() -- line: 985
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludeUsernamePasswordSignIn or false
			end

			return false
		end,
		getExcludeEmailPasswordSignIn = function() -- line: 991
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludeEmailPasswordSignIn or false
			end

			return false
		end,
		getExcludePhoneNumberPasswordSignIn = function() -- line: 997
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludePhoneNumberPasswordSignIn or false
			end

			return false
		end,
		getExcludeAccountSwitcher = function() -- line: 1003
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludeAccountSwitcher or false
			end

			return false
		end,
		getAccountSwitcherEnabled = function() -- line: 1009
			-- upvalues: p1 (copy)
			return p1.AccountSwitcherEnabled or false
		end,
		getExcludeUsernameUpdateModeration = function() -- line: 1012
			-- upvalues: FFlagAuthSecExclusions (copy), p1 (copy)
			if FFlagAuthSecExclusions then
				return p1.ExcludeUsernameUpdateModeration or false
			end

			return false
		end,
		getMorePageExitButtonEnabled = if not FFlagEnableMorePageExitButtonSupport then nil else function() -- line: 1019
			-- upvalues: p1 (copy)
			return p1.MorePageExitButtonEnabled or false
		end,
		getMoreGridDirectionalLayoutPreferred = if not FFlagEnableMorePageDirectionalLayoutRolloutFix then nil else function() -- line: 1024
			-- upvalues: p1 (copy)
			return p1.MoreGridDirectionalLayoutPreferred or false
		end,
		getShouldUseDMCCALegalDisclosureInApp = function() -- line: 1028
			-- upvalues: FFlagEnableUnifiedProductPurchaseFlow (copy), p1 (copy)
			if FFlagEnableUnifiedProductPurchaseFlow then
				return p1.ShouldUseDMCCALegalDisclosureInApp or false
			end

			return false
		end,
		getCanAccessParty = function() -- line: 1034
			-- upvalues: p1 (copy)
			if p1.CanAccessParty == nil then
				return true
			end

			return p1.CanAccessParty
		end,
		getRedeemTileEnabled = function() -- line: 1040
			-- upvalues: p1 (copy)
			return p1.RedeemTileEnabled or false
		end,
		getDisplayMomentsMoreTabTile = function() -- line: 1043
			-- upvalues: p1 (copy)
			return p1.DisplayMomentsMoreTabTile or false
		end,
		getSupportCenterEnabled = if not GetFFlagEnableSupportCenter() then nil else function() -- line: 1047
			-- upvalues: p1 (copy)
			return p1.SupportCenterEnabled or false
		end,
		getShouldUseVibrationInsteadOfHaptics = function() -- line: 1051
			-- upvalues: p1 (copy)
			return p1.ShouldUseVibrationInsteadOfHaptics or false
		end,
		getRawPolicy = if not FFlagSduiAppPolicyBindings then nil else function() -- line: 1055
			-- upvalues: p1 (copy)
			return p1
		end,
		getStickyShortcutBarEnabled = if not FFlagGuacStickyShortcutBarEnabled then nil else function() -- line: 1060
			-- upvalues: p1 (copy)
			return p1.StickyShortcutBarEnabled or false
		end,
		getAccountType = if not FFlagEnableCoreContentAccountType then nil else function() -- line: 1065
			-- upvalues: p1 (copy)
			return p1.AccountType
		end,
		getCoreContentBadgeText = if not FFlagEnableCoreContentBadge then nil else function() -- line: 1070
			-- upvalues: p1 (copy)
			return p1.CoreContentBadgeText
		end,
		getCoreContentTheme = if not FFlagEnableCoreContentThemeUseGuacForTokenOverrides then nil else function() -- line: 1075
			-- upvalues: p1 (copy)
			return p1.CoreContentTheme
		end,
		getShowUncheckedBadge = if not FFlagEnableFlyoutUncheckedBadge and not FFlagEnableNonFlyoutUncheckedBadge then nil else function() -- line: 1080
			-- upvalues: p1 (copy)
			return p1.ShowUncheckedBadge
		end,
		getShowUncheckedBadgeForAccountSwitcher = function() -- line: 1084
			-- upvalues: GetFFlagEnableAccountSwitcherUncheckedBadge (copy), p1 (copy)
			if not GetFFlagEnableAccountSwitcherUncheckedBadge() then
				return false
			end

			return p1.ShowUncheckedBadge
		end,
		getShowBadgeOver12 = if not FFlagAddTopBarPoliciesToUniversalPolicies then nil else function() -- line: 1091
			-- upvalues: p1 (copy)
			return p1.ShowBadgeOver12 or false
		end,
		getDefaultTheme = if not FFlagDefaultKidsToDarkTheme then nil else function() -- line: 1096
			-- upvalues: p1 (copy)
			return p1.DefaultTheme
		end,
		getDevicePreferencesPersistentPresenceVariant = if not v42 then nil else function() -- line: 1101
			-- upvalues: p1 (copy)
			return p1.DevicePreferencesPersistentPresenceVariant
		end,
		getCancelSearchOnLostFocus = if not FFlagUsesCancelSearchAppPolicy then nil else function() -- line: 1106
			-- upvalues: p1 (copy)
			if p1.CancelSearchOnLostFocus == nil then
				return true
			end

			return p1.CancelSearchOnLostFocus
		end,
		getCanViewBuild = if not FFlagAppNavMyStatsTab then nil else function() -- line: 1114
			-- upvalues: p1 (copy)
			return p1.CanViewBuild or false
		end,
		getCanUseBuild = if not FFlagAppNavMyStatsTab then nil else function() -- line: 1119
			-- upvalues: p1 (copy)
			return p1.CanUseBuild or false
		end
	}
end

return AppFeaturePolicies
