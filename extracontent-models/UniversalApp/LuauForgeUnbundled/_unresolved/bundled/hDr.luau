local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local button = Foundation.Button
local buttonVariant = Foundation.Enums.ButtonVariant
local buttonSize = Foundation.Enums.ButtonSize
local appFonts = require("@game/CorePackages/Workspace/Packages/Style").AppFonts

local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local module = require("@luauforge/bundled/fTi")
local useAppPolicy = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useAppPolicy")

local AuthCommon = require("@game/CorePackages/Workspace/Packages/AuthCommon")

local FitChildren = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/FitChildren")
local textBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local genericTextBox = AuthCommon.Components.GenericTextBox
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local v5

if foundationFontFaceMigration then
	local FitFrame = require(CorePackages.Packages.FitFrame)
	v5 = FitFrame.FitTextLabel
else
	v5 = require("@luauforge/bundled/fpE")
end

local Colors = require("@game/CoreGui/RobloxGui/Modules/InspectAndBuy/Colors")
local passwordBox = AuthCommon.Components.PasswordBox
local module6 = require("@luauforge/bundled/hDs")
local module7 = require("@luauforge/bundled/fNe")
local module8 = require("@luauforge/bundled/hDt")
local linkButton = UIBlox.App.Button.LinkButton
local openTypeSupport = UIBlox.Utility.OpenTypeSupport

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/Style").useDesignTokens
local useUiModeInfo = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useUiModeInfo
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode

local getFFlagLuaAppEnableOpenTypeSupport = require("@game/CorePackages/Workspace/Packages/SharedFlags").GetFFlagLuaAppEnableOpenTypeSupport
local module9 = require("@luauforge/bundled/fyp")

local module10 = require("@luauforge/bundled/hDv")

return function(props)
	local v6 = useStyle()
	local v7 = useDesignTokens()
	local v8 = useUiModeInfo()
	local loginView = v7.LuaApps.LoginView

	local color = v6.Theme.TextDefault.Color
	local transparency = v6.Theme.TextDefault.Transparency
	local color2 = v6.Theme.BackgroundUIContrast.Color
	local transparency2 = v6.Theme.BackgroundUIContrast.Transparency
	local color3 = v6.Theme.TextDefault.Color

	local v9 = useAppPolicy(function(p2)
		return p2.getPlatformAccountName()
	end)

	local v10 = module({
		logInText = "Authentication.Login.Action.SignIn",
		cvaluePlaceholder = props.forceLoginByUsername and "Authentication.Login.Label.Username" or "Authentication.Login.Label.UsernameEmailPhone",
		passwordPlaceholder = "CommonUI.Messages.Label.Password",
		linkAccountText = {
			"Authentication.Login.Label.LinkAccountWarning",
			platform = v9 or "Console"
		},
		forgotText = "Authentication.Login.Action.ForgotPasswordOrUsernameQuestionCapitalized",
		emailOtpButtonText = "Authentication.Login.Action.LogInEmailOneTimeCode"
	})

	local showLinkAccountText = props.showLinkAccountText
	local showDisclaimerLinks = props.showDisclaimerLinks or props.showDisclaimerButtons
	local v11 = props.isDualLayout and not props.showCredentialHeader

	local v12 = loginView.textboxHeight * 2 + loginView.loginContentsPadding
	local textboxLabelHeight

	if props.isDualLayout then
		textboxLabelHeight = loginView.textboxLabelHeight

		if v11 then
			v12 = (loginView.textboxHeight + textboxLabelHeight + loginView.textboxLabelPadding) * 2 + loginView.loginContentsPadding
		else
			v12 = (loginView.textboxHeight + textboxLabelHeight) * 2 + loginView.textboxLabelPadding + loginView.loginContentsPadding
		end
	end

	local textboxLabelPadding = if props.isDualLayout then loginView.textboxLabelPadding else nil
	local textboxTextSize = loginView.textboxTextSize
	local v13

	if props.isDualLayout and props.isTenFootUiMode then
		local localizedError = props.localizedError or props.localizedErrorMessage or ""
		local createElement = Roact.createElement
		local v15 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v17

		if not props.disableRegularLogin then
			local createElement2 = Roact.createElement
			local v19 = {
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = 0,
				width = 0,
				AnchorPoint = 0,
				Text = 0,
				Font = 0,
				TextSize = 0,
				TextXAlignment = 0,
				TextYAlignment = 0,
				TextColor3 = 0,
				TextWrapped = true,
				BackgroundTransparency = 1
			}
			local v20 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
			v19.fitAxis = v20
			local v21 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
			v19.width = v21
			v19.AnchorPoint = Vector2.new(0, 0)
			v19.Text = localizedError

			local v22 = if foundationFontFaceMigration then normalizeFontFace(v7.Typography.CaptionSmall.Font) else v6.Font.Footer.Font
			v19.Font = v22

			local v23 = if props.isDualLayout then loginView.errorTextSize else v6.Font.BaseSize * v6.Font.Footer.RelativeSize
			v19.TextSize = v23

			v19.TextXAlignment = Enum.TextXAlignment.Left
			v19.TextYAlignment = Enum.TextYAlignment.Center
			v19.TextColor3 = Colors.Red
			v17 = createElement2(v5, v19, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, loginView.loginContentsPadding)
				})
			})
		end

		local v18 = if localizedError ~= "" then Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, loginView.errorTextPadding),
			PaddingBottom = UDim.new(0, loginView.errorTextPadding)
		}) else nil
		v13 = createElement("Frame", v15, { ErrorText = v17, ErrorPadding = v18 })
	elseif not props.disableRegularLogin then
		local createElement = Roact.createElement
		local v15 = {
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = 0,
			width = 0,
			AnchorPoint = 0,
			Text = 0,
			Font = 0,
			TextSize = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextColor3 = 0,
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2
		}
		local v16 = if not foundationFontFaceMigration then FitChildren.FitAxis.Height else nil
		v15.fitAxis = v16
		local v17 = if foundationFontFaceMigration then UDim.new(1, 0) else nil
		v15.width = v17
		v15.AnchorPoint = Vector2.new(0, 0.5)
		v15.Text = props.localizedError or props.localizedErrorMessage or ""

		local v18 = if foundationFontFaceMigration then normalizeFontFace(v7.Typography.CaptionSmall.Font) else v6.Font.Footer.Font
		v15.Font = v18

		local v19 = if props.isDualLayout then v7.FontSize.FontSize_250 else v6.Font.BaseSize * v6.Font.Footer.RelativeSize
		v15.TextSize = v19

		v15.TextXAlignment = Enum.TextXAlignment.Left
		v15.TextYAlignment = Enum.TextYAlignment.Center
		v15.TextColor3 = Colors.Red
		v13 = createElement(v5, v15, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, loginView.loginContentsPadding)
			})
		})
	end

	local createElement = Roact.createElement
	local fitFrame = FitChildren.FitFrame
	local v14 = {
		Size = UDim2.new(1, -loginView.marginY, 0, 0),
		fitAxis = FitChildren.FitAxis.Height,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		BackgroundTransparency = 1
	}

	local createElement2 = Roact.createElement
	local v17 = {
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = 0
	}
	local v18 = if props.showDisclaimerLinks then Enum.HorizontalAlignment.Center else nil
	v17.HorizontalAlignment = v18
	local v15 = {
		UIListLayout = createElement2("UIListLayout", v17),
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

	local v19 = if not props.isDualLayout then Roact.createElement("UISizeConstraint", {
		MinSize = Vector2.new(0, 0),
		MaxSize = Vector2.new(props.maxSizeX, 1e999)
	}) else nil
	v15.UISizeConstraint = v19
	local v20

	if props.isDualLayout then
		local createElement3 = Roact.createElement

		local v23 = if props.isDualLayout then UDim.new(0, loginView.credentialPaddingRight) else nil
		v20 = createElement3("UIPadding", { PaddingLeft = nil, PaddingRight = v23 })
	end

	v15.UIPadding = v20
	local v21

	if not props.disableRegularLogin then
		local createElement3 = Roact.createElement
		local v23 = {
			Size = UDim2.new(1, 0, 0, v12),
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
		local v24

		if props.showCredentialHeader then
			local createElement4 = Roact.createElement
			local v26 = {
				Text = "<b>" .. v10.cvaluePlaceholder .. "</b>",
				RichText = true,
				Font = 0,
				FontFace = 0,
				TextSize = 0,
				TextColor3 = 0,
				TextTransparency = 0,
				TextWrapped = true,
				TextXAlignment = 0,
				AutomaticSize = 0,
				Size = 0,
				BackgroundTransparency = 1,
				LayoutOrder = 1
			}

			local v27 = if not foundationFontFaceMigration then v6.Font.Body.Font else nil
			v26.Font = v27

			local v28 = if foundationFontFaceMigration then normalizeFontFace(v7.Typography.BodyLarge.Font) else nil
			v26.FontFace = v28

			v26.TextSize = v6.Font.BaseSize * v6.Font.Body.RelativeSize
			v26.TextColor3 = v6.Theme.TextEmphasis.Color
			v26.TextTransparency = transparency

			v26.TextXAlignment = Enum.TextXAlignment.Left
			v26.AutomaticSize = Enum.AutomaticSize.XY
			v26.Size = UDim2.new(1, 0, 0, 0)
			v24 = createElement4("TextLabel", v26)
		end

		children.CredentialHeader = v24

		local createElement4 = Roact.createElement
		local v27 = if v11 then v10.cvaluePlaceholder else nil
		local v26 = {
			LabelText = v27,
			TextBoxLabelPadding = textboxLabelPadding,
			TextBoxLabelTextSize = if v11 then textboxLabelHeight else nil,
			ChildClass = genericTextBox,
			Size = UDim2.new(1, 0, 0, loginView.textboxHeight),
			LayoutOrder = 2,
			buttonRef = props.buttonRef,
			ChildProps = 0
		}
		local v29 = {
			Text = props.cvalueText,
			PlaceholderText = v10.cvaluePlaceholder,
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
		local v30 = if getFFlagLuaAppEnableOpenTypeSupport() then openTypeSupport:getUserNameStylisticAlternative() else nil
		v29.openTypeFeatures = v30

		v29.ReturnKeyType = Enum.ReturnKeyType.Next

		v29.onChangeText = props.onTextBoxesChanged
		v29.onReturnPressedFromOnScreenKeyboard = props.onReturnPressedFromOnScreenKeyboardWhenFocusedOnCValue
		v29.onFocused = props.cvalueTextBoxOnFocus
		v29.NextSelectionUp = props.forgotLinkRef
		v29.NextSelectionDown = props.passwordRef
		v26.ChildProps = v29
		children.CValue = createElement4(textBoxStateWrapper, v26)

		local createElement5 = Roact.createElement
		local v33 = if v11 then v10.passwordPlaceholder else nil

		if not v11 then
			textboxLabelHeight = nil
		end

		children.PasswordTextBox = createElement5(textBoxStateWrapper, {
			LabelText = v33,
			TextBoxLabelPadding = textboxLabelPadding,
			TextBoxLabelTextSize = textboxLabelHeight,
			ChildClass = passwordBox,
			Size = UDim2.new(1, 0, 0, loginView.textboxHeight),
			LayoutOrder = 3,
			ChildProps = {
				Text = props.passwordText,
				PlaceholderText = v10.passwordPlaceholder,
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
				IsKeyboardOverlayUsed = v8.uiMode ~= uiMode.VR,
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
		v21 = createElement3("Frame", v23, children)
	end

	v15.TextBoxes = v21

	v15.ErrorText = v13
	local v22 = if props.isDualLayout and not (showLinkAccountText or props.disableRegularLogin) then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.linkAccountPadding),
		LayoutOrder = 10
	}) else nil
	v15.ErrorPadding = v22

	local v23 = if not props.disableRegularLogin then Roact.createElement(button, {
		testId = "--auth-login-button-submit",
		variant = buttonVariant.SubEmphasis,
		size = buttonSize.Large,
		text = v10.logInText,
		isDisabled = props.loginButtonDisabled,
		isLoading = props.isLoginInProgress,
		onActivated = props.onLoginButtonActivated,
		NextSelectionUp = props.passwordRef,
		NextSelectionDown = props.emailOtpEnabled and props.emailOtpRef or props.crossDeviceLoginEnabled and props.crossDeviceButtonRef or props.forgotLinkRef,
		width = UDim.new(1, 0),
		LayoutOrder = 20,
		ref = props.loginButtonRef
	}) else nil
	v15.LoginButton = v23

	local v24 = if props.isDualLayout then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.loginContentsPadding),
		LayoutOrder = 22
	}) else nil
	v15.ForgotPasswordPadding = v24
	local v25

	if props.isDualLayout then
		local createElement3 = Roact.createElement

		local v28 = if module9 then buttonVariant.Standard else buttonVariant.Subtle
		v25 = createElement3(button, {
			testId = "--auth-login-button-forgot-password",
			variant = v28,
			size = buttonSize.Large,
			text = v10.forgotText,
			onActivated = props.onForgetButtonActivated,
			width = UDim.new(1, 0),
			LayoutOrder = 24
		})
	end

	v15.ForgotPasswordButton = v25

	v15.EmailOtpPadding = props.emailOtpEnabled
		and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, loginView.loginContentsPadding),
			LayoutOrder = 25
		})

	local v26 = props.emailOtpEnabled

	if v26 then
		local createElement3 = Roact.createElement

		local v29 = if module9 then buttonVariant.Standard else buttonVariant.Subtle
		v26 = createElement3(button, {
			testId = "--auth-login-button-email-otp",
			variant = v29,
			size = buttonSize.Large,
			text = v10.emailOtpButtonText,
			onActivated = props.onEmailOtpActivated,
			width = UDim.new(1, 0),
			LayoutOrder = 26,
			NextSelectionUp = props.loginButtonRef or props.crossDeviceButtonRef,
			NextSelectionDown = props.crossDeviceLoginEnabled and props.crossDeviceButtonRef or props.forgotLinkRef,
			ref = props.emailOtpRef
		})
	end

	v15.EmailOtpButton = v26

	local v27 = if props.crossDeviceLoginEnabled and not props.disableRegularLogin then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.loginContentsPadding),
		LayoutOrder = 30
	}) else nil
	v15.Padding = v27

	local v28 = props.crossDeviceLoginEnabled

	if v28 then
		if props.loginWithExistingAccountVariantEnabled then
			v28 = Roact.createElement(module6, {
				testId = "auth-login-button-cross-device",
				Text = props.quickLoginButtonText,
				Size = UDim2.new(1, 0, 0, loginView.crossdeviceButtonHeight),
				onActivated = props.onCrossDeviceLoginActivated,
				LayoutOrder = 40,
				Font = v6.Font.Header2.Font,
				NextSelectionUp = props.emailOtpEnabled and props.emailOtpRef or props.loginButtonRef,
				NextSelectionDown = props.forgotLinkRef,
				TextSize = loginView.loginTextSize,
				themeSettings = {
					Color = v7.Color.ActionEmphasis.Background.Color3,
					Transparency = 0,
					OnPressColor = v7.Color.ActionEmphasis.Background.Color3,
					OnPressTransparency = 0.3,
					Text = { Color = Colors.White, Transparency = 0 },
					Border = { Hidden = true, Transparency = 1 }
				},
				[Roact.Ref] = props.crossDeviceButtonRef
			})
		else
			local createElement3 = Roact.createElement

			local v31 = if module9 then buttonVariant.Standard else buttonVariant.Subtle
			v28 = createElement3(button, {
				testId = "--auth-login-button-cross-device",
				variant = v31,
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

	v15.CrossDeviceLoginButton = v28

	local v29 = if module10 then Roact.createElement(module8, { LayoutOrder = 41 }) else nil
	v15.OtherSignInOptions = v29

	local v30 = if showLinkAccountText then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.linkAccountPadding),
		LayoutOrder = 43
	}) else nil
	v15.LinkAccountPadding = v30
	local v31

	if showLinkAccountText then
		local createElement3 = Roact.createElement
		local v33 = {
			Text = v10.linkAccountText,
			TextSize = v7.FontSize.FontSize_250,
			Font = 0,
			FontFace = 0,
			TextXAlignment = 0,
			TextYAlignment = 0,
			TextTransparency = 0,
			TextColor3 = 0,
			TextWrapped = true,
			Size = 0,
			AutomaticSize = 0,
			AnchorPoint = 0,
			BackgroundTransparency = 1,
			LayoutOrder = 45
		}
		local v34 = if not foundationFontFaceMigration then v6.Font.Footer.Font else nil
		v33.Font = v34

		local v35 = if foundationFontFaceMigration then normalizeFontFace(v7.Typography.CaptionSmall.Font) else nil
		v33.FontFace = v35

		v33.TextXAlignment = Enum.TextXAlignment.Left
		v33.TextYAlignment = Enum.TextYAlignment.Center
		v33.TextTransparency = v6.Theme.TextMuted.Transparency
		v33.TextColor3 = v6.Theme.TextMuted.Color

		v33.Size = UDim2.new(1, 0, 0, 0)
		v33.AutomaticSize = Enum.AutomaticSize.Y
		v33.AnchorPoint = Vector2.new(0, 0.5)
		v31 = createElement3("TextLabel", v33, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, loginView.loginContentsPadding)
			})
		})
	end

	v15.LinkAccountLabel = v31

	local v32 = if props.showForgotButton then Roact.createElement(linkButton, {
		text = v10.forgotText,
		size = UDim2.new(0, 0, 0, loginView.forgotLinkHeight),
		fontStyle = "CaptionSubHeader",
		onActivated = props.onForgetButtonActivated,
		colorStyleDefault = "TextDefault",
		colorStyleHover = "TextDefault",
		layoutOrder = 48
	}) else nil
	v15.Forgot = v32

	local v33 = if showDisclaimerLinks then Roact.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, loginView.disclaimerPadding),
		LayoutOrder = 50
	}) else nil
	v15.DisclaimerPadding = v33

	local v34 = if showDisclaimerLinks then Roact.createElement(module7, {
		isDualLayout = props.showDisclaimerButtons,
		LayoutOrder = 60
	}) else nil
	v15.DisclaimerLinks = v34
	return createElement(fitFrame, v14, v15)
end
