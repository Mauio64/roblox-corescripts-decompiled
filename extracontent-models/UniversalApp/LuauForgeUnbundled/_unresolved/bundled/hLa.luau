local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/edO")
local RoactUtils = require("@game/CorePackages/Workspace/Packages/RoactUtils")
require(CorePackages.Packages.React)
local createLazyComponent = RoactUtils.Components.createLazyComponent

local module3 = require("@luauforge/bundled/hLb")
local module4 = require("@luauforge/bundled/hDS")
local module5 = require("@luauforge/bundled/hDU")

local getFFlagEdpPlayerFeedbackEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEdpPlayerFeedbackEnabled

local module6 = require("@luauforge/bundled/fsc")
local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagIsSquadEnabled

local fFlagLuaAppCloudClientPlayButtonOffer = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppCloudClientPlayButtonOffer
local module7 = require("@luauforge/bundled/hDY")

local fFlagDeprecatePeopleListContextualMenu = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagDeprecatePeopleListContextualMenu

local module8 = require("@luauforge/bundled/fDx")
local module9 = require("@luauforge/bundled/fQe")

local getFFlagUseUpdatedVNGAgreementsWorkflow = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagUseUpdatedVNGAgreementsWorkflow
local fFlagLuaAppHomeVngAppUpsell = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppHomeVngAppUpsell

local getFFlagEnableReminderOfNormsABTest = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableReminderOfNormsABTest

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
		return require("@luauforge/deferred/hLc")
	end),
	[module.VerifiedEnableVoice] = createLazyComponent(function()
		return require("@luauforge/deferred/hLj")
	end),
	[module.UserAgreementsUpdatedPopup] = createLazyComponent(function()
		return require("@luauforge/deferred/hLo")
	end),
	[module.VNGUserAgreementsPopup] = createLazyComponent(function()
		return require("@luauforge/deferred/hLv")
	end),
	[module.UserAgreementsSecondPrompt] = createLazyComponent(function()
		return require("@luauforge/deferred/hLy")
	end),
	[module.UserAgreementsPrompt] = createLazyComponent(function()
		return require("@luauforge/deferred/hLz")
	end),
	[module.TencentNoticePopup] = createLazyComponent(function()
		return require("@luauforge/deferred/hLA")
	end),
	[module.SimpleTextAlertPrompt] = createLazyComponent(function()
		return require("@luauforge/deferred/hLD")
	end),
	[module.SignUpBirthdayPickerOverlay] = createLazyComponent(function()
		return require("@luauforge/deferred/hLE")
	end),
	[module.PurchaseGameRobuxShortfall] = createLazyComponent(function()
		return require("@luauforge/deferred/hLG")
	end),
	[module.PurchaseGame] = createLazyComponent(function()
		return require("@luauforge/deferred/hLI")
	end),
	[module.PlacesList] = createLazyComponent(function()
		return require("@luauforge/deferred/hLO")
	end)
}

local peopleList = module.PeopleList
local v6

if not fFlagDeprecatePeopleListContextualMenu then
	v6 = createLazyComponent(function()
		return require("@luauforge/deferred/hMa")
	end)
end

v5[peopleList] = v6

v5[module.LoginPasswordResetPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hMd")
end)

v5[module.LoginEmailVerificationPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hMe")
end)

v5[module.UpdateRequiredPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hMh")
end)

v5[module.LeaveRobloxAlert] = createLazyComponent(function()
	return require("@luauforge/deferred/hMj")
end)

v5[module.ReportLogsOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hMk")
end)

v5[module.GameDetailsPlayWithFriends] = createLazyComponent(function()
	return require("@luauforge/deferred/hMq")
end)

v5[module.GameDetailMore] = createLazyComponent(function()
	return require("@luauforge/deferred/hMs")
end)

local gameDetailsSquad = module.GameDetailsSquad
local v7

if getFFlagIsSquadEnabled() then
	v7 = createLazyComponent(function()
		return require("@luauforge/deferred/hMB")
	end)
end

v5[gameDetailsSquad] = v7

v5[module.ExperienceGuidelinesExplained] = createLazyComponent(function()
	return require("@luauforge/deferred/hMC")
end)

v5[module.FindFriendsModal] = createLazyComponent(function()
	return require("@luauforge/bundled/coP").FindFriendsModal
end)

v5[module.EmailVerificationUpsellOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hMG")
end)

v5[module.PhoneVerificationUpsellOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/gxy").PhoneVerificationUpsellOverlay
end)

v5[module.PhoneVerificationUpsellOverlayWrapper] = createLazyComponent(function()
	return require("@luauforge/deferred/gxy").PhoneVerificationUpsellOverlayWrapper
end)

v5[module.VoicePhoneVerificationUpsellOverlayWrapper] = createLazyComponent(function()
	return require("@luauforge/deferred/gxy").VoicePhoneVerificationUpsellOverlayWrapper
end)

v5[module.DevSubMore] = createLazyComponent(function()
	return require("@luauforge/deferred/hMO")
end)

v5[module.DevSubConfirmCancel] = createLazyComponent(function()
	return require("@luauforge/deferred/hMR")
end)

v5[module.CrossDeviceLoginConfirmation] = createLazyComponent(function()
	return require("@luauforge/deferred/hMS")
end)

v5[module.CrossDeviceCodePrompt] = createLazyComponent(function()
	return require("@luauforge/bundled/hDw")
end)

v5[module.ContactsList] = createLazyComponent(function()
	return require("@luauforge/bundled/coP").ContactsList
end)

v5[module.ConfirmSignOut] = createLazyComponent(function()
	if module3() then
		return require("@luauforge/deferred/hMT")
	end

	return require("@luauforge/deferred/hMU")
end)

v5[module.CameraPermissionPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hMV")
end)

v5[module.AgreeToPhoneNumberVerification] = createLazyComponent(function()
	return require("@luauforge/deferred/hMW")
end)

v5[module.AccountAuthenticationFailureOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hMX")
end)

local accountSecurityPromptOverlay = module.AccountSecurityPromptOverlay
local v8

if module6() then
	v8 = createLazyComponent(function()
		return require("@luauforge/deferred/hMZ")
	end)
end

v5[accountSecurityPromptOverlay] = v8

v5[module.DiscoverabilityUpsell] = createLazyComponent(function()
	return require("@luauforge/bundled/cuU").DiscoverabilityOverlay
end)

v5[module.SurveyPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hNF")
end)

v5[module.PlayerContextualMenu] = createLazyComponent(function()
	return require("@luauforge/bundled/eeC").Component
end)

v5[module.GamepadDisconnected] = createLazyComponent(function()
	return require("@luauforge/bundled/fuE").Gamepad.GamepadDisconnectedModal
end)

v5[module.IapExperienceAnimator] = createLazyComponent(function()
	return require("@luauforge/deferred/gfP").Animator
end)

local accountSelector = module.AccountSelector
local v9

if module4() then
	v9 = createLazyComponent(function()
		return require("@luauforge/bundled/fPl").AccountSelectorOverlay
	end)
end

v5[accountSelector] = v9

v5[module.AccountSwitcher] = createLazyComponent(function()
	return require("@luauforge/bundled/fPl").AccountSwitchingSelectAccount
end)

local emailOtp = module.EmailOtp
local v10

if module5() then
	v10 = createLazyComponent(function()
		return require("@luauforge/bundled/fTp").EmailOtpOverlay
	end)
end

v5[emailOtp] = v10

v5[module.VngContactInfoFormWebviewPopup] = createLazyComponent(function()
	return require("@luauforge/deferred/hNG")
end)

local newAppAvailableModal = module.NewAppAvailableModal
local v11

if module7() then
	v11 = createLazyComponent(function()
		return require("@luauforge/deferred/hNL")
	end)
end

v5[newAppAvailableModal] = v11

local accountIneligibleLoginModal = module.AccountIneligibleLoginModal
local v12

if fFlagEnableAccountIneligibleLoginModal then
	v12 = createLazyComponent(function()
		return require("@luauforge/bundled/hNM")
	end)
end

v5[accountIneligibleLoginModal] = v12

local accountSwitchingErrorOverlay = module.AccountSwitchingErrorOverlay
local v13

if module8 then
	v13 = createLazyComponent(function()
		return require("@luauforge/bundled/fCJ").AccountSwitchingErrorOverlay
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
	return require("@luauforge/bundled/fWH").PlayButtonUpsellDialog
end)

local cloudClientOfferSheet = module.CloudClientOfferSheet
local v14

if fFlagLuaAppCloudClientPlayButtonOffer then
	v14 = createLazyComponent(function()
		return require("@luauforge/bundled/hNN").CloudClientOfferSheet
	end)
end

v5[cloudClientOfferSheet] = v14

local squadPrompt = module.SquadPrompt
local v15

if getFFlagIsSquadEnabled() then
	v15 = createLazyComponent(function()
		return require("@luauforge/deferred/gYN").SquadPrompt
	end)
end

v5[squadPrompt] = v15

local vngComplianceLoadingPopup = module.VngComplianceLoadingPopup
local v16

if getFFlagUseUpdatedVNGAgreementsWorkflow() then
	v16 = createLazyComponent(function()
		return require("@luauforge/deferred/hNJ")
	end)
end

v5[vngComplianceLoadingPopup] = v16

local kisaPopUpAgreements = module.KISAPopUpAgreements
local v17

if module9 then
	v17 = createLazyComponent(function()
		return require("@luauforge/bundled/fQJ").KISAPopUpAgreements
	end)
end

v5[kisaPopUpAgreements] = v17

v5[module.ItemsReceivedAlert] = createLazyComponent(function()
	return require("@luauforge/deferred/hNO").ItemsReceivedAlert
end)

local vngAppUpsell = module.VngAppUpsell
local v18

if fFlagLuaAppHomeVngAppUpsell then
	v18 = createLazyComponent(function()
		return require("@luauforge/deferred/hNX")
	end)
end

v5[vngAppUpsell] = v18

v5[module.SearchPageOverlay] = createLazyComponent(function()
	return require("@luauforge/deferred/hNY")
end)

local gamePlayerFeedbackForm = module.GamePlayerFeedbackForm
local v19

if getFFlagEdpPlayerFeedbackEnabled() then
	v19 = createLazyComponent(function()
		return require("@luauforge/deferred/fYx").GamePlayerFeedbackFormModal
	end)
end

v5[gamePlayerFeedbackForm] = v19

local reminderOfNormsPopup = module.ReminderOfNormsPopup
local v20

if getFFlagEnableReminderOfNormsABTest() then
	v20 = createLazyComponent(function()
		return require("@luauforge/bundled/hOd")
	end)
end

v5[reminderOfNormsPopup] = v20

v5[module.GameFilterMenuDropdown] = createLazyComponent(function()
	return require("@luauforge/bundled/dzO").FilterMenuDropdown
end)

v5[module.SettingsPermissionInteractiveAlert] = createLazyComponent(function()
	return require("@luauforge/bundled/elx").Components.SettingsPermissionInteractiveAlert
end)

local bugReporter = module.BugReporter
local v21

if getFFlagEnableInAppBugReporting() then
	v21 = createLazyComponent(function()
		return require("@luauforge/bundled/hOk").BugReporterModalContainer
	end)
end

v5[bugReporter] = v21

v5[module.InAppIntervention] = createLazyComponent(function()
	return require("@luauforge/bundled/hPa").InAppInterventionContainer
end)

local dynamicAbuseReport = module.DynamicAbuseReport
local v22

if fFlagEnableAbuseReportRevampFlow then
	v22 = createLazyComponent(function()
		return require("@luauforge/deferred/hPy")
	end)
end

v5[dynamicAbuseReport] = v22

v5[module.AccountReactivationPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/fUK").AccountReactivationPrompt
end)

local magicLoginApprovePopup = module.MagicLoginApprovePopup
local v23

if fFlagEnableMagicLogin then
	v23 = createLazyComponent(function()
		return require("@luauforge/bundled/fFi").MagicLoginApprovePopup
	end)
end

v5[magicLoginApprovePopup] = v23

local magicLoginRequestPopup = module.MagicLoginRequestPopup
local v24

if fFlagEnableMagicLogin then
	v24 = createLazyComponent(function()
		return require("@luauforge/bundled/fFi").MagicLoginRequestPopup
	end)
end

v5[magicLoginRequestPopup] = v24

local deviceSelectorPeekView = module.DeviceSelectorPeekView
local v25

if fFlagEnableMagicLogin then
	v25 = createLazyComponent(function()
		return require("@luauforge/bundled/fFi").DeviceSelectorPeekView
	end)
end

v5[deviceSelectorPeekView] = v25

v5[module.AccountLinkingAlert] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AuthCommon").Components.AccountLinkingAlert
end)

v5[module.CheckboxFeedbackFormModal] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").CheckboxFeedbackFormModal
end)

local textFeedbackFormModal = module.TextFeedbackFormModal
local v26

if fFlagLuaAppTextFeedbackFormModal then
	v26 = createLazyComponent(function()
		return require("@game/CorePackages/Workspace/Packages/AppBlox").TextFeedbackFormModal
	end)
end

v5[textFeedbackFormModal] = v26

v5[module.ProvideFeedbackToast] = createLazyComponent(function()
	return require("@game/CorePackages/Workspace/Packages/AppBlox").ProvideFeedbackToast
end)

v5[module.EconomicRestrictionPrompt] = createLazyComponent(function()
	return require("@luauforge/deferred/hPz")
end)

v5[module.UnifiedProductPurchaseModal] = createLazyComponent(function()
	return require("@luauforge/deferred/fvn").UnifiedPurchasePromptContainer
end)

v5[module.AccountLockModal] = createLazyComponent(function()
	return require("@luauforge/deferred/gwP").AccountLockModal
end)

local sduiModal = module.SduiModal
local v27

if fFlagLuaAppsServerTriggeredModals then
	v27 = createLazyComponent(function()
		return require("@luauforge/bundled/ftU").SduiModal
	end)
end

v5[sduiModal] = v27

local sduiPromptModal = module.SduiPromptModal
local v28

if fFlagEnableSduiV2HomepagePrompts or fFlagPromptsHandlerEnabled then
	v28 = createLazyComponent(function()
		return require("@luauforge/bundled/ftU").PromptsContainer
	end)
end

v5[sduiPromptModal] = v28

v5[module.SduiOverlay] = createLazyComponent(function()
	return require("@luauforge/bundled/dUe").SduiOverlayEntryPoint
end)

v5[module.SignUpExitModal] = createLazyComponent(function()
	return require("@luauforge/bundled/fNq").Components.SignUpExitModal
end)

v5[module.SocialUpsellOverlay] = createLazyComponent(function()
	return require("@luauforge/bundled/fvY").InAppSocialUpsellOverlayWrapper
end)

local notificationsModal = module.NotificationsModal
local v29

if fFlagEnableSystemTrayModals then
	v29 = createLazyComponent(function()
		return require("@luauforge/deferred/hPA")
	end)
end

v5[notificationsModal] = v29

local systemTrayModal = module.SystemTrayModal
local v30

if fFlagEnableSystemTrayModals then
	v30 = createLazyComponent(function()
		return require("@luauforge/deferred/hPB")
	end)
end

v5[systemTrayModal] = v30

v5[module.WhyThisAdModal] = createLazyComponent(function()
	return require("@luauforge/deferred/hPC").WhyThisAdModal
end)

local pinExperienceResultSnackbar = module.PinExperienceResultSnackbar
local v31

if fFlagPinShortcutEnableOnCompleteCallback then
	v31 = createLazyComponent(function()
		return require("@luauforge/bundled/hMA").PinExperienceResultSnackbar
	end)
end

v5[pinExperienceResultSnackbar] = v31

return { OverlayComponent = v5 }
