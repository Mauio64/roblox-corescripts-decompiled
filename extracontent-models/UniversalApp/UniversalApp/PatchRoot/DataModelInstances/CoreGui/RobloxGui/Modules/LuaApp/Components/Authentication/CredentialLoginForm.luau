local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local Foundation = require(CorePackages.Packages.Foundation)
local Button = Foundation.Button
local ButtonVariant = Foundation.Enums.ButtonVariant
local ButtonSize = Foundation.Enums.ButtonSize
local AppFonts = require(CorePackages.Workspace.Packages.Style).AppFonts
local UIBlox = require(CorePackages.Packages.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require(Modules.LuaApp.Hooks.useLocalization)
local useAppPolicy = require(Modules.LuaApp.Hooks.useAppPolicy)
local AuthCommon = require(CorePackages.Workspace.Packages.AuthCommon)
local FitChildren = require(Modules.LuaApp.FitChildren)
local TextBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local GenericTextBox = AuthCommon.Components.GenericTextBox
local FitTextLabel = require(Modules.LuaApp.Components.FitTextLabel)
local Colors = require(Modules.LuaApp.Themes.Colors)
local PasswordBox = AuthCommon.Components.PasswordBox
local GenericTextButton = require(Modules.LuaApp.Components.GenericTextButton)
local DisclaimerLinks = require(Modules.LuaApp.Components.Authentication.DisclaimerLinks)
local LinkButton = UIBlox.App.Button.LinkButton
local OpenTypeSupport = UIBlox.Utility.OpenTypeSupport
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local useUiModeInfo = require(CorePackages.Workspace.Packages.RobloxAppHooks).useUiModeInfo
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local GetFFlagLuaAppEnableOpenTypeSupport = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagLuaAppEnableOpenTypeSupport
local FFlagUseStandardFoundationButtonVariant = require(Modules.LuaApp.Flags.FFlagUseStandardFoundationButtonVariant)

return function(p1) -- line: 40
	-- upvalues: useStyle (copy), useDesignTokens (copy), useUiModeInfo (copy), useAppPolicy (copy), useLocalization (copy), Roact (copy), FitTextLabel (copy), FitChildren (copy), Colors (copy), TextBoxStateWrapper (copy), GenericTextBox (copy), AppFonts (copy), GetFFlagLuaAppEnableOpenTypeSupport (copy), OpenTypeSupport (copy), PasswordBox (copy), UiMode (copy), Button (copy), ButtonVariant (copy), ButtonSize (copy), FFlagUseStandardFoundationButtonVariant (copy), GenericTextButton (copy), LinkButton (copy), DisclaimerLinks (copy)
	local v30 = useStyle()
	local v31 = useDesignTokens()
	local v32 = useUiModeInfo()
	local LoginView = v31.LuaApps.LoginView
	local TextDefaultColor = v30.Theme.TextDefault.Color
	local TextDefaultTransparency = v30.Theme.TextDefault.Transparency
	local BackgroundUIContrastColor = v30.Theme.BackgroundUIContrast.Color
	local BackgroundUIContrastTransparency = v30.Theme.BackgroundUIContrast.Transparency
	local TextDefaultColor2 = v30.Theme.TextDefault.Color
	local v39 = useAppPolicy(function(p2) -- line: 52
		return p2.getPlatformAccountName()
	end)
	local v40 = useLocalization({
		logInText = "Authentication.Login.Action.SignIn",
		passwordPlaceholder = "CommonUI.Messages.Label.Password",
		forgotText = "Authentication.Login.Action.ForgotPasswordOrUsernameQuestionCapitalized",
		emailOtpButtonText = "Authentication.Login.Action.LogInEmailOneTimeCode",
		cvaluePlaceholder = not p1.forceLoginByUsername and "Authentication.Login.Label.UsernameEmailPhone" or "Authentication.Login.Label.Username",
		linkAccountText = {
			"Authentication.Login.Label.LinkAccountWarning",
			platform = v39 or "Console"
		}
	})
	local showLinkAccountText = p1.showLinkAccountText
	local v42 = p1.showDisclaimerLinks or p1.showDisclaimerButtons
	local v43 = p1.isDualLayout and not p1.showCredentialHeader
	local textboxLabelHeight = nil
	local v45 = LoginView.textboxHeight * 2 + LoginView.loginContentsPadding

	if p1.isDualLayout then
		textboxLabelHeight = LoginView.textboxLabelHeight
		v45 = if not v43 then (LoginView.textboxHeight + textboxLabelHeight) * 2 + LoginView.textboxLabelPadding + LoginView.loginContentsPadding else (LoginView.textboxHeight + textboxLabelHeight + LoginView.textboxLabelPadding) * 2 + LoginView.loginContentsPadding
	end

	local v46 = if not p1.isDualLayout then nil else LoginView.textboxLabelPadding
	local textboxTextSize = LoginView.textboxTextSize
	local v49

	if p1.isDualLayout and p1.isTenFootUiMode then
		local v48 = p1.localizedError or (p1.localizedErrorMessage or "")

		v49 = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}, {
			ErrorText = if p1.disableRegularLogin then nil else Roact.createElement(FitTextLabel, {
				TextWrapped = true,
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0),
				fitAxis = FitChildren.FitAxis.Height,
				AnchorPoint = Vector2.new(0, 0),
				Text = v48,
				Font = v30.Font.Footer.Font,
				TextSize = if not p1.isDualLayout then v30.Font.BaseSize * v30.Font.Footer.RelativeSize else LoginView.errorTextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				TextColor3 = Colors.Red
			}, {
				UISizeConstraint = Roact.createElement("UISizeConstraint", {
					MinSize = Vector2.new(0, LoginView.loginContentsPadding)
				})
			}),
			ErrorPadding = if v48 == "" then nil else Roact.createElement("UIPadding", {
				PaddingTop = UDim.new(0, LoginView.errorTextPadding),
				PaddingBottom = UDim.new(0, LoginView.errorTextPadding)
			})
		})
	else
		v49 = if p1.disableRegularLogin then nil else Roact.createElement(FitTextLabel, {
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 0),
			fitAxis = FitChildren.FitAxis.Height,
			AnchorPoint = Vector2.new(0, 0.5),
			Text = p1.localizedError or (p1.localizedErrorMessage or ""),
			Font = v30.Font.Footer.Font,
			TextSize = if not p1.isDualLayout then v30.Font.BaseSize * v30.Font.Footer.RelativeSize else v31.FontSize.FontSize_250,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextColor3 = Colors.Red
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, LoginView.loginContentsPadding)
			})
		})
	end

	return Roact.createElement(FitChildren.FitFrame, {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -LoginView.marginY, 0, 0),
		fitAxis = FitChildren.FitAxis.Height,
		Position = UDim2.new(0.5, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0)
	}, {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = if not p1.showDisclaimerLinks then nil else Enum.HorizontalAlignment.Center
		}),
		UISizeConstraint = if p1.isDualLayout then nil else Roact.createElement("UISizeConstraint", {
			MinSize = Vector2.new(0, 0),
			MaxSize = Vector2.new(p1.maxSizeX, 1e999)
		}),
		UIPadding = if not p1.isDualLayout then nil else Roact.createElement("UIPadding", {
			PaddingLeft = nil,
			PaddingRight = if not p1.isDualLayout then nil else UDim.new(0, LoginView.credentialPaddingRight)
		}),
		TextBoxes = if p1.disableRegularLogin then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, v45)
		}, {
			UIListLayout = Roact.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, LoginView.loginContentsPadding)
			}),
			CredentialHeader = if not p1.showCredentialHeader then nil else Roact.createElement("TextLabel", {
				RichText = true,
				TextWrapped = true,
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				Text = "<b>" .. v40.cvaluePlaceholder .. "</b>",
				Font = v30.Font.Body.Font,
				TextSize = v30.Font.BaseSize * v30.Font.Body.RelativeSize,
				TextColor3 = v30.Theme.TextEmphasis.Color,
				TextTransparency = TextDefaultTransparency,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(1, 0, 0, 0)
			}),
			CValue = Roact.createElement(TextBoxStateWrapper, {
				LayoutOrder = 2,
				LabelText = if not v43 then nil else v40.cvaluePlaceholder,
				TextBoxLabelPadding = v46,
				TextBoxLabelTextSize = if not v43 then nil else textboxLabelHeight,
				ChildClass = GenericTextBox,
				Size = UDim2.new(1, 0, 0, LoginView.textboxHeight),
				buttonRef = p1.buttonRef,
				ChildProps = {
					ClearTextOnFocus = false,
					LayoutOrder = 1,
					ManualFocusRelease = true,
					Text = p1.cvalueText,
					PlaceholderText = v40.cvaluePlaceholder,
					Font = AppFonts.default:getDefault(),
					TextSize = textboxTextSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					Color = BackgroundUIContrastColor,
					Transparency = BackgroundUIContrastTransparency,
					TextColor = TextDefaultColor,
					PlaceholderColor = TextDefaultColor2,
					TextTransparency = TextDefaultTransparency,
					PaddingX = LoginView.textboxPaddingX,
					PaddingY = LoginView.textboxPaddingY,
					TextBoxRef = p1.cvalueRef,
					TextInputType = p1.usernameTextInputType,
					openTypeFeatures = if not GetFFlagLuaAppEnableOpenTypeSupport() then nil else OpenTypeSupport:getUserNameStylisticAlternative(),
					ReturnKeyType = Enum.ReturnKeyType.Next,
					onChangeText = p1.onTextBoxesChanged,
					onReturnPressedFromOnScreenKeyboard = p1.onReturnPressedFromOnScreenKeyboardWhenFocusedOnCValue,
					onFocused = p1.cvalueTextBoxOnFocus,
					NextSelectionUp = p1.forgotLinkRef,
					NextSelectionDown = p1.passwordRef
				}
			}),
			PasswordTextBox = Roact.createElement(TextBoxStateWrapper, {
				LayoutOrder = 3,
				LabelText = if not v43 then nil else v40.passwordPlaceholder,
				TextBoxLabelPadding = v46,
				TextBoxLabelTextSize = if not v43 then nil else textboxLabelHeight,
				ChildClass = PasswordBox,
				Size = UDim2.new(1, 0, 0, LoginView.textboxHeight),
				ChildProps = {
					ClearTextOnFocus = false,
					ManualFocusRelease = true,
					Text = p1.passwordText,
					PlaceholderText = v40.passwordPlaceholder,
					TextSize = textboxTextSize,
					TextXAlignment = Enum.TextXAlignment.Left,
					Color = BackgroundUIContrastColor,
					Transparency = BackgroundUIContrastTransparency,
					TextColor = TextDefaultColor,
					PlaceholderColor = TextDefaultColor2,
					TextTransparency = TextDefaultTransparency,
					PaddingX = LoginView.textboxPaddingX,
					PaddingY = LoginView.textboxPaddingY,
					IsKeyboardOverlayUsed = v32.uiMode ~= UiMode.VR,
					ReturnKeyType = Enum.ReturnKeyType.Done,
					TextBoxRef = p1.passwordRef,
					onChangeText = p1.onTextBoxesChanged,
					onReturnPressedFromOnScreenKeyboard = p1.onReturnPressedFromOnScreenKeyboardWhenFocusedOnPassword,
					onFocused = p1.passwordTextBoxOnFocus,
					onToggleCallback = p1.passwordVisibilityToggleCallback,
					NextSelectionUp = p1.cvalueRef,
					NextSelectionDown = p1.loginButtonRef
				}
			})
		}),
		ErrorText = v49,
		ErrorPadding = if not p1.isDualLayout or (showLinkAccountText or p1.disableRegularLogin) then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 10,
			Size = UDim2.new(1, 0, 0, LoginView.linkAccountPadding)
		}),
		LoginButton = if p1.disableRegularLogin then nil else Roact.createElement(Button, {
			LayoutOrder = 20,
			variant = ButtonVariant.SubEmphasis,
			size = ButtonSize.Large,
			text = v40.logInText,
			isDisabled = p1.loginButtonDisabled,
			isLoading = p1.isLoginInProgress,
			onActivated = p1.onLoginButtonActivated,
			NextSelectionUp = p1.passwordRef,
			NextSelectionDown = p1.emailOtpEnabled and p1.emailOtpRef or (p1.crossDeviceLoginEnabled and p1.crossDeviceButtonRef or p1.forgotLinkRef),
			width = UDim.new(1, 0),
			ref = p1.loginButtonRef
		}),
		ForgotPasswordPadding = if not p1.isDualLayout then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 22,
			Size = UDim2.new(1, 0, 0, LoginView.loginContentsPadding)
		}),
		ForgotPasswordButton = if not p1.isDualLayout then nil else Roact.createElement(Button, {
			LayoutOrder = 24,
			variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
			size = ButtonSize.Large,
			text = v40.forgotText,
			onActivated = p1.onForgetButtonActivated,
			width = UDim.new(1, 0)
		}),
		EmailOtpPadding = p1.emailOtpEnabled and Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 25,
			Size = UDim2.new(1, 0, 0, LoginView.loginContentsPadding)
		}),
		EmailOtpButton = p1.emailOtpEnabled and Roact.createElement(Button, {
			LayoutOrder = 26,
			variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
			size = ButtonSize.Large,
			text = v40.emailOtpButtonText,
			onActivated = p1.onEmailOtpActivated,
			width = UDim.new(1, 0),
			NextSelectionUp = p1.loginButtonRef or p1.crossDeviceButtonRef,
			NextSelectionDown = p1.crossDeviceLoginEnabled and p1.crossDeviceButtonRef or p1.forgotLinkRef,
			ref = p1.emailOtpRef
		}),
		Padding = if not p1.crossDeviceLoginEnabled or p1.disableRegularLogin then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 30,
			Size = UDim2.new(1, 0, 0, LoginView.loginContentsPadding)
		}),
		CrossDeviceLoginButton = p1.crossDeviceLoginEnabled and if not p1.loginWithExistingAccountVariantEnabled then Roact.createElement(Button, {
			LayoutOrder = 40,
			variant = if not FFlagUseStandardFoundationButtonVariant then ButtonVariant.Subtle else ButtonVariant.Standard,
			size = ButtonSize.Large,
			text = p1.quickLoginButtonText,
			onActivated = p1.onCrossDeviceLoginActivated,
			width = UDim.new(1, 0),
			NextSelectionUp = p1.emailOtpEnabled and p1.emailOtpRef or p1.loginButtonRef,
			NextSelectionDown = p1.forgotLinkRef,
			ref = p1.crossDeviceButtonRef
		}) else Roact.createElement(GenericTextButton, {
			Text = p1.quickLoginButtonText,
			Size = UDim2.new(1, 0, 0, LoginView.crossdeviceButtonHeight),
			onActivated = p1.onCrossDeviceLoginActivated,
			LayoutOrder = 40,
			Font = v30.Font.Header2.Font,
			NextSelectionUp = p1.emailOtpEnabled and p1.emailOtpRef or p1.loginButtonRef,
			NextSelectionDown = p1.forgotLinkRef,
			TextSize = LoginView.loginTextSize,
			themeSettings = {
				Transparency = 0,
				OnPressTransparency = 0.3,
				Color = v31.Color.ActionEmphasis.Background.Color3,
				OnPressColor = v31.Color.ActionEmphasis.Background.Color3,
				Text = {
					Transparency = 0,
					Color = Colors.White
				},
				Border = {
					Hidden = true,
					Transparency = 1
				}
			},
			[Roact.Ref] = p1.crossDeviceButtonRef
		}),
		LinkAccountPadding = if not showLinkAccountText then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 43,
			Size = UDim2.new(1, 0, 0, LoginView.linkAccountPadding)
		}),
		LinkAccountLabel = if not showLinkAccountText then nil else Roact.createElement("TextLabel", {
			TextWrapped = true,
			BackgroundTransparency = 1,
			LayoutOrder = 45,
			Text = v40.linkAccountText,
			TextSize = v31.FontSize.FontSize_250,
			Font = v30.Font.Footer.Font,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Center,
			TextTransparency = v30.Theme.TextMuted.Transparency,
			TextColor3 = v30.Theme.TextMuted.Color,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			AnchorPoint = Vector2.new(0, 0.5)
		}, {
			UISizeConstraint = Roact.createElement("UISizeConstraint", {
				MinSize = Vector2.new(0, LoginView.loginContentsPadding)
			})
		}),
		Forgot = if not p1.showForgotButton then nil else Roact.createElement(LinkButton, {
			fontStyle = "CaptionSubHeader",
			colorStyleDefault = "TextDefault",
			colorStyleHover = "TextDefault",
			layoutOrder = 48,
			text = v40.forgotText,
			size = UDim2.new(0, 0, 0, LoginView.forgotLinkHeight),
			onActivated = p1.onForgetButtonActivated
		}),
		DisclaimerPadding = if not v42 then nil else Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 50,
			Size = UDim2.new(1, 0, 0, LoginView.disclaimerPadding)
		}),
		DisclaimerLinks = if not v42 then nil else Roact.createElement(DisclaimerLinks, {
			LayoutOrder = 60,
			isDualLayout = p1.showDisclaimerButtons
		})
	})
end
