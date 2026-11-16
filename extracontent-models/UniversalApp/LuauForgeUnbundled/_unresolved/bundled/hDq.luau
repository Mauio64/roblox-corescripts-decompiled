local module = require("@luauforge/bundled/ecR")

local module2 = require("@luauforge/bundled/fsy")

local module3 = require("@luauforge/bundled/hDr")

local getFFlagEnableTextFieldContentType = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagEnableTextFieldContentType

local defineFastFlag = game:DefineFastFlag("DisableLoginOnEmptyUserOrPass", false)

local v5 = if defineFastFlag then require("@game/CorePackages/Workspace/Packages/_Workspace/TextChannelWindow/TextChannelWindow/Logger") else nil

return function(props)
	local username = getFFlagEnableTextFieldContentType() and Enum.TextInputType.Username
		or Enum.TextInputType.NoSuggestions

	local function onLoginButtonActivated()
		if props.loginButtonDisabled or props.isLoginInProgress then
			return
		end

		props.updateIsLoginInProgress(true)

		props.authAnalytics.reportLogInButtonClicked(module2.Context.LoginScreen)

		props.authAnalytics.reportAuthButtonClick(module2.Context.LoginForm, module2.Button.LogIn)

		props.handleLoginWithFormDataCallback()
	end

	local function onReturnPressedFromOnScreenKeyboardWhenFocusedOnPassword()
		props.passwordRef.current:ReleaseFocus()

		if defineFastFlag then
			local text = props.cvalueRef and props.cvalueRef.current and props.cvalueRef.current.Text
			local text2 = props.passwordRef and props.passwordRef.current and props.passwordRef.current.Text

			if not text or text == "" or not text2 or text2 == "" then
				v5:warning("Login attempt skipped: empty credential or password field")
				return
			end
		end

		onLoginButtonActivated()
	end

	local v6 = false
	local function fn()
		if not v6 then
			v6 = true
			props.authAnalytics.reportUsernameFocus(module2.Context.LoginScreen)
			props.authAnalytics.reportAuthFormInteraction(module2.Context.LoginForm, module2.Field.Username)
		end
	end

	local v7 = false
	local function fn2()
		if not v7 then
			v7 = true
			props.authAnalytics.reportPasswordFocus(module2.Context.LoginScreen)
			props.authAnalytics.reportAuthFormInteraction(module2.Context.LoginForm, module2.Field.Password)
		end
	end

	local function fn3(p2)
		props.authAnalytics.reportAuthButtonClick(
			module2.Context.LoginForm,
			module2.Button.ShowPassword,
			p2 and "show" or "hide"
		)

		if p2 then
			props.authAnalytics.reportShowPasswordButtonClicked(module2.Context.LoginScreen)
		else
			props.authAnalytics.reportHidePasswordButtonClicked(module2.Context.LoginScreen)
		end
	end

	return module.createElement(module3, {
		disableRegularLogin = props.disableRegularLogin,
		usernameTextInputType = username,
		crossDeviceLoginEnabled = props.crossDeviceLoginEnabled,
		loginWithExistingAccountVariantEnabled = props.loginWithExistingAccountVariantEnabled,
		quickLoginButtonText = props.quickLoginButtonText,
		cvalueText = props.cvalueText,
		passwordText = props.passwordText,
		onTextBoxesChanged = props.onTextBoxesChanged,
		onReturnPressedFromOnScreenKeyboardWhenFocusedOnCValue = function()
			spawn(function()
				props.cvalueRef.current:ReleaseFocus()
				props.passwordRef.current:CaptureFocus()
			end)
		end,
		onReturnPressedFromOnScreenKeyboardWhenFocusedOnPassword = onReturnPressedFromOnScreenKeyboardWhenFocusedOnPassword,
		cvalueTextBoxOnFocus = fn,
		passwordTextBoxOnFocus = fn2,
		passwordVisibilityToggleCallback = fn3,
		buttonRef = props.buttonRef,
		cvalueRef = props.cvalueRef,
		passwordRef = props.passwordRef,
		loginButtonRef = props.loginButtonRef,
		forgotLinkRef = props.forgotLinkRef,
		crossDeviceButtonRef = props.crossDeviceButtonRef,
		emailOtpRef = props.emailOtpRef,
		localizedError = props.localizedError,
		localizedErrorMessage = props.localizedErrorMessage,
		forceLoginByUsername = props.forceLoginByUsername,
		showLinkAccountText = props.showLinkAccountText,
		showForgotButton = props.showForgotButton,
		onForgetButtonActivated = props.onForgetButtonActivated,
		onCrossDeviceLoginActivated = props.onCrossDeviceLoginActivated,
		loginButtonDisabled = props.loginButtonDisabled,
		isLoginInProgress = props.isLoginInProgress,
		onLoginButtonActivated = onLoginButtonActivated,
		maxSizeX = props.maxSizeX,
		showDisclaimerLinks = props.showDisclaimerLinks,
		showDisclaimerButtons = props.showDisclaimerButtons,
		showCredentialHeader = props.showCredentialHeader,
		isDualLayout = props.isDualLayout,
		isTenFootUiMode = props.isTenFootUiMode,
		onEmailOtpActivated = props.onEmailOtpActivated,
		emailOtpEnabled = props.emailOtpEnabled
	})
end
