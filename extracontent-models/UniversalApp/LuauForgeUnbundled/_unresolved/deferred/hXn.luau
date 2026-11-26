local CorePackages = game:GetService("CorePackages")

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local module = require("@luauforge/bundled/egx")
local roactServices = require("@game/CorePackages/Workspace/Packages/RoactServices").RoactServices
local module2 = require("@luauforge/bundled/grb")
local roactAppPolicy = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").RoactAppPolicy

local UIBlox = require(CorePackages.Packages.UIBlox)
local withStyle = UIBlox.Style.withStyle
local buttonType = UIBlox.App.Button.Enum.ButtonType
local module3 = require("@luauforge/bundled/egZ")
local module4 = require("@luauforge/bundled/dFu")
local module5 = require("@luauforge/bundled/fBF")

local module6 = require("@luauforge/bundled/fCM")
local module7 = require("@luauforge/deferred/hXo")
local module8 = require("@luauforge/deferred/gzd")

local module9 = require("@luauforge/deferred/hXp")
local module10 = require("@luauforge/bundled/ehB")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagSignalsNavP3Dispatch = SharedFlags.FFlagSignalsNavP3Dispatch
local fFlagUseSignalsForIsLocalUserUnder13 = SharedFlags.FFlagUseSignalsForIsLocalUserUnder13
local navigationCommands

if fFlagSignalsNavP3Dispatch then
	navigationCommands = require("@luauforge/bundled/dFz").NavigationCommands
else
	navigationCommands = nil
end

local getIsLocalUserUnder13Store

if fFlagUseSignalsForIsLocalUserUnder13 then
	getIsLocalUserUnder13Store = require("@luauforge/bundled/ciE").Stores.GetIsLocalUserUnder13Store
else
	getIsLocalUserUnder13Store = nil
end

local module12 = require("@luauforge/bundled/gzf")
local module13 = require("@luauforge/deferred/hXr")
local module14 = require("@luauforge/bundled/fzS")

local module15 = require("@luauforge/deferred/hXt")

local module16 = require("@luauforge/deferred/hXu")

local UrlBuilder = require(CorePackages.Packages.UrlBuilder)
local urlBuilder = UrlBuilder.UrlBuilder

local extended = Roact.PureComponent:extend("EmailVerificationUpsellOverlay")

local function getEffectiveIsLocalUserUnder13(p2)
	local emailUpsellLockedIsLocalUserUnder13 = p2.emailUpsellLockedIsLocalUserUnder13

	if emailUpsellLockedIsLocalUserUnder13 == nil then
		return p2.IsLocalUserUnder13
	end

	return emailUpsellLockedIsLocalUserUnder13
end

extended.defaultProps = {
	addEmailOver13TextKey = "Feature.VerificationUpsell.Description.AddEmailTextOver13",
	addEmailUnder13TextKey = "Feature.VerificationUpsell.Description.AddEmailTextUnder13",
	addEmailTitleKey = "Feature.VerificationUpsell.Heading.AddEmail",
	checkExistingEmailTitleKey = "Feature.VerificationUpsell.Heading.VerifyEmail",
	eventContext = module14.Context.VerificationUpsell,
	emailPlaceholderOver13Key = "Feature.VerificationUpsell.Label.EmailInputPlaceholderOver13",
	textLabelOver13Key = "Authentication.SignUp.Label.EmailAddress",
	emailPlaceholderUnder13Key = "Feature.VerificationUpsell.Label.EmailInputPlaceholderUnder13",
	emailPlaceholderUnder13KeyV2 = "Feature.VerificationUpsell.Label.EmailInputPlaceholderUnder13V2",
	useUpdatedModalDesign = false
}

function extended:init()
	local v5 = module7.PromptUpdateEmail

	if self.props.emailAddress then
		v5 = module7.PromptCheckEmail
	end

	self.potentialEmailAddress = nil
	self.password = nil
	self.emailWasUpdated = false

	self.state = {
		upsellState = v5,
		emailAddress = self.props.emailAddress or ""
	}

	function self.closeOverlay()
		if self.isMounted then
			self.props.closeCentralOverlay()
			self.props.authEventAnalytics.reportModalDismissedWithSection(
				self.props.eventContext,
				self.props.origin,
				self.props.section
			)
		end
	end

	function self.onUpdateEmailSecondaryButtonPressed()
		if self.isMounted and self.props.onUpdateEmailSecondaryButtonPressed then
			self.props.onUpdateEmailSecondaryButtonPressed()
			self.props.authEventAnalytics.reportInteractWithAction(
				self.props.eventContext,
				"",
				module14.ActionType.Click,
				self.props.origin,
				self.props.onUpdateEmailSecondaryButtonPressedEvent
			)
		end
	end

	function self.onPasswordChangedCallback(p2)
		self.password = p2.Text
	end

	function self.onEmailChangedCallback(p2)
		self.potentialEmailAddress = p2.Text
	end

	function self.onResendEmailPressed()
		if self.isMounted then
			self:setState({ isInResendEmailCooldown = true })

			self.props.sendVerificationEmailToUser(self.props.networking):andThen(function()
				spawn(function()
					wait(20)

					self.resetResendEmailState(true)
				end)
			end):catch(function()
				self.resetResendEmailState(false)
			end)
			self.props.authEventAnalytics.reportInteractWithActionAndSection(
				self.props.eventContext,
				"",
				module14.ActionType.Click,
				self.props.origin,
				module14.Button.ResendEmailConfirmation,
				"verifyEmail"
			)
		end
	end

	function self.resetResendEmailState(p2)
		local v6 = p2 and "" or "Feature.VerificationUpsell.Message.ConfirmationEmailNotSent"

		if self.isMounted then
			if v6 ~= "" then
				self.props.authEventAnalytics.reportErrorMessageShown(
					self.props.eventContext,
					"",
					self.props.origin
				)
			end

			self:setState({ isInResendEmailCooldown = false, errorMessageKey = v6 })
		end
	end

	function self.onUpdateEmailSelected()
		if self.isMounted then
			self:setState({
				upsellState = module7.PromptUpdateEmail,
				errorMessageKey = ""
			})

			self.props.authEventAnalytics.reportInteractWithActionAndSection(
				self.props.eventContext,
				"",
				module14.ActionType.Click,
				self.props.origin,
				module14.Button.ChangeEmail,
				"verifyEmail"
			)
		end
	end

	function self.onEmailFocused()
		self.props.authEventAnalytics.reportInteractWithActionAndSection(
			self.props.eventContext,
			module14.Field.Email,
			module14.ActionType.Focus,
			self.props.origin,
			"",
			self.props.section
		)
	end

	function self.onEmailUpdated()
		if self.isMounted then
			local v6 = module12(self.potentialEmailAddress)

			self.props.authEventAnalytics.reportInteractWithActionAndSection(
				self.props.eventContext,
				"",
				"",
				self.props.origin,
				module14.Button.Continue,
				self.props.section
			)

			if v6 then
				self:setState({ errorMessageKey = "" })

				local potentialEmailAddress = self.potentialEmailAddress

				self.props.updateUserEmail(self.props.networking, potentialEmailAddress, nil):andThen(function()
					if self.isMounted then
						self.emailWasUpdated = true

						if self.props.successCallback then
							self.props.successCallback(potentialEmailAddress)
						end

						if self.props.closeOnEmailUpdate then
							self.closeOverlay()
						else
							self:setState({
								upsellState = module7.PromptCheckEmail,
								errorMessage = "",
								errorMessageKey = "",
								emailAddress = potentialEmailAddress,
								isInResendEmailCooldown = false
							})
						end
					end
				end):catch(function(p2)
					if self.isMounted then
						self:setState({
							errorMessageKey = "",
							errorMessage = p2 and p2.Message,
							isInResendEmailCooldown = false
						})

						self.props.authEventAnalytics.reportModalShownWithSectionAndError(
							self.props.eventContext,
							"errorMessage",
							self.props.origin,
							self.props.section,
							p2.ErrorCode
						)
					end
				end)
			else
				self:setState({
					errorMessageKey = "Feature.VerificationUpsell.Message.InvalidEmailAddress"
				})

				self.props.authEventAnalytics.reportErrorMessageShown(
					self.props.eventContext,
					"",
					self.props.origin
				)
			end
		end
	end

	function self.onPasswordEntered()
		if self.isMounted then
			self:setState({ isInResendEmailCooldown = true })

			local potentialEmailAddress = self.potentialEmailAddress

			self.props.updateUserEmail(self.props.networking, potentialEmailAddress, self.password):andThen(function()
				self:setState({
					upsellState = module7.PromptCheckEmail,
					errorMessage = "",
					errorMessageKey = "",
					emailAddress = potentialEmailAddress,
					isInResendEmailCooldown = false
				})
			end):catch(function(p2)
				self:setState({
					errorMessageKey = p2.PasswordIncorrect and "Feature.VerificationUpsell.Message.WrongPassword" or "",
					errorMessage = p2.Message,
					isInResendEmailCooldown = false
				})
			end)
		end
	end

	function self.shouldShowPrivacyPolicyLink(): boolean
		if module16() then
			return self.state.upsellState == module7.PromptUpdateEmail
		end

		return false
	end

	function self.onPrivacyPolicyLinkActivated()
		if self.isMounted then
			self.props.authEventAnalytics.reportModalActionWithSection(
				self.props.eventContext,
				module14.Field.PrivacyPolicy,
				"",
				self.props.origin,
				self.props.section
			)

			self.props.navigateToPage({
				name = module4.GenericWebPage,
				detail = module15(),
				extraProps = {
					title = "",
					transitionAnimation = module5.SlideInFromBottom
				}
			})
		end
	end

	function self.onTermsOfServiceLinkActivated()
		if self.isMounted then
			self.props.authEventAnalytics.reportModalActionWithSection(
				self.props.eventContext,
				module14.Field.TermsOfService,
				"",
				self.props.origin,
				self.props.section
			)

			self.props.navigateToPage({
				name = module4.GenericWebPage,
				detail = urlBuilder.static.about.terms(),
				extraProps = {
					title = "",
					transitionAnimation = module5.SlideInFromBottom
				}
			})
		end
	end

	function self.getLinks()
		if self.state.upsellState ~= module7.PromptCheckEmail then
			return nil
		end

		local onResendEmailPressed = self.onResendEmailPressed

		if self.state.isInResendEmailCooldown then
			onResendEmailPressed = nil
		end

		if self.props.useUpdatedModalDesign then
			return {
				{
					textKey = "Feature.VerificationUpsell.Action.ChangeEmail",
					onClicked = self.onUpdateEmailSelected,
					isPrimaryLink = false
				}
			}
		end

		return {
			{
				textKey = "Feature.VerificationUpsell.Action.ResendConfirmationEmail",
				onClicked = onResendEmailPressed,
				isPrimaryLink = true
			},
			{
				textKey = "Feature.VerificationUpsell.Action.ChangeEmail",
				onClicked = self.onUpdateEmailSelected,
				isPrimaryLink = false
			}
		}
	end

	function self.getTitleTextKey()
		if self.state.upsellState == module7.PromptCheckEmail then
			if self.password and self.password ~= "" then
				return "Feature.VerificationUpsell.Heading.VerifyEmail"
			end

			return self.props.checkExistingEmailTitleKey
		end

		if not (self.state.upsellState ~= module7.PromptUpdateEmail and self.state.upsellState ~= module7.PromptEnterPassword) then
			return self.props.addEmailTitleKey
		end

		return nil
	end

	function self.getBodyTextKey()
		if self.state.upsellState == module7.PromptCheckEmail then
			return {
				"Feature.VerificationUpsell.Description.VerifyEmailBody",
				emailAddress = self.state.emailAddress
			}
		end

		if self.state.upsellState == module7.PromptUpdateEmail then
			local props = self.props
			local v6 = props.emailUpsellLockedIsLocalUserUnder13

			if v6 == nil then
				v6 = props.IsLocalUserUnder13
			end

			if v6 then
				return self.props.addEmailUnder13TextKey
			end

			return self.props.addEmailOver13TextKey
		elseif self.state.upsellState == module7.PromptEnterPassword then
			return "Feature.VerificationUpsell.Description.EnterPassword"
		else
			return nil
		end
	end

	local v6 = self.props.renameParentEmailForVerificationUpsell
		and self.props.emailPlaceholderUnder13KeyV2
		or self.props.emailPlaceholderUnder13Key

	local props = self.props
	local v7 = props.emailUpsellLockedIsLocalUserUnder13

	if v7 == nil then
		v7 = props.IsLocalUserUnder13
	end

	local v8 = not v7

	local v9 = { [module7.PromptCheckEmail] = {} }

	local promptUpdateEmail = module7.PromptUpdateEmail
	local v10 = {
		primaryButtonTextKey = "Feature.VerificationUpsell.Action.Continue",
		secondaryButtonTextKey = self.props.updateEmailSecondaryButtonText,
		termsOfServiceKey = "CommonUI.Features.Label.Terms",
		privacyPolicyKey = self.props.useUpdatedModalDesign and "CommonUI.Features.Label.Privacy" or "Feature.VerificationUpsell.Action.PrivacyPolicy",
		textFieldPlaceholderTextKey = 0,
		textFieldLabelTextKey = 0,
		onPrimaryButtonActivated = 0,
		onSecondaryButtonActivated = 0,
		onChangeTextCallback = 0,
		textInputType = 0
	}

	local v11 = if v8 then self.props.emailPlaceholderOver13Key or v6 else v6
	v10.textFieldPlaceholderTextKey = v11

	v6 = v8 and self.props.textLabelOver13Key or v6
	v10.textFieldLabelTextKey = v6
	v10.onPrimaryButtonActivated = self.onEmailUpdated
	v10.onSecondaryButtonActivated = self.onUpdateEmailSecondaryButtonPressed
	v10.onChangeTextCallback = self.onEmailChangedCallback
	v10.textInputType = Enum.TextInputType.NoSuggestions
	v9[promptUpdateEmail] = v10

	v9[module7.PromptEnterPassword] = {
		primaryButtonTextKey = "Feature.VerificationUpsell.Action.SendConfirmationEmail",
		textFieldPlaceholderTextKey = "Feature.VerificationUpsell.Label.PasswordInputPlaceholder",
		onPrimaryButtonActivated = self.onPasswordEntered,
		onChangeTextCallback = self.onPasswordChangedCallback,
		textInputType = Enum.TextInputType.Password
	}
	self.stateDisplayInfo = v9

	if self.props.useUpdatedModalDesign then
		self.stateDisplayInfo[module7.PromptUpdateEmail].primaryButtonType = buttonType.PrimaryContextual
		self.stateDisplayInfo[module7.PromptUpdateEmail].secondaryButtonType = buttonType.Secondary
		self.stateDisplayInfo[module7.PromptCheckEmail] = {
			primaryButtonTextKey = "Feature.VerificationUpsell.Action.ResendConfirmationEmail",
			secondaryButtonTextKey = "Feature.VerificationUpsell.Action.ContinueLogOut",
			onPrimaryButtonActivated = self.onResendEmailPressed,
			onSecondaryButtonActivated = self.onUpdateEmailSecondaryButtonPressed,
			primaryButtonType = buttonType.Secondary,
			secondaryButtonType = buttonType.Secondary
		}
	end
end

function extended:willUnmount()
	self.isMounted = false

	if not self.emailWasUpdated and self.props.failureCallback then
		self.props.failureCallback()
	end
end

function extended:didMount()
	self.isMounted = true
	self.props.authEventAnalytics.reportModalShownWithSection(
		self.props.eventContext,
		self.props.origin,
		self.props.section
	)
end

function extended.render(data)
	local v5 = data.stateDisplayInfo[data.state.upsellState]
	local primaryButtonTextKey = v5.primaryButtonTextKey
	local onPrimaryButtonActivated = v5.onPrimaryButtonActivated
	local secondaryButtonTextKey = v5.secondaryButtonTextKey
	local onSecondaryButtonActivated = v5.onSecondaryButtonActivated
	local termsOfServiceKey = v5.termsOfServiceKey
	local privacyPolicyKey = v5.privacyPolicyKey
	local textInputType = v5.textInputType
	local textFieldPlaceholderTextKey = v5.textFieldPlaceholderTextKey
	local textFieldLabelTextKey = v5.textFieldLabelTextKey
	local onChangeTextCallback = v5.onChangeTextCallback
	local primaryButtonType = v5.primaryButtonType
	local secondaryButtonType = v5.secondaryButtonType

	local errorMessageKey = data.state.errorMessageKey
	local links = data.getLinks()
	local bodyTextKey = data.getBodyTextKey()
	local v6 = {
		primaryButtonText = primaryButtonTextKey,
		secondaryButtonText = secondaryButtonTextKey,
		termsOfServiceLinkText = termsOfServiceKey,
		privacyPolicyLinkText = privacyPolicyKey,
		placeholderText = textFieldPlaceholderTextKey,
		title = data.getTitleTextKey(),
		bodyText = bodyTextKey,
		textFieldLabelText = textFieldLabelTextKey
	}

	if errorMessageKey and errorMessageKey ~= "" then
		v6.errorText = errorMessageKey
	end

	return withStyle(function(p2)
		return module3(v6)(function(props)
			return Roact.createElement(module13, {
				title = props.title,
				primaryButtonText = props.primaryButtonText,
				secondaryButtonText = props.secondaryButtonText,
				primaryButtonType = primaryButtonType,
				secondaryButtonType = secondaryButtonType,
				bodyText = props.bodyText,
				textInputType = textInputType,
				textFieldPlaceholderText = props.placeholderText,
				textFieldLabelText = props.textFieldLabelText,
				termsOfServiceLinkKey = termsOfServiceKey,
				privacyPolicyLinkKey = privacyPolicyKey,
				privacyPolicyLinkText = props.privacyPolicyLinkText,
				errorMessage = props.errorText or data.state.errorMessage,
				links = links,
				onPrimaryButtonActivated = onPrimaryButtonActivated,
				onSecondaryButtonActivated = onSecondaryButtonActivated,
				onPrivacyPolicyLinkActivated = data.onPrivacyPolicyLinkActivated,
				onTermsOfServiceLinkActivated = data.onTermsOfServiceLinkActivated,
				onChangeTextCallback = onChangeTextCallback,
				onCloseClickedCallback = data.closeOverlay,
				onEmailFocused = data.onEmailFocused,
				isEmailModalCalledFromHomePage = data.props.isEmailModalCalledFromHomePage,
				shouldShowPrivacyPolicyLink = data.shouldShowPrivacyPolicyLink,
				useUpdatedModalDesign = data.props.useUpdatedModalDesign
			})
		end)
	end)
end

local v5 = RoactRodux.connect(function(p2, p3)
	local v6 = { screenSize = p2.ScreenSize, IsLocalUserUnder13 = 0 }
	local v7 = if not fFlagUseSignalsForIsLocalUserUnder13 then p2.IsLocalUserUnder13 else nil
	v6.IsLocalUserUnder13 = v7
	return v6
end, function(callback)
	return {
		closeCentralOverlay = function()
			return callback(module6())
		end,
		updateUserEmail = function(p2, p3, p4)
			return callback(module8(p2, p3, p4))
		end,
		sendVerificationEmailToUser = function(p2)
			return callback(module9(p2))
		end,
		navigateToPage = function(p2)
			if fFlagSignalsNavP3Dispatch then
				return navigationCommands.down(navigationCommands.fromLegacyPage(p2))
			end

			return callback(module10(p2))
		end
	}
end)(extended)
local v6

if fFlagUseSignalsForIsLocalUserUnder13 then
	local function EmailVerificationUpsellOverlayWithSignals(p2)
		local v7 = useSignalState(getIsLocalUserUnder13Store(false).getIsLocalUserUnder13)

		return Roact.createElement(v5, Cryo.Dictionary.union(p2, {
			IsLocalUserUnder13 = v7
		}))
	end

	v6 = React.memo(EmailVerificationUpsellOverlayWithSignals)
else
	v6 = v5
end

local v7 = roactServices.connect({ networking = module, authEventAnalytics = module2 })(v6)

return (roactAppPolicy.connect(function(p2, p3)
	return {
		renameParentEmailForVerificationUpsell = p2.getRenameParentEmailForVerificationUpsell()
	}
end)(v7))
