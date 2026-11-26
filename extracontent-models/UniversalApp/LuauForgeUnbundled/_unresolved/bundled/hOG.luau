local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local module = require("@luauforge/bundled/gxM")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local textBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local genericTextBox = AuthCommon.Components.GenericTextBox
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FitFrame = require(CorePackages.Packages.FitFrame)
local fitTextLabel = FitFrame.FitTextLabel
local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")
local passwordBox = AuthCommon.Components.PasswordBox
local module6 = require("@luauforge/bundled/hOH")
local module7 = require("@luauforge/bundled/grz")
local module8 = require("@luauforge/bundled/hOI")
local linkButton = UIBlox.App.Button.LinkButton
local openTypeSupport = UIBlox.Utility.OpenTypeSupport

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport
local module9 = require("@luauforge/bundled/fGg")

local module10 = require("@luauforge/bundled/hOK")

return function(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local v7 = useUiModeInfo()
	local loginView = v6.LuaApps.LoginView

	local color = v5.Theme.TextDefault.Color
	local transparency = v5.Theme.TextDefault.Transparency
	local color2 = v5.Theme.BackgroundUIContrast.Color
	local transparency2 = v5.Theme.BackgroundUIContrast.Transparency
	local color3 = v5.Theme.TextDefault.Color

	local v8 = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v9 = module({
		logInText = "Authentication.Login.Action.SignIn",
		cvaluePlaceholder = props.forceLoginByUsername and "Authentication.Login.Label.Username" or "Authentication.Login.Label.UsernameEmailPhone",
		passwordPlaceholder = "CommonUI.Messages.Label.Password",
		linkAccountText = {
			"Authentication.Login.Label.LinkAccountWarning",
			platform = v8 or "Console"
		},
		forgotText = "Authentication.Login.Action.ForgotPasswordOrUsernameQuestionCapitalized",
		emailOtpButtonText = "Authentication.Login.Action.LogInEmailOneTimeCode"
	})

	local showLinkAccountText = props.showLinkAccountText
	local showDisclaimerLinks = props.showDisclaimerLinks or props.showDisclaimerButtons
	local v10 = props.isDualLayout and not props.showCredentialHeader

	local v11 = loginView.textboxHeight * 2 + loginView.loginContentsPadding
	local textboxLabelHeight

	if props.isDualLayout then
		textboxLabelHeight = loginView.textboxLabelHeight

		if v10 then
			v11 = (loginView.textboxHeight + textboxLabelHeight + loginView.textboxLabelPadding) * 2 + loginView.loginContentsPadding
		else
			v11 = (loginView.textboxHeight + textboxLabelHeight) * 2 + loginView.textboxLabelPadding + loginView.loginContentsPadding
		end
	end

	local textboxLabelPadding = if props.isDualLayout then loginView.textboxLabelPadding else nil
	local textboxTextSize = loginView.textboxTextSize
	local v12

	if props.isDualLayout and props.isTenFootUiMode then
		local localizedError = props.localizedError or props.localizedErrorMessage or ""
		local createElement = Roact.createElement
		local v14 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v16

		if not props.disableRegularLogin then
			local createElement2 = Roact.createElement
			local v18 = {
				Size = UDim2.new(1, 0, 0, 0),
				width = UDim.new(1, 0),
				AnchorPoint = Vector2.new(0, 0),
				Text = localizedError,
				Font = normalizeFontFace(v6.Typography.CaptionSmall.Font),
				TextSize = 0,
				TextXAlignment = 0,
				TextYAlignment = 0,
				TextColor3 = 0,
				TextWrapped = true,
				BackgroundTransparency = 1
			}
			local v19 = if props.isDualLayout then loginView.errorTextSize else v5.Font.BaseSize * v5.Font.Footer.RelativeSize
			v18.TextSize = v19

			v18.TextXAlignment = Enum.TextXAlignment.Left
			v18.TextYAlignment = Enum.TextYAlignment.Center
			v18.TextColor3 = Colors.Red
			v16 = createElement2(fitTextLabel, v18, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, loginView.loginContentsPadding)
				})
			})
		end

		local v17 = if localizedError ~= "" then Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, loginView.errorTextPadding),
			PaddingBottom = UDim.new(0, loginView.errorTextPadding)
		}) else nil
		v12 = createElement("Frame", v14, { ErrorText = v16, ErrorPadding = v17 })
	elseif not props.disableRegularLogin then
		local createElement = Roact.createElement
		local v14 = {
			Size = UDim2.new(1, 0, 0, 0),
			width = UDim.new(1, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			Text = props.localizedError or props.localizedErrorMessage or "",
			Font = normalizeFontFace(v6.Typography.CaptionSmall.Font),
			TextSize = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextColor3 = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v15 = if props.isDualLayout then v6.FontSize.FontSize_250 else v5.Font.BaseSize * v5.Font.Footer.RelativeSize
		v14.TextSize = v15

		v14.TextXAlignment = Enum.TextXAlignment.Left
		v14.TextYAlignment = Enum.TextYAlignment.Center
		v14.TextColor3 = Colors.Red
		v12 = createElement(fitTextLabel, v14, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, loginView.loginContentsPadding)
			})
		})
	end

	local createElement = Roact.createElement
	local fitFrame = FitChildren.FitFrame
	local v13 = {
		Size = UDim2.new(1, -loginView.marginY, 0, 0),
		fitAxis = FitChildren.FitAxis.Height,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local v16 = {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = 0
	}
	local v17 = if props.showDisclaimerLinks then Enum.HorizontalAlignment.Center else nil
	v16.HorizontalAlignment = v17
	local v14 = {
		UIListLayout = createElement2("UIListLayout", v16),
		UISizeConstraint = 0,
		UIPadding = 0,
		TextBoxes = 0,
		ErrorText = 0,
		ErrorPadding = 0,
		LoginButton = 0,
		ForgotPasswordPadding = 0,
		ForgotPasswordButton = 0,
		EmailOtpPadding = 0,
		EmailOtpButton = 0,
		Padding = 0,
		CrossDeviceLoginButton = 0,
		OtherSignInOptions = 0,
		LinkAccountPadding = 0,
		LinkAccountLabel = 0,
		Forgot = 0,
		DisclaimerPadding = 0,
		DisclaimerLinks = 0
	}

	local v18 = if not props.isDualLayout then Roact.createElement("UISizeConstraint", {
		MinSize = Vector2.new(0, 0),
		MaxSize = Vector2.new(props.maxSizeX, 1e999)
	}) else nil
	v14.UISizeConstraint = v18
	local v19

	if props.isDualLayout then
		local createElement3 = Roact.createElement

		local v22 = if props.isDualLayout then UDim.new(0, loginView.credentialPaddingRight) else nil
		v19 = createElement3("UIPadding", { PaddingLeft = nil, PaddingRight = v22 })
	end

	v14.UIPadding = v19
	local v20

	if not props.disableRegularLogin then
		local createElement3 = Roact.createElement
		local v22 = {
			Size = UDim2.new(1, 0, 0, v11),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local children = {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, loginView.loginContentsPadding)
			}),
			CredentialHeader = 0,
			CValue = 0,
			PasswordTextBox = 0
		}

		local v23 = if props.showCredentialHeader then Roact.createElement("TextLabel", {
			Text = "<b>" .. v9.cvaluePlaceholder .. "</b>",
			RichText = true,
			FontFace = normalizeFontFace(v6.Typography.BodyLarge.Font),
			TextSize = v5.Font.BaseSize * v5.Font.Body.RelativeSize,
			TextColor3 = v5.Theme.TextEmphasis.Color,
			TextTransparency = transparency,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.XY,
			Size = UDim2.new(1, 0, 0, 0),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}) else nil
		children.CredentialHeader = v23

		local createElement4 = Roact.createElement
		local v26 = if v10 then v9.cvaluePlaceholder else nil
		local v25 = {
			LabelText = v26,
			TextBoxLabelPadding = textboxLabelPadding,
			TextBoxLabelTextSize = if v10 then textboxLabelHeight else nil,
			ChildClass = genericTextBox,
			Size = UDim2.new(1, 0, 0, loginView.textboxHeight),
			LayoutOrder = 2,
			buttonRef = props.buttonRef,
			ChildProps = 0
		}
		local v28 = {
			Text = props.cvalueText,
			PlaceholderText = v9.cvaluePlaceholder,
			Font = appFonts.default:getDefault(),
			TextSize = textboxTextSize,
			TextXAlignment = Enum.TextXAlignment.Left,
			Color = color2,
			Transparency = transparency2,
			TextColor = color,
			PlaceholderColor = color3,
			TextTransparency = transparency,
			PaddingX = loginView.textboxPaddingX,
			PaddingY = loginView.textboxPaddingY,
			ClearTextOnFocus = false,
			TextBoxRef = props.cvalueRef,
			LayoutOrder = 1,
			TextInputType = props.usernameTextInputType,
			openTypeFeatures = 0,
			ReturnKeyType = 0,
			ManualFocusRelease = true,
			onChangeText = 0,
			onReturnPressedFromOnScreenKeyboard = 0,
			onFocused = 0,
			NextSelectionUp = 0,
			NextSelectionDown = 0
		}
		local v29 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
		v28.openTypeFeatures = v29

		v28.ReturnKeyType = Enum.ReturnKeyType.Next

		v28.onChangeText = props.onTextBoxesChanged
		v28.onReturnPressedFromOnScreenKeyboard = props.onReturnPressedFromOnScreenKeyboardWhenFocusedOnCValue
		v28.onFocused = props.cvalueTextBoxOnFocus
		v28.NextSelectionUp = props.forgotLinkRef
		v28.NextSelectionDown = props.passwordRef
		v25.ChildProps = v28
		children.CValue = createElement4(textBoxStateWrapper, v25)

		local createElement5 = Roact.createElement
		local v32 = if v10 then v9.passwordPlaceholder else nil

		if not v10 then
			textboxLabelHeight = nil
		end

		children.PasswordTextBox = createElement5(textBoxStateWrapper, {
			LabelText = v32,
			TextBoxLabelPadding = textboxLabelPadding,
			TextBoxLabelTextSize = textboxLabelHeight,
			ChildClass = passwordBox,
			Size = UDim2.new(1, 0, 0, loginView.textboxHeight),
			LayoutOrder = 3,
			ChildProps = {
				Text = props.passwordText,
				PlaceholderText = v9.passwordPlaceholder,
				TextSize = textboxTextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				Color = color2,
				Transparency = transparency2,
				TextColor = color,
				PlaceholderColor = color3,
				TextTransparency = transparency,
				PaddingX = loginView.textboxPaddingX,
				PaddingY = loginView.textboxPaddingY,
				ClearTextOnFocus = false,
				ManualFocusRelease = true,
				IsKeyboardOverlayUsed = v7.uiMode ~= uiMode.VR,
				ReturnKeyType = Enum.ReturnKeyType.Done,
				TextBoxRef = props.passwordRef,
				onChangeText = props.onTextBoxesChanged,
				onReturnPressedFromOnScreenKeyboard = props.onReturnPressedFromOnScreenKeyboardWhenFocusedOnPassword,
				onFocused = props.passwordTextBoxOnFocus,
				onToggleCallback = props.passwordVisibilityToggleCallback,
				NextSelectionUp = props.cvalueRef,
				NextSelectionDown = props.loginButtonRef
			}
		})
		v20 = createElement3("Frame", v22, children)
	end

	v14.TextBoxes = v20

	v14.ErrorText = v12
	local v21 = if props.isDualLayout and not (showLinkAccountText or props.disableRegularLogin) then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.linkAccountPadding),
		LayoutOrder = 10
	}) else nil
	v14.ErrorPadding = v21

	local v22 = if not props.disableRegularLogin then Roact.createElement(button, {
		testId = "--auth-login-button-submit",
		variant = buttonVariant.SubEmphasis,
		size = buttonSize.Large,
		text = v9.logInText,
		isDisabled = props.loginButtonDisabled,
		isLoading = props.isLoginInProgress,
		onActivated = props.onLoginButtonActivated,
		NextSelectionUp = props.passwordRef,
		NextSelectionDown = props.emailOtpEnabled and props.emailOtpRef or props.crossDeviceLoginEnabled and props.crossDeviceButtonRef or props.forgotLinkRef,
		width = UDim.new(1, 0),
		LayoutOrder = 20,
		ref = props.loginButtonRef
	}) else nil
	v14.LoginButton = v22

	local v23 = if props.isDualLayout then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.loginContentsPadding),
		LayoutOrder = 22
	}) else nil
	v14.ForgotPasswordPadding = v23
	local v24

	if props.isDualLayout then
		local createElement3 = Roact.createElement

		local v27 = if module9 then buttonVariant.Standard else buttonVariant.Subtle
		v24 = createElement3(button, {
			testId = "--auth-login-button-forgot-password",
			variant = v27,
			size = buttonSize.Large,
			text = v9.forgotText,
			onActivated = props.onForgetButtonActivated,
			width = UDim.new(1, 0),
			LayoutOrder = 24
		})
	end

	v14.ForgotPasswordButton = v24

	v14.EmailOtpPadding = props.emailOtpEnabled
		and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, loginView.loginContentsPadding),
			LayoutOrder = 25
		})

	local v25 = props.emailOtpEnabled

	if v25 then
		local createElement3 = Roact.createElement

		local v28 = if module9 then buttonVariant.Standard else buttonVariant.Subtle
		v25 = createElement3(button, {
			testId = "--auth-login-button-email-otp",
			variant = v28,
			size = buttonSize.Large,
			text = v9.emailOtpButtonText,
			onActivated = props.onEmailOtpActivated,
			width = UDim.new(1, 0),
			LayoutOrder = 26,
			NextSelectionUp = props.loginButtonRef or props.crossDeviceButtonRef,
			NextSelectionDown = props.crossDeviceLoginEnabled and props.crossDeviceButtonRef or props.forgotLinkRef,
			ref = props.emailOtpRef
		})
	end

	v14.EmailOtpButton = v25

	local v26 = if props.crossDeviceLoginEnabled and not props.disableRegularLogin then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.loginContentsPadding),
		LayoutOrder = 30
	}) else nil
	v14.Padding = v26

	local v27 = props.crossDeviceLoginEnabled

	if v27 then
		if props.loginWithExistingAccountVariantEnabled then
			v27 = Roact.createElement(module6, {
				testId = "auth-login-button-cross-device",
				Text = props.quickLoginButtonText,
				Size = UDim2.new(1, 0, 0, loginView.crossdeviceButtonHeight),
				onActivated = props.onCrossDeviceLoginActivated,
				LayoutOrder = 40,
				Font = v5.Font.Header2.Font,
				NextSelectionUp = props.emailOtpEnabled and props.emailOtpRef or props.loginButtonRef,
				NextSelectionDown = props.forgotLinkRef,
				TextSize = loginView.loginTextSize,
				themeSettings = {
					Color = v6.Color.ActionEmphasis.Background.Color3,
					Transparency = 0,
					OnPressColor = v6.Color.ActionEmphasis.Background.Color3,
					OnPressTransparency = 0.3,
					Text = { Color = Colors.White, Transparency = 0 },
					Border = { Hidden = true, Transparency = 1 }
				},
				[Roact.Ref] = props.crossDeviceButtonRef
			})
		else
			local createElement3 = Roact.createElement

			local v30 = if module9 then buttonVariant.Standard else buttonVariant.Subtle
			v27 = createElement3(button, {
				testId = "--auth-login-button-cross-device",
				variant = v30,
				size = buttonSize.Large,
				text = props.quickLoginButtonText,
				onActivated = props.onCrossDeviceLoginActivated,
				width = UDim.new(1, 0),
				LayoutOrder = 40,
				NextSelectionUp = props.emailOtpEnabled and props.emailOtpRef or props.loginButtonRef,
				NextSelectionDown = props.forgotLinkRef,
				ref = props.crossDeviceButtonRef
			})
		end
	end

	v14.CrossDeviceLoginButton = v27

	local v28 = if module10 then Roact.createElement(module8, { LayoutOrder = 41 }) else nil
	v14.OtherSignInOptions = v28

	local v29 = if showLinkAccountText then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.linkAccountPadding),
		LayoutOrder = 43
	}) else nil
	v14.LinkAccountPadding = v29

	local v30 = if showLinkAccountText then Roact.createElement("TextLabel", {
		Text = v9.linkAccountText,
		TextSize = v6.FontSize.FontSize_250,
		FontFace = normalizeFontFace(v6.Typography.CaptionSmall.Font),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		TextTransparency = v5.Theme.TextMuted.Transparency,
		TextColor3 = v5.Theme.TextMuted.Color,
		TextWrapped = true,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		LayoutOrder = 45
	}, {
		UISizeConstraint = Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, loginView.loginContentsPadding)
		})
	}) else nil
	v14.LinkAccountLabel = v30

	local v31 = if props.showForgotButton then Roact.createElement(linkButton, {
		text = v9.forgotText,
		size = UDim2.new(0, 0, 0, loginView.forgotLinkHeight),
		fontStyle = "CaptionSubHeader",
		onActivated = props.onForgetButtonActivated,
		colorStyleDefault = "TextDefault",
		colorStyleHover = "TextDefault",
		layoutOrder = 48
	}) else nil
	v14.Forgot = v31

	local v32 = if showDisclaimerLinks then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.disclaimerPadding),
		LayoutOrder = 50
	}) else nil
	v14.DisclaimerPadding = v32

	local v33 = if showDisclaimerLinks then Roact.createElement(module7, {
		isDualLayout = props.showDisclaimerButtons,
		LayoutOrder = 60
	}) else nil
	v14.DisclaimerLinks = v33
	return createElement(fitFrame, v13, v14)
end
