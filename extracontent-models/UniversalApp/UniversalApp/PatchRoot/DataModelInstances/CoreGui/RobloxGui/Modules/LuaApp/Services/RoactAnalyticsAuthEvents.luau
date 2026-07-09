local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local buttonClick = require(Modules.LuaApp.Analytics.Events.buttonClick)
local formInteraction = require(Modules.LuaApp.Analytics.Events.formInteraction)
local modalAction = require(Modules.LuaApp.Analytics.Events.modalAction)
local crossDeviceEnterCodeButtonClick = require(Modules.LuaApp.Analytics.Events.Auth.crossDeviceEnterCodeButtonClick)
local upsellCardModalAction = require(Modules.LuaApp.Analytics.Events.Auth.upsellCardModalAction)
local upsellCardButtonClick = require(Modules.LuaApp.Analytics.Events.Auth.upsellCardButtonClick)
local upsellCardFormInteraction = require(Modules.LuaApp.Analytics.Events.Auth.upsellCardFormInteraction)
local screenLoaded = require(Modules.LuaApp.Analytics.Events.screenLoaded)
local formFieldValidation = require(Modules.LuaApp.Analytics.Events.formFieldValidation)
local RoactAnalytics = require(Modules.LuaApp.Services.RoactAnalytics)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local usernameSuggestionClick = require(Modules.LuaApp.Analytics.Events.usernameSuggestionClick)
local GetFFlagAuthNewModalSchematization = require(Modules.LuaApp.Flags.GetFFlagAuthNewModalSchematization)
local reportEphemeralCounter = require(Modules.LuaApp.Analytics.Events.reportEphemeralCounter)
local FFlagSignupDisplayNameLogging = require(Modules.LuaApp.Components.Authentication.Flags.FFlagSignupDisplayNameLogging)
local FFlagEnableAuthButtonShownEvent = require(CorePackages.Workspace.Packages.SharedFlags).FFlagEnableAuthButtonShownEvent
local authPageLoad = require(Modules.LuaApp.Analytics.Events.Auth.authPageLoad)
local authClientError = require(Modules.LuaApp.Analytics.Events.Auth.authClientError)
local authModalShown = require(Modules.LuaApp.Analytics.Events.Auth.authModalShown)
local authButtonClick = require(Modules.LuaApp.Analytics.Events.Auth.authButtonClick)
local authButtonShown = require(Modules.LuaApp.Analytics.Events.Auth.authButtonShown)
local usernameSuggestionShown = require(Modules.LuaApp.Analytics.Events.Auth.usernameSuggestionShown)
local authFormInteraction = require(Modules.LuaApp.Analytics.Events.Auth.authFormInteraction)

return {
	get = function(p1) -- line: 38
		-- upvalues: RoactAnalytics (copy), screenLoaded (copy), authPageLoad (copy), authModalShown (copy), authClientError (copy), authButtonClick (copy), FFlagEnableAuthButtonShownEvent (copy), authButtonShown (copy), modalAction (copy), EventStreamConstants (copy), GetFFlagAuthNewModalSchematization (copy), upsellCardModalAction (copy), formInteraction (copy), FFlagSignupDisplayNameLogging (copy), authFormInteraction (copy), formFieldValidation (copy), upsellCardFormInteraction (copy), buttonClick (copy), crossDeviceEnterCodeButtonClick (copy), upsellCardButtonClick (copy), usernameSuggestionClick (copy), usernameSuggestionShown (copy), reportEphemeralCounter (copy)
		local v27 = RoactAnalytics.get(p1)
		local t2 = {
			reportScreenLoaded = function(p2) -- line: 45
				-- upvalues: screenLoaded (copy), v27 (copy)
				screenLoaded(v27.EventStream, p2)
			end,
			reportAuthPageload = function(p3, p4, p5) -- line: 49
				-- upvalues: authPageLoad (copy), v27 (copy)
				authPageLoad(v27.EventStream, p3, p4, p5)
			end,
			reportAuthModalShown = function(p6, p7) -- line: 54
				-- upvalues: authModalShown (copy), v27 (copy)
				authModalShown(v27.EventStream, p6, p7)
			end,
			reportAuthClientError = function(p8, p9, p10) -- line: 59
				-- upvalues: authClientError (copy), v27 (copy)
				authClientError(v27.EventStream, p8, p9, p10)
			end,
			reportAuthButtonClick = function(p11, p12, p13, p14, p15, p16, p17) -- line: 63
				-- upvalues: authButtonClick (copy), v27 (copy)
				authButtonClick(v27.EventStream, p11, p12, p13, p14, p15, p16, p17)
			end,
			reportAuthButtonShown = function(p18, p19, p20, p21, p22) -- line: 67
				-- upvalues: FFlagEnableAuthButtonShownEvent (copy), authButtonShown (copy), v27 (copy)
				if not FFlagEnableAuthButtonShownEvent then
					return
				end

				authButtonShown(v27.EventStream, p18, p19, p20, p21, p22)
			end,
			reportModalShown = function(p23, p24) -- line: 75
				-- upvalues: modalAction (copy), v27 (copy), EventStreamConstants (copy), GetFFlagAuthNewModalSchematization (copy)
				modalAction(v27.EventStream, p23, EventStreamConstants.ActionType.Shown, p24)

				local t1 = {
					origin = p24
				}

				if GetFFlagAuthNewModalSchematization() then
					v27.EventStream:setRBXEventStream(p23, EventStreamConstants.AuthEventName.AuthModalShown, t1)
				end
			end,
			reportModalShownWithSection = function(p25, p26, p27) -- line: 91
				-- upvalues: upsellCardModalAction (copy), v27 (copy), EventStreamConstants (copy)
				upsellCardModalAction(v27.EventStream, p25, "", EventStreamConstants.ActionType.Shown, p26, p27)
			end,
			reportModalShownWithSectionAndError = function(p28, p29, p30, p31, p32) -- line: 102
				-- upvalues: upsellCardModalAction (copy), v27 (copy), EventStreamConstants (copy)
				upsellCardModalAction(v27.EventStream, p28, p29, EventStreamConstants.ActionType.Shown, p30, p31, p32)
			end,
			reportModalDismissed = function(p33, p34) -- line: 114
				-- upvalues: modalAction (copy), v27 (copy), EventStreamConstants (copy)
				modalAction(v27.EventStream, p33, EventStreamConstants.ActionType.Dismiss, p34)
			end,
			reportModalDismissedWithSection = function(p35, p36, p37) -- line: 118
				-- upvalues: upsellCardModalAction (copy), v27 (copy), EventStreamConstants (copy)
				upsellCardModalAction(v27.EventStream, p35, "", EventStreamConstants.ActionType.Dismiss, p36, p37)
			end,
			reportModalActionWithSection = function(p38, p39, p40, p41, p42, p43) -- line: 129
				-- upvalues: upsellCardModalAction (copy), v27 (copy)
				upsellCardModalAction(v27.EventStream, p38, p39, p40, p41, p42, p43)
			end,
			reportBirthdaySelection = function(p44) -- line: 135
				-- upvalues: EventStreamConstants (copy), formInteraction (copy), v27 (copy)
				local Submit = EventStreamConstants.ActionType.Submit

				formInteraction(v27.EventStream, p44, EventStreamConstants.Field.BirthdayYear, Submit)
				formInteraction(v27.EventStream, p44, EventStreamConstants.Field.BirthdayMonth, Submit)
				formInteraction(v27.EventStream, p44, EventStreamConstants.Field.BirthdayDay, Submit)
			end,
			reportAgeFocus = function(p45) -- line: 142
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p45, EventStreamConstants.Field.BirthdayAge, EventStreamConstants.ActionType.Focus)
			end,
			reportYearFocus = function(p46) -- line: 151
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p46, EventStreamConstants.Field.BirthdayYear, EventStreamConstants.ActionType.Focus)
			end,
			reportUsernameFocus = function(p47) -- line: 160
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p47, EventStreamConstants.Field.Username, EventStreamConstants.ActionType.Focus)
			end,
			reportDisplayNameFocus = function(p48) -- line: 169
				-- upvalues: FFlagSignupDisplayNameLogging (copy), authFormInteraction (copy), v27 (copy), EventStreamConstants (copy), formInteraction (copy)
				if FFlagSignupDisplayNameLogging then
					authFormInteraction(v27.EventStream, EventStreamConstants.Context.SinglePageSignUpScreen, EventStreamConstants.Field.DisplayName, EventStreamConstants.ActionType.Focus)

					return
				end

				formInteraction(v27.EventStream, p48, EventStreamConstants.Field.DisplayName, EventStreamConstants.ActionType.Focus)
			end,
			reportPasswordFocus = function(p49) -- line: 187
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p49, EventStreamConstants.Field.Password, EventStreamConstants.ActionType.Focus)
			end,
			report2SVCodeFocus = function(p50) -- line: 196
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p50, EventStreamConstants.Field.TwoStepAuthCode, EventStreamConstants.ActionType.Focus)
			end,
			reportFocus = function(p51, p52, p53) -- line: 205
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p51, p52, EventStreamConstants.ActionType.Focus, p53)
			end,
			report2SVInvalidCode = function(p54, p55) -- line: 215
				-- upvalues: formFieldValidation (copy), v27 (copy), EventStreamConstants (copy)
				formFieldValidation(v27.EventStream, p54, EventStreamConstants.Field.TwoStepAuthCode, p55)
			end,
			reportErrorMessageShown = function(p56, p57, p58) -- line: 224
				-- upvalues: formInteraction (copy), v27 (copy), EventStreamConstants (copy)
				formInteraction(v27.EventStream, p56, p57, EventStreamConstants.ActionType.Shown, p58)
			end,
			reportInteractWithAction = function(p59, p60, p61, p62, p63) -- line: 234
				-- upvalues: formInteraction (copy), v27 (copy)
				formInteraction(v27.EventStream, p59, p60, p61, p62, p63)
			end,
			reportInteractWithActionAndSection = function(p64, p65, p66, p67, p68, p69) -- line: 238
				-- upvalues: upsellCardFormInteraction (copy), v27 (copy)
				upsellCardFormInteraction(v27.EventStream, p64, p65, p66, p67, p68, p69)
			end,
			reportSignUpButtonClicked = function(p70) -- line: 251
				-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
				buttonClick(v27.EventStream, p70, EventStreamConstants.Button.SignUp)
			end,
			reportLogInButtonClicked = function(p71) -- line: 255
				-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
				buttonClick(v27.EventStream, p71, EventStreamConstants.Button.LogIn)
			end
		}

		function t2.reportSwitchAccountButtonClicked(p72) -- line: 259
			-- upvalues: t2 (copy), EventStreamConstants (copy)
			t2.reportAuthButtonClick(p72, EventStreamConstants.Button.SwitchAccounts, nil)
		end
		function t2.reportContinueButtonClicked(p73) -- line: 268
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p73, EventStreamConstants.Button.Continue)
		end
		function t2.reportDismissCornerXButtonClicked(p74) -- line: 272
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p74, EventStreamConstants.Button.DismissCornerX)
		end
		function t2.reportForgotPasswordButtonClicked(p75) -- line: 276
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p75, EventStreamConstants.Button.ForgotPassword)
		end
		function t2.report2SVHelpButtonClicked(p76) -- line: 280
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p76, EventStreamConstants.Button.NeedHelpLink)
		end
		function t2.reportResendCodeButtonClicked(p77) -- line: 284
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p77, EventStreamConstants.Button.ResendCode)
		end
		function t2.reportRememberDeviceButtonClicked(p78) -- line: 288
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p78, EventStreamConstants.Button.RememberDevice)
		end
		function t2.reportShowPasswordButtonClicked(p79) -- line: 292
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p79, EventStreamConstants.Button.ShowPassword)
		end
		function t2.reportHidePasswordButtonClicked(p80) -- line: 296
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p80, EventStreamConstants.Button.HidePassword)
		end
		function t2.reportAvatarSelectedButtonClicked(p81, p82) -- line: 300
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p81, EventStreamConstants.Button.AvatarSelected, p82)
		end
		function t2.reportWeChatButtonClicked(p83) -- line: 304
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p83, EventStreamConstants.Button.WeChat)
		end
		function t2.reportQQButtonClicked(p84) -- line: 308
			-- upvalues: buttonClick (copy), v27 (copy), EventStreamConstants (copy)
			buttonClick(v27.EventStream, p84, EventStreamConstants.Button.QQ)
		end
		function t2.reportButtonClicked(p85, p86) -- line: 312
			-- upvalues: buttonClick (copy), v27 (copy)
			buttonClick(v27.EventStream, p85, p86)
		end
		function t2.reportButtonClickedWithCType(p87, p88, p89) -- line: 316
			-- upvalues: crossDeviceEnterCodeButtonClick (copy), v27 (copy)
			crossDeviceEnterCodeButtonClick(v27.EventStream, p87, p88, nil, p89)
		end
		function t2.reportButtonClickedWithSectionAndOrigin(p90, p91, p92, p93) -- line: 320
			-- upvalues: upsellCardButtonClick (copy), v27 (copy)
			upsellCardButtonClick(v27.EventStream, p90, p91, nil, p92, p93)
		end
		function t2.reportUsernameSuggestionClicked(p94, p95, p96, p97) -- line: 324
			-- upvalues: usernameSuggestionClick (copy), v27 (copy)
			usernameSuggestionClick(v27.EventStream, p94, p95, p96, p97)
		end
		function t2.reportUsernameSuggestionShown(s1: string, s2: string, t3: {[any]: any}, s3: string) -- line: 328
			-- upvalues: usernameSuggestionShown (copy), v27 (copy)
			usernameSuggestionShown(v27.EventStream, s1, s2, t3, s3)
		end
		function t2.reportDisplayNameFieldLoaded(s4: string, s5: string, s6: string) -- line: 337
			-- upvalues: reportEphemeralCounter (copy), authFormInteraction (copy), v27 (copy)
			reportEphemeralCounter("DisplayNameFieldLoaded", 1)
			authFormInteraction(v27.EventStream, s4, s5, s6)
		end
		function t2.reportDisplayNameFieldBypassed(s7: string, s8: string) -- line: 343
			-- upvalues: reportEphemeralCounter (copy), authClientError (copy), v27 (copy)
			reportEphemeralCounter(s8, 1)
			authClientError(v27.EventStream, s7, s8)
		end
		function t2.reportUsernameGenerationFailed(s9: string, s10: string) -- line: 349
			-- upvalues: reportEphemeralCounter (copy), authClientError (copy), v27 (copy)
			reportEphemeralCounter(s10, 1)
			authClientError(v27.EventStream, s9, s10)
		end
		function t2.reportAuthFormInteraction(s11: string, s12: string?, s13: string?, s14: string?, s15: string?) -- line: 355
			-- upvalues: authFormInteraction (copy), v27 (copy)
			authFormInteraction(v27.EventStream, s11, s12, s13, s14, s15)
		end

		return t2
	end
}
