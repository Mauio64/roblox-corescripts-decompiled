local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local OverlayType = require(Modules.LuaApp.Enum.OverlayType)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)

require(CorePackages.Packages.React)

local createLazyComponent = RoactUtils.Components.createLazyComponent
local GetFFlagEnableConfirmSignOutV2 = require(Modules.LuaApp.Flags.GetFFlagEnableConfirmSignOutV2)
local GetFFlagEnableLoginAccountSelector = require(Modules.LuaApp.Flags.GetFFlagEnableLoginAccountSelector)
local GetFFlagEnableOtpEmailLogin = require(Modules.LuaApp.Flags.GetFFlagEnableOtpEmailLogin)
local GetFFlagEdpPlayerFeedbackEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEdpPlayerFeedbackEnabled
local GetFFlagLuaAppAccountSecurityPromptEnabled = require(Modules.LuaApp.Flags.GetFFlagLuaAppAccountSecurityPromptEnabled)
local GetFFlagIsSquadEnabled = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagEnableVNGNewAppAvailableModal = require(Modules.LuaApp.Flags.GetFFlagEnableVNGNewAppAvailableModal)
local FFlagEnableLuaAccountSwitch = require(Modules.LuaApp.Flags.FFlagEnableLuaAccountSwitch)
local GetFFlagEnableAccountSwitcherFoundationDesign = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableAccountSwitcherFoundationDesign
local FFlagEnableKoreaKISACompliance = require(Modules.LuaApp.Flags.FFlagEnableKoreaKISACompliance)
local GetFFlagUseUpdatedVNGAgreementsWorkflow = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagUseUpdatedVNGAgreementsWorkflow
local FFlagLuaAppHomeVngAppUpsell = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppHomeVngAppUpsell
local FFlagSearchOmniAutocompletePage = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSearchOmniAutocompletePage
local GetFFlagEnableReminderOfNormsABTest = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableReminderOfNormsABTest
local GetFFlagEnableInAppBugReporting = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableInAppBugReporting
local FFlagEnableAbuseReportRevampFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAbuseReportRevampFlow
local FFlagEnableMagicLogin = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableMagicLogin
local FFlagAXWearTimeSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXWearTimeSupport
local FFlagLuaAppsServerTriggeredModals = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsServerTriggeredModals
local FFlagEnableUnifiedProductPurchaseFlow = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableUnifiedProductPurchaseFlow
local FFlagEnableSignUpExitModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSignUpExitModal
local FFlagEnableSystemTrayModals = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSystemTrayModals
local FFlagLuaAppEnableWhyThisAdModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEnableWhyThisAdModal
local FFlagLuaAppPlayButtonUpsellLinking = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppPlayButtonUpsellLinking
local FFlagEnableSduiV2HomepagePrompts = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableSduiV2HomepagePrompts
local FFlagPromptsHandlerEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagPromptsHandlerEnabled
local FFlagSduiExperienceDetailsSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagSduiEventDetailsSupport = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSduiEventDetailsSupport
local FFlagLuaAppTextFeedbackFormModal = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppTextFeedbackFormModal

return {
	OverlayComponent = {
		[OverlayType.VerifyPhoneNumber] = createLazyComponent(function() -- line: 56
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.VerifyPhoneNumber)
		end),
		[OverlayType.VerifiedEnableVoice] = createLazyComponent(function() -- line: 59
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Verification.IdentityVerification.VerifiedEnableVoiceModal)
		end),
		[OverlayType.UserAgreementsUpdatedPopup] = createLazyComponent(function() -- line: 62
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.UserAgreement.UserAgreementsUpdatedPopup)
		end),
		[OverlayType.VNGUserAgreementsPopup] = createLazyComponent(function() -- line: 65
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.UserAgreement.VNGUserAgreementsPopup)
		end),
		[OverlayType.UserAgreementsSecondPrompt] = createLazyComponent(function() -- line: 68
			-- upvalues: Modules (copy)
			return require(Modules.Luobu.Components.Authentication.UserAgreementsSecondPrompt)
		end),
		[OverlayType.UserAgreementsPrompt] = createLazyComponent(function() -- line: 71
			-- upvalues: Modules (copy)
			return require(Modules.Luobu.Components.Authentication.UserAgreementsPrompt)
		end),
		[OverlayType.TencentNoticePopup] = createLazyComponent(function() -- line: 74
			-- upvalues: Modules (copy)
			return require(Modules.Luobu.Components.TencentNoticePopup.TencentNoticePopup)
		end),
		[OverlayType.SimpleTextAlertPrompt] = createLazyComponent(function() -- line: 77
			-- upvalues: Modules (copy)
			return require(Modules.Luobu.Components.Authentication.SimpleTextAlertPrompt)
		end),
		[OverlayType.SignUpBirthdayPickerOverlay] = createLazyComponent(function() -- line: 80
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.SignUpBirthdayPickerOverlay)
		end),
		[OverlayType.PurchaseGameRobuxShortfall] = createLazyComponent(function() -- line: 83
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.GameDetails.PurchaseGameRobuxShortfallPrompt)
		end),
		[OverlayType.PurchaseGame] = createLazyComponent(function() -- line: 86
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.GameDetails.PurchaseGamePrompt)
		end),
		[OverlayType.PlacesList] = createLazyComponent(function() -- line: 89
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Home.PlacesListContextualMenu)
		end),
		[OverlayType.PeopleList] = createLazyComponent(function() -- line: 92
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Home.PeopleListContextualMenuFn)
		end),
		[OverlayType.LoginPasswordResetPrompt] = createLazyComponent(function() -- line: 95
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.PasswordResetPrompt)
		end),
		[OverlayType.LoginEmailVerificationPrompt] = createLazyComponent(function() -- line: 98
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.LoginEmailVerificationPrompt)
		end),
		[OverlayType.UpdateRequiredPrompt] = createLazyComponent(function() -- line: 101
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.UpdateRequiredPrompt)
		end),
		[OverlayType.LeaveRobloxAlert] = createLazyComponent(function() -- line: 104
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.GameDetails.LeaveRobloxAlert)
		end),
		[OverlayType.ReportLogsOverlay] = createLazyComponent(function() -- line: 107
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.More.ReportLogsOverlay)
		end),
		[OverlayType.GameDetailsPlayWithFriends] = createLazyComponent(function() -- line: 110
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.GameDetails.GameDetailsPlayWithFriendsContextualMenu)
		end),
		[OverlayType.GameDetailMore] = createLazyComponent(function() -- line: 113
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.GameDetails.GameDetailMoreContextualMenu)
		end),
		[OverlayType.GameDetailsSquad] = if not GetFFlagIsSquadEnabled() then nil else createLazyComponent(function() -- line: 117
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.GameDetails.GameDetailsSquadContextualMenu)
		end),
		[OverlayType.ExperienceGuidelinesExplained] = createLazyComponent(function() -- line: 121
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.ExperienceGuidelines.ExperienceGuidelinesExplained)
		end),
		[OverlayType.FindFriendsModal] = createLazyComponent(function() -- line: 124
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.ContactImporter.api).FindFriendsModal
		end),
		[OverlayType.EmailVerificationUpsellOverlay] = createLazyComponent(function() -- line: 127
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.VerificationUpsell.EmailVerificationUpsellOverlay)
		end),
		[OverlayType.PhoneVerificationUpsellOverlay] = createLazyComponent(function() -- line: 130
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.PhoneUpsell).PhoneVerificationUpsellOverlay
		end),
		[OverlayType.PhoneVerificationUpsellOverlayWrapper] = createLazyComponent(function() -- line: 133
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.PhoneUpsell).PhoneVerificationUpsellOverlayWrapper
		end),
		[OverlayType.VoicePhoneVerificationUpsellOverlayWrapper] = createLazyComponent(function() -- line: 136
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.PhoneUpsell).VoicePhoneVerificationUpsellOverlayWrapper
		end),
		[OverlayType.DevSubMore] = createLazyComponent(function() -- line: 139
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DevSubMoreMenu)
		end),
		[OverlayType.DevSubConfirmCancel] = createLazyComponent(function() -- line: 142
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DevSubConfirmCancelPrompt)
		end),
		[OverlayType.CrossDeviceLoginConfirmation] = createLazyComponent(function() -- line: 145
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.LoginConfirmationPrompt)
		end),
		[OverlayType.CrossDeviceCodePrompt] = createLazyComponent(function() -- line: 148
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.CrossDeviceLogin.LoginCodePrompt)
		end),
		[OverlayType.ContactsList] = createLazyComponent(function() -- line: 151
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.ContactImporter.api).ContactsList
		end),
		[OverlayType.ConfirmSignOut] = createLazyComponent(function() -- line: 154
			-- upvalues: GetFFlagEnableConfirmSignOutV2 (copy), Modules (copy)
			if GetFFlagEnableConfirmSignOutV2() then
				return require(Modules.LuaApp.Components.Authentication.ConfirmSignOutV2)
			end

			return require(Modules.LuaApp.Components.Authentication.ConfirmSignOut)
		end),
		[OverlayType.CameraPermissionPrompt] = createLazyComponent(function() -- line: 161
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.CameraPermissionPrompt)
		end),
		[OverlayType.AgreeToPhoneNumberVerification] = createLazyComponent(function() -- line: 164
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.AgreeToPhoneNumberVerification)
		end),
		[OverlayType.AccountAuthenticationFailureOverlay] = createLazyComponent(function() -- line: 167
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.AccountAuthenticationFailureOverlay)
		end),
		[OverlayType.PurchasePass] = createLazyComponent(function() -- line: 170
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Passes.PurchasePassPrompt)
		end),
		[OverlayType.PurchasePassInsufficientRobux] = createLazyComponent(function() -- line: 173
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Passes.PurchasePassInsufficientRobuxPrompt)
		end),
		[OverlayType.PurchaseDeveloperProduct] = createLazyComponent(function() -- line: 176
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DeveloperProduct.PurchaseDeveloperProductPrompt)
		end),
		[OverlayType.PurchaseDeveloperProductInsufficientRobux] = createLazyComponent(function() -- line: 179
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DeveloperProduct.PurchaseDeveloperProductInsufficientRobuxPrompt)
		end),
		[OverlayType.PurchaseDeveloperProductPendingProductsLimitExceeded] = createLazyComponent(function() -- line: 182
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DeveloperProduct.PurchaseDeveloperProductPendingProductsLimitExceededPrompt)
		end),
		[OverlayType.PurchaseDeveloperProductSuccess] = createLazyComponent(function() -- line: 187
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DeveloperProduct.PurchaseDeveloperProductSuccessPrompt)
		end),
		[OverlayType.AccountSecurityPromptOverlay] = if not GetFFlagLuaAppAccountSecurityPromptEnabled() then nil else createLazyComponent(function() -- line: 191
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.AccountSecurity.PromptOverlay)
		end),
		[OverlayType.DiscoverabilityUpsell] = createLazyComponent(function() -- line: 195
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.DiscoverabilityModal.api).DiscoverabilityOverlay
		end),
		[OverlayType.SurveyPrompt] = createLazyComponent(function() -- line: 198
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.OnPlatformSurveys.SurveyPrompt)
		end),
		[OverlayType.PlayerContextualMenu] = createLazyComponent(function() -- line: 201
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.PlayerContextualMenu).Component
		end),
		[OverlayType.GamepadDisconnected] = createLazyComponent(function() -- line: 204
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.InputUi).Gamepad.GamepadDisconnectedModal
		end),
		[OverlayType.IapExperienceAnimator] = createLazyComponent(function() -- line: 207
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.IAPExperience).Animator
		end),
		[OverlayType.AccountSelector] = if not GetFFlagEnableLoginAccountSelector() then nil else createLazyComponent(function() -- line: 211
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AccountSelector).AccountSelectorOverlay
		end),
		[OverlayType.AccountSwitcher] = if not GetFFlagEnableAccountSwitcherFoundationDesign() then nil else createLazyComponent(function() -- line: 216
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AccountSelector).AccountSwitchingSelectAccount
		end),
		[OverlayType.EmailOtp] = if not GetFFlagEnableOtpEmailLogin() then nil else createLazyComponent(function() -- line: 221
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.OtpLogin).EmailOtpOverlay
		end),
		[OverlayType.VngContactInfoFormWebviewPopup] = createLazyComponent(function() -- line: 225
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Vng.VngContactInfoFormWebviewPopup)
		end),
		[OverlayType.NewAppAvailableModal] = if not GetFFlagEnableVNGNewAppAvailableModal() then nil else createLazyComponent(function() -- line: 229
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Authentication.NewAppAvailableInteractiveAlert)
		end),
		[OverlayType.AccountSwitchingErrorOverlay] = if not FFlagEnableLuaAccountSwitch then nil else createLazyComponent(function() -- line: 234
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AccountSwitching).AccountSwitchingErrorOverlay
		end),
		[OverlayType.CloseOnlyInteractiveAlert] = createLazyComponent(function() -- line: 238
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AppBlox).CloseOnlyInteractiveAlert
		end),
		[OverlayType.ConfirmationDialog] = createLazyComponent(function() -- line: 241
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AppBlox).ConfirmationDialog
		end),
		[OverlayType.UpsellModal] = if not FFlagLuaAppPlayButtonUpsellLinking then createLazyComponent(function() -- line: 246
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AppBlox).UpsellModal
		end) else nil,
		[OverlayType.PlayButtonUpsellDialog] = if not FFlagLuaAppPlayButtonUpsellLinking then nil else createLazyComponent(function() -- line: 250
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.GamePlayButton).PlayButtonUpsellDialog
		end),
		[OverlayType.SquadPrompt] = if not GetFFlagIsSquadEnabled() then nil else createLazyComponent(function() -- line: 255
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.SquadsCore.Components).SquadPrompt
		end),
		[OverlayType.VngComplianceLoadingPopup] = if not GetFFlagUseUpdatedVNGAgreementsWorkflow() then nil else createLazyComponent(function() -- line: 260
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Vng.VngComplianceLoadingPopup)
		end),
		[OverlayType.KISAPopUpAgreements] = if not FFlagEnableKoreaKISACompliance then nil else createLazyComponent(function() -- line: 265
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AuthCompliance).KISAPopUpAgreements
		end),
		[OverlayType.ItemsReceivedAlert] = createLazyComponent(function() -- line: 269
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.ItemsReceivedAlert).ItemsReceivedAlert
		end),
		[OverlayType.VngAppUpsell] = if not FFlagLuaAppHomeVngAppUpsell then nil else createLazyComponent(function() -- line: 273
			-- upvalues: Modules (copy)
			return require(Modules.Personalization.Home.VngAppUpsell.VngAppUpsellOverlay)
		end),
		[OverlayType.SearchPageOverlay] = if not FFlagSearchOmniAutocompletePage then nil else createLazyComponent(function() -- line: 278
			-- upvalues: Modules (copy)
			return require(Modules.Personalization.Search.SearchPageOverlay)
		end),
		[OverlayType.GamePlayerFeedbackForm] = if not GetFFlagEdpPlayerFeedbackEnabled() then nil else createLazyComponent(function() -- line: 283
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.PlayerFeedback).GamePlayerFeedbackFormModal
		end),
		[OverlayType.ReminderOfNormsPopup] = if not GetFFlagEnableReminderOfNormsABTest() then nil else createLazyComponent(function() -- line: 288
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Moderation.ReminderOfNormsPopup)
		end),
		[OverlayType.GameFilterMenuDropdown] = createLazyComponent(function() -- line: 292
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.GameFilters).FilterMenuDropdown
		end),
		[OverlayType.SettingsPermissionInteractiveAlert] = createLazyComponent(function() -- line: 295
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.SocialCommon).Components.SettingsPermissionInteractiveAlert
		end),
		[OverlayType.BugReporter] = if not GetFFlagEnableInAppBugReporting() then nil else createLazyComponent(function() -- line: 299
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.BugReporting).BugReporterModalContainer
		end),
		[OverlayType.InAppIntervention] = createLazyComponent(function() -- line: 303
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.InAppIntervention).InAppInterventionContainer
		end),
		[OverlayType.DynamicAbuseReport] = if not FFlagEnableAbuseReportRevampFlow then nil else createLazyComponent(function() -- line: 307
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.GenericAbuseReporting.DynamicReportContainer)
		end),
		[OverlayType.AccountReactivationPrompt] = createLazyComponent(function() -- line: 311
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.NotApprovedPage).AccountReactivationPrompt
		end),
		[OverlayType.MagicLoginApprovePopup] = if not FFlagEnableMagicLogin then nil else createLazyComponent(function() -- line: 315
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.LoginV2.Components).MagicLoginApprovePopup
		end),
		[OverlayType.MagicLoginRequestPopup] = if not FFlagEnableMagicLogin then nil else createLazyComponent(function() -- line: 320
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.LoginV2.Components).MagicLoginRequestPopup
		end),
		[OverlayType.DeviceSelectorPeekView] = if not FFlagEnableMagicLogin then nil else createLazyComponent(function() -- line: 325
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.LoginV2.Components).DeviceSelectorPeekView
		end),
		[OverlayType.AccountLinkingAlert] = createLazyComponent(function() -- line: 329
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AuthCommon).Components.AccountLinkingAlert
		end),
		[OverlayType.CheckboxFeedbackFormModal] = createLazyComponent(function() -- line: 332
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AppBlox).CheckboxFeedbackFormModal
		end),
		[OverlayType.TextFeedbackFormModal] = if not FFlagLuaAppTextFeedbackFormModal then nil else createLazyComponent(function() -- line: 336
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AppBlox).TextFeedbackFormModal
		end),
		[OverlayType.ProvideFeedbackToast] = createLazyComponent(function() -- line: 340
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AppBlox).ProvideFeedbackToast
		end),
		[OverlayType.WearTimeInfoModal] = if not FFlagAXWearTimeSupport then nil else createLazyComponent(function() -- line: 344
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AvatarExperienceTimedOptions).WearTimeInfoModal
		end),
		[OverlayType.EconomicRestrictionPrompt] = createLazyComponent(function() -- line: 348
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.Fraud.EconomicRestrictionPrompt)
		end),
		[OverlayType.UnifiedProductPurchaseModal] = if not FFlagEnableUnifiedProductPurchaseFlow then nil else createLazyComponent(function() -- line: 352
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.PurchasePrompt).UnifiedPurchasePromptContainer
		end),
		[OverlayType.AccountLockModal] = createLazyComponent(function() -- line: 356
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AccountLockModal).AccountLockModal
		end),
		[OverlayType.SduiModal] = if not FFlagLuaAppsServerTriggeredModals then nil else createLazyComponent(function() -- line: 360
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.ServerTriggeredModals).SduiModal
		end),
		[OverlayType.SduiPromptModal] = if not FFlagEnableSduiV2HomepagePrompts and not FFlagPromptsHandlerEnabled then nil else createLazyComponent(function() -- line: 365
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.ServerTriggeredModals).PromptsContainer
		end),
		[OverlayType.SduiOverlay] = if not FFlagSduiExperienceDetailsSupport and not FFlagSduiEventDetailsSupport then nil else createLazyComponent(function() -- line: 370
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.SduiSharedUtilities).SduiOverlayEntryPoint
		end),
		[OverlayType.SignUpExitModal] = if not FFlagEnableSignUpExitModal then nil else createLazyComponent(function() -- line: 375
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.AuthSignup).Components.SignUpExitModal
		end),
		[OverlayType.SocialUpsellOverlay] = createLazyComponent(function() -- line: 379
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.SocialUpsell).InAppSocialUpsellOverlayWrapper
		end),
		[OverlayType.NotificationsModal] = if not FFlagEnableSystemTrayModals then nil else createLazyComponent(function() -- line: 383
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.NotificationsModal)
		end),
		[OverlayType.SystemTrayModal] = if not FFlagEnableSystemTrayModals then nil else createLazyComponent(function() -- line: 388
			-- upvalues: Modules (copy)
			return require(Modules.LuaApp.Components.SystemTrayModal)
		end),
		[OverlayType.WhyThisAdModal] = if not FFlagLuaAppEnableWhyThisAdModal then nil else createLazyComponent(function() -- line: 393
			-- upvalues: CorePackages (copy)
			return require(CorePackages.Workspace.Packages.SponsoredTiles).WhyThisAdModal
		end)
	}
}
