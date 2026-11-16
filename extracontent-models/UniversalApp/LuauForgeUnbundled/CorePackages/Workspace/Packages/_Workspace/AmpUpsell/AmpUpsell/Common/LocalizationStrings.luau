local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Enums")
require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/Types")
local actionTypeEnum = Enums.ActionTypeEnum
local userSettingsSettingNameEnum = Enums.UserSettingsSettingNameEnum
local vpcErrorCategoriesEnum = Enums.VPCErrorCategoriesEnum

local v5 = {
	[actionTypeEnum.GovernmentId] = {
		title = "Feature.AgeVerificationUpsell.Modal.Title",
		message = "Feature.AgeVerificationUpsell.Modal.ContentText",
		buttonCancel = "Feature.AgeVerificationUpsell.Button.Cancel",
		buttonSettings = "Feature.AgeVerificationUpsell.Button.Settings"
	},
	[actionTypeEnum.Phone] = {
		title = "Amp.AccountSettingsUpsell.Phone.Modal.Title",
		message = "Amp.AccountSettingsUpsell.Phone.Modal.ContentText",
		buttonCancel = "Amp.AccountSettingsUpsell.Phone.Button.Cancel",
		buttonSettings = "Amp.AccountSettingsUpsell.Phone.Button.Settings"
	},
	[actionTypeEnum.Email] = {
		title = "Amp.AccountSettingsUpsell.Email.Modal.Title",
		message = "Amp.AccountSettingsUpsell.Email.Modal.ContentText",
		buttonCancel = "Amp.AccountSettingsUpsell.Email.Button.Cancel",
		buttonSettings = "Amp.AccountSettingsUpsell.Email.Button.Settings"
	},
	[actionTypeEnum.AddedEmail] = {
		title = "Amp.AccountSettingsUpsell.Email.Modal.Title",
		message = "Amp.AccountSettingsUpsell.Email.Modal.ContentText",
		buttonCancel = "Amp.AccountSettingsUpsell.Email.Button.Cancel",
		buttonSettings = "Amp.AccountSettingsUpsell.Email.Button.Settings"
	}
}

local v6 = {
	[userSettingsSettingNameEnum.AllowFacialAgeEstimation] = {
		title = "Feature.AgeVerificationUpsell.Title.AgeSettingsRedirect",
		message = "Feature.AgeVerificationUpsell.Body.AgeSettingsRedirect",
		buttonCancel = "Feature.AgeVerificationUpsell.Button.Cancel",
		buttonSettings = "Feature.AgeVerificationUpsell.Button.Continue"
	}
}

return {
	accountSettingsUpsellStringsFn = function(p2)
		local action = p2.action

		if action ~= actionTypeEnum.UserSettings then
			return v5[action]
		end

		local userSettings = p2.userSettings

		if userSettings and userSettings.settingName then
			return v6[userSettings.settingName]
		end

		return nil
	end,
	accountSettingsUpsellStrings = v5,
	idvWithQRCodeUpsellStrings = {
		title = "Amp.IDVUpsell.Modal.Title",
		beginText = "Amp.IDVUpsell.Modal.QRHeaderText",
		disclaimer = "Amp.IDVUpsell.Modal.Disclaimer",
		privacyLinkText = "Amp.IDVUpsell.Modal.PrivacyLinkText",
		idDirectionsHeader = "Amp.IDVUpsell.Directions.IDHeader",
		idDirectionsBody = "Amp.IDVUpsell.Directions.IDBody",
		phoneDirectionsHeader = "Amp.IDVUpsell.Directions.PhoneHeader",
		phoneDirectionsBody = "Amp.IDVUpsell.Directions.PhoneBody",
		privacyPageHeader = "Amp.IDVUpsell.PrivacyPageHeader",
		ageVerifyPrompt = "Verification.Identity.Label.AgeVerifyPrompt",
		verifyInBrowser = "Verification.Identity.Label.VerifyInBrowser",
		dontCloseWindowDisclaimer = "Verification.Identity.Label.PleaseDoNotClose",
		havingTroubleInfoText = "Verification.Identity.Label.HavingTroubleScanCode",
		startVerification = "Amp.IDVUpsell.Button.StartVerification",
		cancel = "Amp.IDVUpsell.Button.Cancel"
	},
	idvErrorScreenStrings = {
		timeout = "Amp.IDVErrorScreen.Timeout",
		declined = "Amp.IDVErrorScreen.Declined",
		retry = "Amp.IDVErrorScreen.Retry",
		close = "Amp.IDVErrorScreen.Close",
		title = "Amp.IDVErrorScreen.Title"
	},
	vpcUpsellGatherEmailStrings = {
		titleText = "Feature.Parents.Title.EnterParentEmailV2",
		buttonText = "Feature.Parents.Action.SendEmail",
		textFieldHeaderText = "Feature.Parents.Label.ParentEmail",
		errorText = "Feature.Parents.Message.InvalidEmail",
		emailPlaceholder = "Feature.Parents.Label.Email",
		privacyLinkText = "Amp.IDVUpsell.PrivacyPageHeader",
		childInstructions = "Feature.Parents.Description.EnterParentEmail.ChildInstructions",
		parentInstructionsPC = "Feature.Parents.Description.EnterParentEmail.PC",
		parentInstructionsNoPC = "Feature.Parents.Description.EnterParentEmail.NoPC"
	},
	vpcErrorCategoryToMessageStrings = {
		[vpcErrorCategoriesEnum.InternalVPCError] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.SomethingWentWrong"
		},
		[vpcErrorCategoriesEnum.InvalidEmail] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.EmailIneligible"
		},
		[vpcErrorCategoriesEnum.Flooded] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.TooManyAttempts"
		},
		[vpcErrorCategoriesEnum.SenderFlooded] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.TooManyAttemptAskParent"
		},
		[vpcErrorCategoriesEnum.ReceiverFlooded] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.TooManyAttempts"
		},
		[vpcErrorCategoriesEnum.BadUserInput] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.SomethingWentWrong"
		},
		[vpcErrorCategoriesEnum.UserStateRecoursePathMismatch] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.SomethingWentWrong"
		},
		[vpcErrorCategoriesEnum.SenderFloodedRequestCreated] = {
			title = "Amp.Upsell.Title.RequestSent",
			body = "Feature.Parents.Message.RequestCreatedEmailNotSent"
		},
		[vpcErrorCategoriesEnum.GenericError] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.SomethingWentWrong"
		},
		[vpcErrorCategoriesEnum.ConflictingPendingConsent] = {
			title = "Feature.Parents.Title.SomethingWentWrong",
			body = "Feature.Parents.Message.ConflictingPendingConsent"
		}
	},
	vpcErrorScreenStrings = {
		retryButton = "Amp.ErrorScreen.Retry",
		cancelButton = "Amp.ErrorScreen.Cancel",
		okButton = "CommonUI.Controls.Action.OK"
	},
	vpcConfirmationScreenStrings = {
		title = "Amp.Upsell.Title.RequestSent",
		oneParentBody = "Amp.Upsell.Message.EmailSent",
		multipleParentsBody = "Amp.Upsell.Message.EmailSentPluralParent",
		buttonText = "CommonUI.Controls.Action.OK"
	},
	vpcPrologueStrings = {
		title = "Amp.Upsell.Title.AskYourParent",
		bodyGeneric = "Amp.Upsell.Description.PrologueTextVpc",
		bodyPurchases = "Amp.Upsell.Description.PrologueEnablePurchase",
		bodyContentRestriction = "Amp.Upsell.Description.PrologueJoinExperience",
		bodyUnblock = "Amp.Upsell.Description.PrologueUnblockUser",
		buttonAsk = "Amp.Upsell.Action.AskNow",
		buttonCancel = "CommonUI.Controls.Action.Cancel"
	}
}
