local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Common = Modules.Common
local Roact = require(Common.Roact)
local EventStreamConstants = require(Modules.LuaApp.EventStreamConstants)
local CredentialLoginForm = require(Modules.LuaApp.Components.Authentication.CredentialLoginForm)
local GetFFlagEnableTextFieldContentType = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableTextFieldContentType
local v8 = game:DefineFastFlag("DisableLoginOnEmptyUserOrPass", false)
local v9 = if not v8 then nil else require(Modules.LuaApp.Components.Authentication.Logger)

return function(t1: {[any]: any}) -- line: 62
	-- upvalues: GetFFlagEnableTextFieldContentType (copy), EventStreamConstants (copy), v8 (copy), v9 (copy), Roact (copy), CredentialLoginForm (copy)
	local v11 = GetFFlagEnableTextFieldContentType() and Enum.TextInputType.Username or Enum.TextInputType.NoSuggestions

	local function v12() -- line: 66
		-- upvalues: t1 (copy), EventStreamConstants (copy)
		if t1.loginButtonDisabled then
			return
		end

		if t1.isLoginInProgress then
			return
		end

		t1.updateIsLoginInProgress(true)
		t1.authAnalytics.reportLogInButtonClicked(EventStreamConstants.Context.LoginScreen)
		t1.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.LoginForm, EventStreamConstants.Button.LogIn)
		t1.handleLoginWithFormDataCallback()
	end

	local u13 = false
	local u14 = false

	return Roact.createElement(CredentialLoginForm, {
		disableRegularLogin = t1.disableRegularLogin,
		usernameTextInputType = v11,
		crossDeviceLoginEnabled = t1.crossDeviceLoginEnabled,
		loginWithExistingAccountVariantEnabled = t1.loginWithExistingAccountVariantEnabled,
		quickLoginButtonText = t1.quickLoginButtonText,
		cvalueText = t1.cvalueText,
		passwordText = t1.passwordText,
		onTextBoxesChanged = t1.onTextBoxesChanged,
		onReturnPressedFromOnScreenKeyboardWhenFocusedOnCValue = function() -- line: 86
			-- upvalues: t1 (copy)
			spawn(function() -- line: 87
				-- upvalues: t1 (copy)
				t1.cvalueRef.current:ReleaseFocus()
				t1.passwordRef.current:CaptureFocus()
			end)
		end,
		onReturnPressedFromOnScreenKeyboardWhenFocusedOnPassword = function() -- line: 93
			-- upvalues: t1 (copy), v8 (copy), v9 (copy), v12 (copy)
			t1.passwordRef.current:ReleaseFocus()

			if v8 then
				local v15 = t1.cvalueRef and (t1.cvalueRef.current and t1.cvalueRef.current.Text)
				local v16 = t1.passwordRef and (t1.passwordRef.current and t1.passwordRef.current.Text)

				if not v15 or v15 == "" or not v16 or v16 == "" then
					v9:warning("Login attempt skipped: empty credential or password field")

					return
				end
			end

			v12()
		end,
		cvalueTextBoxOnFocus = function() -- line: 110
			-- upvalues: u13 (ref), t1 (copy), EventStreamConstants (copy)
			if not u13 then
				u13 = true
				t1.authAnalytics.reportUsernameFocus(EventStreamConstants.Context.LoginScreen)
				t1.authAnalytics.reportAuthFormInteraction(EventStreamConstants.Context.LoginForm, EventStreamConstants.Field.Username)
			end
		end,
		passwordTextBoxOnFocus = function() -- line: 122
			-- upvalues: u14 (ref), t1 (copy), EventStreamConstants (copy)
			if not u14 then
				u14 = true
				t1.authAnalytics.reportPasswordFocus(EventStreamConstants.Context.LoginScreen)
				t1.authAnalytics.reportAuthFormInteraction(EventStreamConstants.Context.LoginForm, EventStreamConstants.Field.Password)
			end
		end,
		passwordVisibilityToggleCallback = function(p1) -- line: 133
			-- upvalues: t1 (copy), EventStreamConstants (copy)
			t1.authAnalytics.reportAuthButtonClick(EventStreamConstants.Context.LoginForm, EventStreamConstants.Button.ShowPassword, not p1 and "hide" or "show")

			if p1 then
				t1.authAnalytics.reportShowPasswordButtonClicked(EventStreamConstants.Context.LoginScreen)

				return
			end

			t1.authAnalytics.reportHidePasswordButtonClicked(EventStreamConstants.Context.LoginScreen)
		end,
		buttonRef = t1.buttonRef,
		cvalueRef = t1.cvalueRef,
		passwordRef = t1.passwordRef,
		loginButtonRef = t1.loginButtonRef,
		forgotLinkRef = t1.forgotLinkRef,
		crossDeviceButtonRef = t1.crossDeviceButtonRef,
		emailOtpRef = t1.emailOtpRef,
		localizedError = t1.localizedError,
		localizedErrorMessage = t1.localizedErrorMessage,
		forceLoginByUsername = t1.forceLoginByUsername,
		showLinkAccountText = t1.showLinkAccountText,
		showForgotButton = t1.showForgotButton,
		onForgetButtonActivated = t1.onForgetButtonActivated,
		onCrossDeviceLoginActivated = t1.onCrossDeviceLoginActivated,
		loginButtonDisabled = t1.loginButtonDisabled,
		isLoginInProgress = t1.isLoginInProgress,
		onLoginButtonActivated = v12,
		maxSizeX = t1.maxSizeX,
		showDisclaimerLinks = t1.showDisclaimerLinks,
		showDisclaimerButtons = t1.showDisclaimerButtons,
		showCredentialHeader = t1.showCredentialHeader,
		isDualLayout = t1.isDualLayout,
		isTenFootUiMode = t1.isTenFootUiMode,
		onEmailOtpActivated = t1.onEmailOtpActivated,
		emailOtpEnabled = t1.emailOtpEnabled
	})
end
