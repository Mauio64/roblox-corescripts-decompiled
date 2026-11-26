local module = require("@luauforge/bundled/fvX")
local module2 = require("@luauforge/bundled/grc")
local module3 = require("@luauforge/bundled/grd")
local module4 = require("@luauforge/bundled/gre")
local upsellCardModalAction = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/upsellCardModalAction")
local module6 = require("@luauforge/bundled/grg")
local upsellCardFormInteraction = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/DuplicateAnalytics/upsellCardFormInteraction")
local module8 = require("@luauforge/bundled/gri")
local module9 = require("@luauforge/bundled/grj")
local module10 = require("@luauforge/bundled/ecq")
local module11 = require("@luauforge/bundled/fzS")
local module12 = require("@luauforge/bundled/grk")
local module13 = require("@luauforge/bundled/grl")
local module14 = require("@luauforge/bundled/gif")

local module15 = require("@luauforge/bundled/grm")

local module16 = require("@luauforge/bundled/grn")
local module17 = require("@luauforge/bundled/gro")
local module18 = require("@luauforge/bundled/grp")
local module19 = require("@luauforge/bundled/grq")
local module20 = require("@luauforge/bundled/grr")
local module21 = require("@luauforge/bundled/grs")
local module22 = require("@luauforge/bundled/grt")

return {
	get = function(p2)
		local v5 = module10.get(p2)

		local v6 = {}

		function v6.reportScreenLoaded(p3)
			module8(v5.EventStream, p3)
		end

		function v6.reportAuthPageload(p3, p4, p5, p6)
			module16(v5.EventStream, p3, p4, p5, p6)
		end

		function v6.reportAuthModalShown(p3, p4)
			module18(v5.EventStream, p3, p4)
		end

		function v6.reportAuthClientError(p3, p4, p5, p6)
			if p6 == nil or not require("@luauforge/bundled/gru").Flags.FFlagLandingAndAccountPickerSsoTelemetry then
				module17(v5.EventStream, p3, p4, p5)
			else
				module17(v5.EventStream, p3, p4, p5, p6)
			end
		end

		function v6.reportAuthButtonClick(p3, p4, p5, p6, p7, p8, p9)
			module19(v5.EventStream, p3, p4, p5, p6, p7, p8, p9)
		end

		function v6.reportAuthButtonShown(p3, p4, p5, p6, p7)
			module20(v5.EventStream, p3, p4, p5, p6, p7)
		end

		function v6:reportModalShown(p4)
			module3(v5.EventStream, self, module11.ActionType.Shown, p4)

			local v7 = { origin = p4 }

			if module13() then
				v5.EventStream:setRBXEventStream(self, module11.AuthEventName.AuthModalShown, v7)
			end
		end

		function v6.reportModalShownWithSection(p3, p4, p5)
			upsellCardModalAction(v5.EventStream, p3, "", module11.ActionType.Shown, p4, p5)
		end

		function v6.reportModalShownWithSectionAndError(p3, p4, p5, p6, p7)
			upsellCardModalAction(v5.EventStream, p3, p4, module11.ActionType.Shown, p5, p6, p7)
		end

		function v6.reportModalDismissed(p3, p4)
			module3(v5.EventStream, p3, module11.ActionType.Dismiss, p4)
		end

		function v6.reportModalDismissedWithSection(p3, p4, p5)
			upsellCardModalAction(v5.EventStream, p3, "", module11.ActionType.Dismiss, p4, p5)
		end

		function v6.reportModalActionWithSection(p3, p4, p5, p6, p7, p8)
			upsellCardModalAction(v5.EventStream, p3, p4, p5, p6, p7, p8)
		end

		function v6.reportBirthdaySelection(p3)
			local submit = module11.ActionType.Submit
			module2(v5.EventStream, p3, module11.Field.BirthdayYear, submit)
			module2(v5.EventStream, p3, module11.Field.BirthdayMonth, submit)
			module2(v5.EventStream, p3, module11.Field.BirthdayDay, submit)
		end

		function v6.reportAgeFocus(p3)
			module2(v5.EventStream, p3, module11.Field.BirthdayAge, module11.ActionType.Focus)
		end

		function v6.reportYearFocus(p3)
			module2(v5.EventStream, p3, module11.Field.BirthdayYear, module11.ActionType.Focus)
		end

		function v6.reportUsernameFocus(p3)
			module2(v5.EventStream, p3, module11.Field.Username, module11.ActionType.Focus)
		end

		function v6.reportDisplayNameFocus(p3)
			if module15 then
				module22(
					v5.EventStream,
					module11.Context.SinglePageSignUpScreen,
					module11.Field.DisplayName,
					module11.ActionType.Focus
				)
			else
				module2(v5.EventStream, p3, module11.Field.DisplayName, module11.ActionType.Focus)
			end
		end

		function v6.reportPasswordFocus(p3)
			module2(v5.EventStream, p3, module11.Field.Password, module11.ActionType.Focus)
		end

		function v6.report2SVCodeFocus(p3)
			module2(v5.EventStream, p3, module11.Field.TwoStepAuthCode, module11.ActionType.Focus)
		end

		function v6.reportFocus(p3, p4, p5)
			module2(v5.EventStream, p3, p4, module11.ActionType.Focus, p5)
		end

		function v6.report2SVInvalidCode(p3, p4)
			module9(v5.EventStream, p3, module11.Field.TwoStepAuthCode, p4)
		end

		function v6.reportErrorMessageShown(p3, p4, p5)
			module2(v5.EventStream, p3, p4, module11.ActionType.Shown, p5)
		end

		function v6.reportInteractWithAction(p3, p4, p5, p6, p7)
			module2(v5.EventStream, p3, p4, p5, p6, p7)
		end

		function v6.reportInteractWithActionAndSection(p3, p4, p5, p6, p7, p8)
			upsellCardFormInteraction(v5.EventStream, p3, p4, p5, p6, p7, p8)
		end

		function v6.reportSignUpButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.SignUp)
		end

		function v6.reportLogInButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.LogIn)
		end

		function v6.reportSwitchAccountButtonClicked(p3)
			v6.reportAuthButtonClick(p3, module11.Button.SwitchAccounts, nil)
		end

		function v6.reportContinueButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.Continue)
		end

		function v6.reportDismissCornerXButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.DismissCornerX)
		end

		function v6.reportForgotPasswordButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.ForgotPassword)
		end

		function v6.report2SVHelpButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.NeedHelpLink)
		end

		function v6.reportResendCodeButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.ResendCode)
		end

		function v6.reportRememberDeviceButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.RememberDevice)
		end

		function v6.reportShowPasswordButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.ShowPassword)
		end

		function v6.reportHidePasswordButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.HidePassword)
		end

		function v6.reportAvatarSelectedButtonClicked(p3, p4)
			module(v5.EventStream, p3, module11.Button.AvatarSelected, p4)
		end

		function v6.reportWeChatButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.WeChat)
		end

		function v6.reportQQButtonClicked(p3)
			module(v5.EventStream, p3, module11.Button.QQ)
		end

		function v6.reportButtonClicked(p3, p4)
			module(v5.EventStream, p3, p4)
		end

		function v6.reportButtonClickedWithCType(p3, p4, p5)
			module4(v5.EventStream, p3, p4, nil, p5)
		end

		function v6.reportButtonClickedWithSectionAndOrigin(p3, p4, p5, p6)
			module6(v5.EventStream, p3, p4, nil, p5, p6)
		end

		function v6.reportUsernameSuggestionClicked(p3, p4, p5, p6)
			module12(v5.EventStream, p3, p4, p5, p6)
		end

		function v6.reportUsernameSuggestionShown(p3, p4, p5, p6)
			module21(v5.EventStream, p3, p4, p5, p6)
		end

		function v6.reportDisplayNameFieldLoaded(p3, p4, p5)
			module14("DisplayNameFieldLoaded", 1)

			module22(v5.EventStream, p3, p4, p5)
		end

		function v6.reportDisplayNameFieldBypassed(p3, p4)
			module14(p4, 1)

			module17(v5.EventStream, p3, p4)
		end

		function v6.reportUsernameGenerationFailed(p3, p4)
			module14(p4, 1)

			module17(v5.EventStream, p3, p4)
		end

		function v6.reportAuthFormInteraction(p3, p4, p5, p6, p7)
			module22(v5.EventStream, p3, p4, p5, p6, p7)
		end

		return v6
	end
}
