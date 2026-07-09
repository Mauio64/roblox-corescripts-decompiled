local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local RoactNetworking = require(Modules.LuaApp.Services.RoactNetworking)
local RoactServices = require(CorePackages.Workspace.Packages.RoactServices).RoactServices
local RoactAnalyticsAuthEvents = require(Modules.LuaApp.Services.RoactAnalyticsAuthEvents)
local RoactAppPolicy = require(CorePackages.Workspace.Packages.UniversalAppPolicy).RoactAppPolicy
local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withLocalization = require(Modules.LuaApp.withLocalization)
local AppPage = require(Modules.LuaApp.AppPage)
local TransitionAnimation = require(Modules.LuaApp.Enum.TransitionAnimation)
local CloseCentralOverlay = require(Modules.LuaApp.Thunks.CloseCentralOverlay)
local EmailVerificationUpsellState = require(script.Parent.EmailVerificationUpsellState)
local UpdateUserEmail = require(Modules.LuaApp.Thunks.Authentication.EmailVerification.UpdateUserEmail)
local SendVerificationEmailToUser = require(Modules.LuaApp.Thunks.Authentication.EmailVerification.SendVerificationEmailToUser)
local NavigateDown = require(Modules.LuaApp.Thunks.NavigateDown)
local FFlagSignalsNavP3Dispatch = require(CorePackages.Workspace.Packages.SharedFlags).FFlagSignalsNavP3Dispatch
local v21 = if not FFlagSignalsNavP3Dispatch then nil else require(CorePackages.Workspace.Packages.RobloxAppNavigation).NavigationCommands
local isStringEmail = require(Modules.LuaApp.Util.isStringEmail)
local EmailVerificationUpsellStep = require(script.Parent.EmailVerificationUpsellStep)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local GetFStringPrivacyPolicyUrl = require(Modules.LuaApp.Flags.GetFStringPrivacyPolicyUrl)
local GetFFlagEnablePrivacyPolicyForLogoutUpsell = require(Modules.LuaApp.Flags.GetFFlagEnablePrivacyPolicyForLogoutUpsell)
local UrlBuilder = require(CorePackages.Packages.UrlBuilder).UrlBuilder
local v28 = Roact.PureComponent:extend(script.Name)

local function getEffectiveIsLocalUserUnder13(p1) -- line: 44
	local emailUpsellLockedIsLocalUserUnder13 = p1.emailUpsellLockedIsLocalUserUnder13

	if emailUpsellLockedIsLocalUserUnder13 ~= nil then
		return emailUpsellLockedIsLocalUserUnder13
	end

	return p1.IsLocalUserUnder13
end

v28.defaultProps = {
	addEmailOver13TextKey = "Feature.VerificationUpsell.Description.AddEmailTextOver13",
	addEmailUnder13TextKey = "Feature.VerificationUpsell.Description.AddEmailTextUnder13",
	addEmailTitleKey = "Feature.VerificationUpsell.Heading.AddEmail",
	checkExistingEmailTitleKey = "Feature.VerificationUpsell.Heading.VerifyEmail",
	emailPlaceholderOver13Key = "Feature.VerificationUpsell.Label.EmailInputPlaceholderOver13",
	textLabelOver13Key = "Authentication.SignUp.Label.EmailAddress",
	emailPlaceholderUnder13Key = "Feature.VerificationUpsell.Label.EmailInputPlaceholderUnder13",
	emailPlaceholderUnder13KeyV2 = "Feature.VerificationUpsell.Label.EmailInputPlaceholderUnder13V2",
	useUpdatedModalDesign = false,
	eventContext = EventStreamConstants.Context.VerificationUpsell
}

function v28.init(p2) -- line: 65
	-- upvalues: EmailVerificationUpsellState (copy), EventStreamConstants (copy), isStringEmail (copy), GetFFlagEnablePrivacyPolicyForLogoutUpsell (copy), AppPage (copy), GetFStringPrivacyPolicyUrl (copy), TransitionAnimation (copy), UrlBuilder (copy), ButtonType (copy)
	local PromptUpdateEmail = EmailVerificationUpsellState.PromptUpdateEmail

	if p2.props.emailAddress then
		PromptUpdateEmail = EmailVerificationUpsellState.PromptCheckEmail
	end

	p2.potentialEmailAddress = nil
	p2.password = nil
	p2.emailWasUpdated = false
	p2.state = {
		upsellState = PromptUpdateEmail,
		emailAddress = p2.props.emailAddress or ""
	}

	function p2.closeOverlay() -- line: 81
		-- upvalues: p2 (copy)
		if p2.isMounted then
			p2.props.closeCentralOverlay()
			p2.props.authEventAnalytics.reportModalDismissedWithSection(p2.props.eventContext, p2.props.origin, p2.props.section)
		end
	end
	function p2.onUpdateEmailSecondaryButtonPressed() -- line: 92
		-- upvalues: p2 (copy), EventStreamConstants (copy)
		if p2.isMounted and p2.props.onUpdateEmailSecondaryButtonPressed then
			p2.props.onUpdateEmailSecondaryButtonPressed()
			p2.props.authEventAnalytics.reportInteractWithAction(p2.props.eventContext, "", EventStreamConstants.ActionType.Click, p2.props.origin, p2.props.onUpdateEmailSecondaryButtonPressedEvent)
		end
	end
	function p2.onPasswordChangedCallback(p3) -- line: 105
		-- upvalues: p2 (copy)
		p2.password = p3.Text
	end
	function p2.onEmailChangedCallback(p4) -- line: 109
		-- upvalues: p2 (copy)
		p2.potentialEmailAddress = p4.Text
	end
	function p2.onResendEmailPressed() -- line: 113
		-- upvalues: p2 (copy), EventStreamConstants (copy)
		if p2.isMounted then
			p2:setState({
				isInResendEmailCooldown = true
			})
			p2.props.sendVerificationEmailToUser(p2.props.networking):andThen(function() -- line: 121
				-- upvalues: p2 (copy)
				spawn(function() -- line: 123
					-- upvalues: p2 (copy)
					wait(20)
					p2.resetResendEmailState(true)
				end)
			end):catch(function() -- line: 129
				-- upvalues: p2 (copy)
				p2.resetResendEmailState(false)
			end)
			p2.props.authEventAnalytics.reportInteractWithActionAndSection(p2.props.eventContext, "", EventStreamConstants.ActionType.Click, p2.props.origin, EventStreamConstants.Button.ResendEmailConfirmation, "verifyEmail")
		end
	end
	function p2.resetResendEmailState(p5) -- line: 144
		-- upvalues: p2 (copy)
		local v69 = not p5 and "Feature.VerificationUpsell.Message.ConfirmationEmailNotSent" or ""

		if p2.isMounted then
			if v69 ~= "" then
				p2.props.authEventAnalytics.reportErrorMessageShown(p2.props.eventContext, "", p2.props.origin)
			end

			p2:setState({
				isInResendEmailCooldown = false,
				errorMessageKey = v69
			})
		end
	end
	function p2.onUpdateEmailSelected() -- line: 159
		-- upvalues: p2 (copy), EmailVerificationUpsellState (copy), EventStreamConstants (copy)
		if p2.isMounted then
			p2:setState({
				errorMessageKey = "",
				upsellState = EmailVerificationUpsellState.PromptUpdateEmail
			})
			p2.props.authEventAnalytics.reportInteractWithActionAndSection(p2.props.eventContext, "", EventStreamConstants.ActionType.Click, p2.props.origin, EventStreamConstants.Button.ChangeEmail, "verifyEmail")
		end
	end
	function p2.onEmailFocused() -- line: 176
		-- upvalues: p2 (copy), EventStreamConstants (copy)
		p2.props.authEventAnalytics.reportInteractWithActionAndSection(p2.props.eventContext, EventStreamConstants.Field.Email, EventStreamConstants.ActionType.Focus, p2.props.origin, "", p2.props.section)
	end
	function p2.onEmailUpdated() -- line: 187
		-- upvalues: p2 (copy), isStringEmail (copy), EventStreamConstants (copy), EmailVerificationUpsellState (copy)
		if p2.isMounted then
			local v70 = isStringEmail(p2.potentialEmailAddress)

			p2.props.authEventAnalytics.reportInteractWithActionAndSection(p2.props.eventContext, "", "", p2.props.origin, EventStreamConstants.Button.Continue, p2.props.section)

			if v70 then
				p2:setState({
					errorMessageKey = ""
				})

				local potentialEmailAddress = p2.potentialEmailAddress

				p2.props.updateUserEmail(p2.props.networking, potentialEmailAddress, nil):andThen(function() -- line: 209
					-- upvalues: p2 (copy), potentialEmailAddress (copy), EmailVerificationUpsellState (copy)
					if p2.isMounted then
						p2.emailWasUpdated = true

						if p2.props.successCallback then
							p2.props.successCallback(potentialEmailAddress)
						end

						if p2.props.closeOnEmailUpdate then
							p2.closeOverlay()

							return
						end

						p2:setState({
							errorMessage = "",
							errorMessageKey = "",
							isInResendEmailCooldown = false,
							upsellState = EmailVerificationUpsellState.PromptCheckEmail,
							emailAddress = potentialEmailAddress
						})
					end
				end):catch(function(p6) -- line: 230
					-- upvalues: p2 (copy)
					if p2.isMounted then
						p2:setState({
							errorMessageKey = "",
							isInResendEmailCooldown = false,
							errorMessage = p6 and p6.Message
						})
						p2.props.authEventAnalytics.reportModalShownWithSectionAndError(p2.props.eventContext, "errorMessage", p2.props.origin, p2.props.section, p6.ErrorCode)
					end
				end)

				return
			end

			p2:setState({
				errorMessageKey = "Feature.VerificationUpsell.Message.InvalidEmailAddress"
			})
			p2.props.authEventAnalytics.reportErrorMessageShown(p2.props.eventContext, "", p2.props.origin)
		end
	end
	function p2.onPasswordEntered() -- line: 258
		-- upvalues: p2 (copy), EmailVerificationUpsellState (copy)
		if p2.isMounted then
			p2:setState({
				isInResendEmailCooldown = true
			})

			local potentialEmailAddress = p2.potentialEmailAddress

			p2.props.updateUserEmail(p2.props.networking, potentialEmailAddress, p2.password):andThen(function() -- line: 268
				-- upvalues: p2 (copy), EmailVerificationUpsellState (copy), potentialEmailAddress (copy)
				p2:setState({
					errorMessage = "",
					errorMessageKey = "",
					isInResendEmailCooldown = false,
					upsellState = EmailVerificationUpsellState.PromptCheckEmail,
					emailAddress = potentialEmailAddress
				})
			end):catch(function(p7) -- line: 278
				-- upvalues: p2 (copy)
				local s1 = ""

				if p7.PasswordIncorrect then
					s1 = "Feature.VerificationUpsell.Message.WrongPassword"
				end

				p2:setState({
					isInResendEmailCooldown = false,
					errorMessageKey = s1,
					errorMessage = p7.Message
				})
			end)
		end
	end
	function p2.shouldShowPrivacyPolicyLink() -- line: 294
		-- upvalues: GetFFlagEnablePrivacyPolicyForLogoutUpsell (copy), p2 (copy), EmailVerificationUpsellState (copy)
		if not GetFFlagEnablePrivacyPolicyForLogoutUpsell() then
			return false
		end

		if p2.state.upsellState ~= EmailVerificationUpsellState.PromptUpdateEmail then
			return false
		end

		return true
	end
	function p2.onPrivacyPolicyLinkActivated() -- line: 304
		-- upvalues: p2 (copy), EventStreamConstants (copy), AppPage (copy), GetFStringPrivacyPolicyUrl (copy), TransitionAnimation (copy)
		if p2.isMounted then
			p2.props.authEventAnalytics.reportModalActionWithSection(p2.props.eventContext, EventStreamConstants.Field.PrivacyPolicy, "", p2.props.origin, p2.props.section)
			p2.props.navigateToPage({
				name = AppPage.GenericWebPage,
				detail = GetFStringPrivacyPolicyUrl(),
				extraProps = {
					title = "",
					transitionAnimation = TransitionAnimation.SlideInFromBottom
				}
			})
		end
	end
	function p2.onTermsOfServiceLinkActivated() -- line: 324
		-- upvalues: p2 (copy), EventStreamConstants (copy), AppPage (copy), UrlBuilder (copy), TransitionAnimation (copy)
		if p2.isMounted then
			p2.props.authEventAnalytics.reportModalActionWithSection(p2.props.eventContext, EventStreamConstants.Field.TermsOfService, "", p2.props.origin, p2.props.section)
			p2.props.navigateToPage({
				name = AppPage.GenericWebPage,
				detail = UrlBuilder.static.about.terms(),
				extraProps = {
					title = "",
					transitionAnimation = TransitionAnimation.SlideInFromBottom
				}
			})
		end
	end
	function p2.getLinks() -- line: 344
		-- upvalues: p2 (copy), EmailVerificationUpsellState (copy)
		if p2.state.upsellState ~= EmailVerificationUpsellState.PromptCheckEmail then
			return nil
		end

		local onResendEmailPressed = p2.onResendEmailPressed

		if p2.state.isInResendEmailCooldown then
			onResendEmailPressed = nil
		end

		if p2.props.useUpdatedModalDesign then
			return {{
				textKey = "Feature.VerificationUpsell.Action.ChangeEmail",
				isPrimaryLink = false,
				onClicked = p2.onUpdateEmailSelected
			}}
		end

		return {
			{
				textKey = "Feature.VerificationUpsell.Action.ResendConfirmationEmail",
				isPrimaryLink = true,
				onClicked = onResendEmailPressed
			},
			{
				textKey = "Feature.VerificationUpsell.Action.ChangeEmail",
				isPrimaryLink = false,
				onClicked = p2.onUpdateEmailSelected
			}
		}
	end
	function p2.getTitleTextKey() -- line: 380
		-- upvalues: p2 (copy), EmailVerificationUpsellState (copy)
		if p2.state.upsellState == EmailVerificationUpsellState.PromptCheckEmail then
			if p2.password and p2.password ~= "" then
				return "Feature.VerificationUpsell.Heading.VerifyEmail"
			end

			return p2.props.checkExistingEmailTitleKey
		end

		if p2.state.upsellState == EmailVerificationUpsellState.PromptUpdateEmail then
			return p2.props.addEmailTitleKey
		end

		if p2.state.upsellState == EmailVerificationUpsellState.PromptEnterPassword then
			return p2.props.addEmailTitleKey
		end

		return nil
	end
	function p2.getBodyTextKey() -- line: 399
		-- upvalues: p2 (copy), EmailVerificationUpsellState (copy)
		if p2.state.upsellState == EmailVerificationUpsellState.PromptCheckEmail then
			return {
				"Feature.VerificationUpsell.Description.VerifyEmailBody",
				emailAddress = p2.state.emailAddress
			}
		end

		if p2.state.upsellState == EmailVerificationUpsellState.PromptUpdateEmail then
			local props = p2.props
			local emailUpsellLockedIsLocalUserUnder13 = props.emailUpsellLockedIsLocalUserUnder13

			if if emailUpsellLockedIsLocalUserUnder13 == nil then props.IsLocalUserUnder13 else emailUpsellLockedIsLocalUserUnder13 then
				return p2.props.addEmailUnder13TextKey
			end

			return p2.props.addEmailOver13TextKey
		end

		if p2.state.upsellState == EmailVerificationUpsellState.PromptEnterPassword then
			return "Feature.VerificationUpsell.Description.EnterPassword"
		end

		return nil
	end

	local v36 = p2.props.renameParentEmailForVerificationUpsell and p2.props.emailPlaceholderUnder13KeyV2 or p2.props.emailPlaceholderUnder13Key
	local props = p2.props
	local emailUpsellLockedIsLocalUserUnder13 = props.emailUpsellLockedIsLocalUserUnder13
	local v39 = not if emailUpsellLockedIsLocalUserUnder13 == nil then props.IsLocalUserUnder13 else emailUpsellLockedIsLocalUserUnder13

	p2.stateDisplayInfo = {
		[EmailVerificationUpsellState.PromptCheckEmail] = {},
		[EmailVerificationUpsellState.PromptUpdateEmail] = {
			primaryButtonTextKey = "Feature.VerificationUpsell.Action.Continue",
			termsOfServiceKey = "CommonUI.Features.Label.Terms",
			secondaryButtonTextKey = p2.props.updateEmailSecondaryButtonText,
			privacyPolicyKey = not p2.props.useUpdatedModalDesign and "Feature.VerificationUpsell.Action.PrivacyPolicy" or "CommonUI.Features.Label.Privacy",
			textFieldPlaceholderTextKey = v39 and p2.props.emailPlaceholderOver13Key or v36,
			textFieldLabelTextKey = v39 and p2.props.textLabelOver13Key or v36,
			onPrimaryButtonActivated = p2.onEmailUpdated,
			onSecondaryButtonActivated = p2.onUpdateEmailSecondaryButtonPressed,
			onChangeTextCallback = p2.onEmailChangedCallback,
			textInputType = Enum.TextInputType.NoSuggestions
		},
		[EmailVerificationUpsellState.PromptEnterPassword] = {
			primaryButtonTextKey = "Feature.VerificationUpsell.Action.SendConfirmationEmail",
			textFieldPlaceholderTextKey = "Feature.VerificationUpsell.Label.PasswordInputPlaceholder",
			onPrimaryButtonActivated = p2.onPasswordEntered,
			onChangeTextCallback = p2.onPasswordChangedCallback,
			textInputType = Enum.TextInputType.Password
		}
	}

	if p2.props.useUpdatedModalDesign then
		p2.stateDisplayInfo[EmailVerificationUpsellState.PromptUpdateEmail].primaryButtonType = ButtonType.PrimaryContextual
		p2.stateDisplayInfo[EmailVerificationUpsellState.PromptUpdateEmail].secondaryButtonType = ButtonType.Secondary
		p2.stateDisplayInfo[EmailVerificationUpsellState.PromptCheckEmail] = {
			primaryButtonTextKey = "Feature.VerificationUpsell.Action.ResendConfirmationEmail",
			secondaryButtonTextKey = "Feature.VerificationUpsell.Action.ContinueLogOut",
			onPrimaryButtonActivated = p2.onResendEmailPressed,
			onSecondaryButtonActivated = p2.onUpdateEmailSecondaryButtonPressed,
			primaryButtonType = ButtonType.Secondary,
			secondaryButtonType = ButtonType.Secondary
		}
	end
end
function v28.willUnmount(p8) -- line: 466
	p8.isMounted = false

	if not p8.emailWasUpdated and p8.props.failureCallback then
		p8.props.failureCallback()
	end
end
function v28.didMount(p9) -- line: 473
	p9.isMounted = true
	p9.props.authEventAnalytics.reportModalShownWithSection(p9.props.eventContext, p9.props.origin, p9.props.section)
end
function v28.render(p10) -- line: 482
	-- upvalues: withStyle (copy), withLocalization (copy), Roact (copy), EmailVerificationUpsellStep (copy)
	local v43 = p10.stateDisplayInfo[p10.state.upsellState]
	local primaryButtonTextKey = v43.primaryButtonTextKey
	local onPrimaryButtonActivated = v43.onPrimaryButtonActivated
	local secondaryButtonTextKey = v43.secondaryButtonTextKey
	local onSecondaryButtonActivated = v43.onSecondaryButtonActivated
	local termsOfServiceKey = v43.termsOfServiceKey
	local privacyPolicyKey = v43.privacyPolicyKey
	local textInputType = v43.textInputType
	local textFieldPlaceholderTextKey = v43.textFieldPlaceholderTextKey
	local textFieldLabelTextKey = v43.textFieldLabelTextKey
	local onChangeTextCallback = v43.onChangeTextCallback
	local primaryButtonType = v43.primaryButtonType
	local secondaryButtonType = v43.secondaryButtonType
	local errorMessageKey = p10.state.errorMessageKey
	local v57 = p10.getLinks()
	local v58 = p10.getBodyTextKey()
	local v59 = p10.getTitleTextKey()
	local t1 = {
		primaryButtonText = primaryButtonTextKey,
		secondaryButtonText = secondaryButtonTextKey,
		termsOfServiceLinkText = termsOfServiceKey,
		privacyPolicyLinkText = privacyPolicyKey,
		placeholderText = textFieldPlaceholderTextKey,
		title = v59,
		bodyText = v58,
		textFieldLabelText = textFieldLabelTextKey
	}

	if errorMessageKey and errorMessageKey ~= "" then
		t1.errorText = errorMessageKey
	end

	return withStyle(function(_) -- line: 519
		-- upvalues: withLocalization (copy), t1 (copy), Roact (copy), EmailVerificationUpsellStep (copy), primaryButtonType (copy), secondaryButtonType (copy), textInputType (copy), termsOfServiceKey (copy), privacyPolicyKey (copy), p10 (copy), v57 (copy), onPrimaryButtonActivated (copy), onSecondaryButtonActivated (copy), onChangeTextCallback (copy)
		return withLocalization(t1)(function(p12) -- line: 520
			-- upvalues: Roact (copy), EmailVerificationUpsellStep (copy), primaryButtonType (copy), secondaryButtonType (copy), textInputType (copy), termsOfServiceKey (copy), privacyPolicyKey (copy), p10 (copy), v57 (copy), onPrimaryButtonActivated (copy), onSecondaryButtonActivated (copy), onChangeTextCallback (copy)
			return Roact.createElement(EmailVerificationUpsellStep, {
				title = p12.title,
				primaryButtonText = p12.primaryButtonText,
				secondaryButtonText = p12.secondaryButtonText,
				primaryButtonType = primaryButtonType,
				secondaryButtonType = secondaryButtonType,
				bodyText = p12.bodyText,
				textInputType = textInputType,
				textFieldPlaceholderText = p12.placeholderText,
				textFieldLabelText = p12.textFieldLabelText,
				termsOfServiceLinkKey = termsOfServiceKey,
				privacyPolicyLinkKey = privacyPolicyKey,
				privacyPolicyLinkText = p12.privacyPolicyLinkText,
				errorMessage = p12.errorText or p10.state.errorMessage,
				links = v57,
				onPrimaryButtonActivated = onPrimaryButtonActivated,
				onSecondaryButtonActivated = onSecondaryButtonActivated,
				onPrivacyPolicyLinkActivated = p10.onPrivacyPolicyLinkActivated,
				onTermsOfServiceLinkActivated = p10.onTermsOfServiceLinkActivated,
				onChangeTextCallback = onChangeTextCallback,
				onCloseClickedCallback = p10.closeOverlay,
				onEmailFocused = p10.onEmailFocused,
				isEmailModalCalledFromHomePage = p10.props.isEmailModalCalledFromHomePage,
				shouldShowPrivacyPolicyLink = p10.shouldShowPrivacyPolicyLink,
				useUpdatedModalDesign = p10.props.useUpdatedModalDesign
			})
		end)
	end)
end

local v30 = RoactRodux.connect(function(p13, _) -- line: 551
	return {
		screenSize = p13.ScreenSize,
		IsLocalUserUnder13 = p13.IsLocalUserUnder13
	}
end, function(p15) -- line: 556
	-- upvalues: CloseCentralOverlay (copy), UpdateUserEmail (copy), SendVerificationEmailToUser (copy), FFlagSignalsNavP3Dispatch (copy), v21 (copy), NavigateDown (copy)
	return {
		closeCentralOverlay = function() -- line: 558
			-- upvalues: p15 (copy), CloseCentralOverlay (copy)
			return p15(CloseCentralOverlay())
		end,
		updateUserEmail = function(p16, p17, p18) -- line: 561
			-- upvalues: p15 (copy), UpdateUserEmail (copy)
			return p15(UpdateUserEmail(p16, p17, p18))
		end,
		sendVerificationEmailToUser = function(p19) -- line: 564
			-- upvalues: p15 (copy), SendVerificationEmailToUser (copy)
			return p15(SendVerificationEmailToUser(p19))
		end,
		navigateToPage = function(p20) -- line: 567
			-- upvalues: FFlagSignalsNavP3Dispatch (copy), v21 (copy), p15 (copy), NavigateDown (copy)
			if FFlagSignalsNavP3Dispatch then
				return v21.down(v21.fromLegacyPage(p20))
			end

			return p15(NavigateDown(p20))
		end
	}
end)(v28)
local v31 = RoactServices.connect({
	networking = RoactNetworking,
	authEventAnalytics = RoactAnalyticsAuthEvents
})(v30)

return (RoactAppPolicy.connect(function(p21, _) -- line: 582
	return {
		renameParentEmailForVerificationUpsell = p21.getRenameParentEmailForVerificationUpsell()
	}
end)(v31))
