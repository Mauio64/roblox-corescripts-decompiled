local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/ehl")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
require(CorePackages.Packages.React)
local createLazyComponent = RoactUtils.Components.createLazyComponent

local module3 = require("@luauforge/bundled/hVJ")
local module4 = require("@luauforge/bundled/hOT")
local module5 = require("@luauforge/bundled/hOV")

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled

local module6 = require("@luauforge/bundled/fzw")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local fFlagLuaAppCloudClientPlayButtonOffer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCloudClientPlayButtonOffer
local module7 = require("@luauforge/bundled/hOZ")

local fFlagDeprecatePeopleListContextualMenu = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeprecatePeopleListContextualMenu

local module8 = require("@luauforge/bundled/ghR")
local module9 = require("@luauforge/bundled/guB")

local getFFlagUseUpdatedVNGAgreementsWorkflow = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseUpdatedVNGAgreementsWorkflow
local fFlagLuaAppHomeVngAppUpsell = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHomeVngAppUpsell

local getFFlagEnableInAppBugReporting = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableInAppBugReporting

local fFlagEnableAbuseReportRevampFlow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAbuseReportRevampFlow
local fFlagEnableMagicLogin = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableMagicLogin

local fFlagLuaAppsServerTriggeredModals = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppsServerTriggeredModals
local fFlagEnableSystemTrayModals = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSystemTrayModals

local fFlagEnableSduiV2HomepagePrompts = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSduiV2HomepagePrompts
local fFlagPromptsHandlerEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPromptsHandlerEnabled

local fFlagLuaAppTextFeedbackFormModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppTextFeedbackFormModal

local fFlagEnableAccountIneligibleLoginModal = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableAccountIneligibleLoginModal

local fFlagPinShortcutEnableOnCompleteCallback = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagPinShortcutEnableOnCompleteCallback

local v5 = {
	[module.VerifyPhoneNumber] = createLazyComponent(function()
		return require("@luauforge/deferred/hVK")
	end),
	[module.VerifiedEnableVoice] = createLazyComponent(function()
		return require("@luauforge/deferred/hVR")
	end),
	[module.UserAgreementsUpdatedPopup] = createLazyComponent(function()
		return require("@luauforge/deferred/hVW")
	end),
	[module.VNGUserAgreementsPopup] = createLazyComponent(function()
		return require("@luauforge/deferred/hWd")
	end),
	[module.UserAgreementsSecondPrompt] = createLazyComponent(function()
		return require("@luauforge/deferred/hWg")
	end),
	[module.UserAgreementsPrompt] = createLazyComponent(function()
		return require("@luauforge/deferred/hWh")
	end),
	[module.TencentNoticePopup] = createLazyComponent(function()
		return require("@luauforge/deferred/hWi")
	end),
	[module.SimpleTextAlertPrompt] = createLazyComponent(function()
		return require("@luauforge/deferred/hWl")
	end),
	[module.SignUpBirthdayPickerOverlay] = createLazyComponent(function()
		return require("@luauforge/deferred/hWm")
	end),
	[module.PurchaseGameRobuxShortfall] = createLazyComponent(function()
		return require("@luauforge/deferred/hWo")
	end),
	[module.PurchaseGame] = createLazyComponent(function()
		return require("@luauforge/deferred/hWq")
	end),
	[module.PlacesList] = createLazyComponent(function()
		return require("@luauforge/deferred/hWw")
	end)
}

local peopleList = module.PeopleList
local v6

if not fFlagDeprecatePeopleListContextualMenu then
	v6 = createLazyComponent(function()
		return require("@luauforge/deferred/hWI")
	end)
end

v5[peopleList] = v6

v5[module.LoginPasswordResetPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hWL")
end)

v5[module.LoginEmailVerificationPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hWM")
end)

v5[module.UpdateRequiredPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hWP")
end)

v5[module.LeaveRobloxAlert] = createLazyComponent(function()
	return require("@luauforge/deferred/hWR")
end)

v5[module.ReportLogsOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hWS")
end)

v5[module.GameDetailsPlayWithFriends] = createLazyComponent(function()
	return require("@luauforge/deferred/hWY")
end)

v5[module.GameDetailMore] = createLazyComponent(function()
	return require("@luauforge/deferred/hXa")
end)

local gameDetailsSquad = module.GameDetailsSquad
local v7

if getFFlagIsSquadEnabled() then
	v7 = createLazyComponent(function()
		return require("@luauforge/deferred/hXi")
	end)
end

v5[gameDetailsSquad] = v7

v5[module.ExperienceGuidelinesExplained] = createLazyComponent(function()
	return require("@luauforge/deferred/hXj")
end)

v5[module.FindFriendsModal] = createLazyComponent(function()
	return require("@luauforge/bundled/cqV").FindFriendsModal
end)

v5[module.EmailVerificationUpsellOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hXn")
end)

v5[module.PhoneVerificationUpsellOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/gXN").PhoneVerificationUpsellOverlay
end)

v5[module.PhoneVerificationUpsellOverlayWrapper] = createLazyComponent(function()
	return require("@luauforge/deferred/gXN").PhoneVerificationUpsellOverlayWrapper
end)

v5[module.VoicePhoneVerificationUpsellOverlayWrapper] = createLazyComponent(function()
	return require("@luauforge/deferred/gXN").VoicePhoneVerificationUpsellOverlayWrapper
end)

v5[module.DevSubMore] = createLazyComponent(function()
	return require("@luauforge/deferred/hXv")
end)

v5[module.DevSubConfirmCancel] = createLazyComponent(function()
	return require("@luauforge/deferred/hXy")
end)

v5[module.CrossDeviceLoginConfirmation] = createLazyComponent(function()
	return require("@luauforge/deferred/hXz")
end)

v5[module.CrossDeviceCodePrompt] = createLazyComponent(function()
	return require("@luauforge/bundled/gyg")
end)

v5[module.ContactsList] = createLazyComponent(function()
	return require("@luauforge/bundled/cqV").ContactsList
end)

v5[module.ConfirmSignOut] = createLazyComponent(function()
	if module3() then
		return require("@luauforge/deferred/hXA")
	end

	return require("@luauforge/deferred/hXB")
end)

v5[module.CameraPermissionPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hXC")
end)

v5[module.AgreeToPhoneNumberVerification] = createLazyComponent(function()
	return require("@luauforge/deferred/hXD")
end)

v5[module.AccountAuthenticationFailureOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hXE")
end)

local accountSecurityPromptOverlay = module.AccountSecurityPromptOverlay
local v8

if module6() then
	v8 = createLazyComponent(function()
		return require("@luauforge/deferred/hXG")
	end)
end

v5[accountSecurityPromptOverlay] = v8

v5[module.DiscoverabilityUpsell] = createLazyComponent(function()
	return require("@luauforge/bundled/cxg").DiscoverabilityOverlay
end)

v5[module.SurveyPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hYm")
end)

v5[module.PlayerContextualMenu] = createLazyComponent(function()
	return require("@luauforge/bundled/ehZ").Component
end)

v5[module.GamepadDisconnected] = createLazyComponent(function()
	return require("@luauforge/bundled/fCf").Gamepad.GamepadDisconnectedModal
end)

v5[module.IapExperienceAnimator] = createLazyComponent(function()
	return require("@luauforge/deferred/gKv").Animator
end)

local accountSelector = module.AccountSelector
local v9

if module4() then
	v9 = createLazyComponent(function()
		return require("@luauforge/bundled/gtG").AccountSelectorOverlay
	end)
end

v5[accountSelector] = v9

v5[module.AccountSwitcher] = createLazyComponent(function()
	return require("@luauforge/bundled/gtG").AccountSwitchingSelectAccount
end)

local emailOtp = module.EmailOtp
local v10

if module5() then
	v10 = createLazyComponent(function()
		return require("@luauforge/bundled/gxT").EmailOtpOverlay
	end)
end

v5[emailOtp] = v10

v5[module.VngContactInfoFormWebviewPopup] = createLazyComponent(function()
	return require("@luauforge/deferred/hYn")
end)

local newAppAvailableModal = module.NewAppAvailableModal
local v11

if module7() then
	v11 = createLazyComponent(function()
		return require("@luauforge/deferred/hYs")
	end)
end

v5[newAppAvailableModal] = v11

local accountIneligibleLoginModal = module.AccountIneligibleLoginModal
local v12

if fFlagEnableAccountIneligibleLoginModal then
	v12 = createLazyComponent(function()
		return require("@luauforge/bundled/hYt")
	end)
end

v5[accountIneligibleLoginModal] = v12

local accountSwitchingErrorOverlay = module.AccountSwitchingErrorOverlay
local v13

if module8 then
	v13 = createLazyComponent(function()
		return require("@luauforge/bundled/ghc").AccountSwitchingErrorOverlay
	end)
end

v5[accountSwitchingErrorOverlay] = v13

v5[module.CloseOnlyInteractiveAlert] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").CloseOnlyInteractiveAlert
end)

v5[module.ConfirmationDialog] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").ConfirmationDialog
end)

v5[module.PlayButtonUpsellDialog] = createLazyComponent(function()
	return require("@luauforge/bundled/fIC").PlayButtonUpsellDialog
end)

local cloudClientOfferSheet = module.CloudClientOfferSheet
local v14

if fFlagLuaAppCloudClientPlayButtonOffer then
	v14 = createLazyComponent(function()
		return require("@luauforge/bundled/hYu").CloudClientOfferSheet
	end)
end

v5[cloudClientOfferSheet] = v14

local squadPrompt = module.SquadPrompt
local v15

if getFFlagIsSquadEnabled() then
	v15 = createLazyComponent(function()
		return require("@luauforge/deferred/hla").SquadPrompt
	end)
end

v5[squadPrompt] = v15

local vngComplianceLoadingPopup = module.VngComplianceLoadingPopup
local v16

if getFFlagUseUpdatedVNGAgreementsWorkflow() then
	v16 = createLazyComponent(function()
		return require("@luauforge/deferred/hYq")
	end)
end

v5[vngComplianceLoadingPopup] = v16

local kisaPopUpAgreements = module.KISAPopUpAgreements
local v17

if module9 then
	v17 = createLazyComponent(function()
		return require("@luauforge/bundled/gvl").KISAPopUpAgreements
	end)
end

v5[kisaPopUpAgreements] = v17

v5[module.ItemsReceivedAlert] = createLazyComponent(function()
	return require("@luauforge/deferred/hYv").ItemsReceivedAlert
end)

local vngAppUpsell = module.VngAppUpsell
local v18

if fFlagLuaAppHomeVngAppUpsell then
	v18 = createLazyComponent(function()
		return require("@luauforge/deferred/hYE")
	end)
end

v5[vngAppUpsell] = v18

v5[module.SearchPageOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hYF")
end)

local gamePlayerFeedbackForm = module.GamePlayerFeedbackForm
local v19

if getFFlagEdpPlayerFeedbackEnabled() then
	v19 = createLazyComponent(function()
		return require("@luauforge/deferred/gDt").GamePlayerFeedbackFormModal
	end)
end

v5[gamePlayerFeedbackForm] = v19

v5[module.ReminderOfNormsPopup] = createLazyComponent(function()
	return require("@luauforge/bundled/hYK")
end)

v5[module.GameFilterMenuDropdown] = createLazyComponent(function()
	return require("@luauforge/bundled/dCT").FilterMenuDropdown
end)

v5[module.SettingsPermissionInteractiveAlert] = createLazyComponent(function()
	return require("@luauforge/bundled/eoT").Components.SettingsPermissionInteractiveAlert
end)

local bugReporter = module.BugReporter
local v20

if getFFlagEnableInAppBugReporting() then
	v20 = createLazyComponent(function()
		return require("@luauforge/bundled/hYR").BugReporterModalContainer
	end)
end

v5[bugReporter] = v20

v5[module.InAppIntervention] = createLazyComponent(function()
	return require("@luauforge/bundled/hZH").InAppInterventionContainer
end)

local dynamicAbuseReport = module.DynamicAbuseReport
local v21

if fFlagEnableAbuseReportRevampFlow then
	v21 = createLazyComponent(function()
		return require("@luauforge/deferred/iaf")
	end)
end

v5[dynamicAbuseReport] = v21

v5[module.AccountReactivationPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/gzI").AccountReactivationPrompt
end)

local magicLoginApprovePopup = module.MagicLoginApprovePopup
local v22

if fFlagEnableMagicLogin then
	v22 = createLazyComponent(function()
		return require("@luauforge/bundled/gjC").MagicLoginApprovePopup
	end)
end

v5[magicLoginApprovePopup] = v22

local magicLoginRequestPopup = module.MagicLoginRequestPopup
local v23

if fFlagEnableMagicLogin then
	v23 = createLazyComponent(function()
		return require("@luauforge/bundled/gjC").MagicLoginRequestPopup
	end)
end

v5[magicLoginRequestPopup] = v23

local deviceSelectorPeekView = module.DeviceSelectorPeekView
local v24

if fFlagEnableMagicLogin then
	v24 = createLazyComponent(function()
		return require("@luauforge/bundled/gjC").DeviceSelectorPeekView
	end)
end

v5[deviceSelectorPeekView] = v24

v5[module.AccountLinkingAlert] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AuthCommon").Components.AccountLinkingAlert
end)

v5[module.CheckboxFeedbackFormModal] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").CheckboxFeedbackFormModal
end)

local textFeedbackFormModal = module.TextFeedbackFormModal
local v25

if fFlagLuaAppTextFeedbackFormModal then
	v25 = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/AppBlox").TextFeedbackFormModal
	end)
end

v5[textFeedbackFormModal] = v25

v5[module.ProvideFeedbackToast] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").ProvideFeedbackToast
end)

v5[module.EconomicRestrictionPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/iag")
end)

v5[module.UnifiedProductPurchaseModal] = createLazyComponent(function()
	return require("@luauforge/deferred/fCO").UnifiedPurchasePromptContainer
end)

v5[module.AccountLockModal] = createLazyComponent(function()
	return require("@luauforge/deferred/gXe").AccountLockModal
end)

local sduiModal = module.SduiModal
local v26

if fFlagLuaAppsServerTriggeredModals then
	v26 = createLazyComponent(function()
		return require("@luauforge/bundled/fBo").SduiModal
	end)
end

v5[sduiModal] = v26

local sduiPromptModal = module.SduiPromptModal
local v27

if fFlagEnableSduiV2HomepagePrompts or fFlagPromptsHandlerEnabled then
	v27 = createLazyComponent(function()
		return require("@luauforge/bundled/fBo").PromptsContainer
	end)
end

v5[sduiPromptModal] = v27

v5[module.SduiOverlay] = createLazyComponent(function()
	return require("@luauforge/bundled/dXB").SduiOverlayEntryPoint
end)

v5[module.SignUpExitModal] = createLazyComponent(function()
	return require("@luauforge/bundled/grL").Components.SignUpExitModal
end)

v5[module.SocialUpsellOverlay] = createLazyComponent(function()
	return require("@luauforge/bundled/fDy").InAppSocialUpsellOverlayWrapper
end)

local notificationsModal = module.NotificationsModal
local v28

if fFlagEnableSystemTrayModals then
	v28 = createLazyComponent(function()
		return require("@luauforge/deferred/iah")
	end)
end

v5[notificationsModal] = v28

local systemTrayModal = module.SystemTrayModal
local v29

if fFlagEnableSystemTrayModals then
	v29 = createLazyComponent(function()
		return require("@luauforge/deferred/iai")
	end)
end

v5[systemTrayModal] = v29

v5[module.WhyThisAdModal] = createLazyComponent(function()
	return require("@luauforge/deferred/iaj").WhyThisAdModal
end)

local pinExperienceResultSnackbar = module.PinExperienceResultSnackbar
local v30

if fFlagPinShortcutEnableOnCompleteCallback then
	v30 = createLazyComponent(function()
		return require("@luauforge/bundled/hXh").PinExperienceResultSnackbar
	end)
end

v5[pinExperienceResultSnackbar] = v30

return { OverlayComponent = v5 }
