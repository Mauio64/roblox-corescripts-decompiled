local module = require("@luauforge/bundled/ggX")
local module2 = require("@luauforge/bundled/gjF")
local module3 = require("@luauforge/bundled/gjG")
local useLocalization = require("@luauforge/bundled/gjH").Hooks.useLocalization
local useDesignTokens = require("@luauforge/bundled/gjI").useDesignTokens

local useStyle = module2.Core.Style.useStyle
local styledTextLabel = module2.App.Text.StyledTextLabel
local button = module2.App.Button.Button
local buttonType = module2.App.Button.Enum.ButtonType
local images = module2.App.ImageSet.Images
local standardButtonSize = module2.App.Button.Enum.StandardButtonSize

local module4 = require("@luauforge/bundled/gjJ")

local textInput = module4.TextInput
local text = module4.Text
local button2 = module4.Button
local buttonVariant = module4.Enums.ButtonVariant
local inputSize = module4.Enums.InputSize
local iconName = module4.Enums.IconName

local module5 = require("@luauforge/bundled/ggR")
local module6 = require("@luauforge/bundled/gjK")
local module7 = require("@luauforge/bundled/ggQ")
local module8 = require("@luauforge/bundled/ggP")
local module9 = require("@luauforge/bundled/ggV")
local module10 = require("@luauforge/bundled/gjM")
local module11 = require("@luauforge/bundled/gjN")
local module12 = require("@luauforge/bundled/gjO")
local fFlagEnableLoginV2Modalization = module12.FFlagEnableLoginV2Modalization
local fFlagLoginV2SubmitOnKeyboardReturn = module12.FFlagLoginV2SubmitOnKeyboardReturn
local module13 = require("@luauforge/bundled/gjP")

local authFormInteraction = module3.Events.authFormInteraction
local authButtonClick = module3.Events.authButtonClick
local eventStreamConstants = module3.EventStreamConstants

local uiConstants = require("@luauforge/bundled/ggL").Common.UIConstants

function LUAUFORGE_MODULE_GLOBALS_gjE_AuthenticationMethod(props)
	local v5 = module.useContext(module6)
	local v6 = useStyle()
	local v7 = useDesignTokens()

	local function reportAuthFormInteraction(p2, p3, p4, p5, p6)
		authFormInteraction(p2, p3, p4, p5 or v5.eventOrigin, p6)
	end

	local v8 = if fFlagEnableLoginV2Modalization then module10() else false

	local state = v5.state

	local function fn(p2)
		v5.dispatch({
			type = module5.SetComponentState,
			data = { component = module7.AuthenticationScreen, payload = p2 }
		})
	end

	local password = state and state.componentState[module7.AuthenticationScreen].password or ""

	local state2, setState = module.useState(false)

	local errorKey = state and state.componentState[module7.AuthenticationScreen].errorKey or ""

	local errorType = state and state.componentState[module7.AuthenticationScreen].errorType or ""

	local v11 = if errorKey ~= "" and errorType == module8.Password and not not errorKey then errorKey else nil
	local v12 = useLocalization({
		passwordLabelText = "Authentication.Login.Label.Password",
		enterPasswordPlaceholderText = "Authentication.Login.Label.EnterPassword",
		nextActionText = "Authentication.Login.Action.Next",
		signInActionText = "Authentication.Login.Action.SignInSentenceCase",
		usePasskeyActionText = "Authentication.Login.Action.UsePasskey",
		emailOneTimeCodeActionText = v8 and "Authentication.Login.Action.EmailMeCode" or "Authentication.Login.Action.EmailACode",
		passwordErrorText = v11
	})

	local function onActivated()
		if password == "" or props.isLoginInProgress then
			return
		end

		props.onSubmit(password)
	end

	local v13, v14 = module11(function()
		if password ~= "" then
			if props.isLoginInProgress then
				return
			end

			props.onSubmit(password)
		end
	end, fFlagLoginV2SubmitOnKeyboardReturn and v8, props.inputRef)
	local v15

	if v8 and props.authMethod == module8.Password then
		v15 = 0
	else
		v15 = if v8 then props.dialogBottomPadding or v7.Size.Size_300 else v7.Size.Size_200
	end

	if props.authMethod == module8.Password then
		local createElement = module.createElement
		local v17 = {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local children = {
			UIPadding = module.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v15)
			}),
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v8 and 0 or v7.Size.Size_50)
			}),
			PasswordLabel = 0,
			PasswordField = 0,
			ErrorTextSpacing = 0,
			ErrorTextLabel = 0,
			SubmitButtonSpacing = 0,
			SubmitButton = 0
		}

		local v18 = if not v8 then module.createElement(styledTextLabel, {
			layoutOrder = 1,
			text = v12.passwordLabelText,
			fontStyle = v6.Font.Body,
			colorStyle = v6.Theme.TextEmphasis,
			richText = true
		}) else nil
		children.PasswordLabel = v18

		local createElement2 = module.createElement
		local v20 = {
			LayoutOrder = 2,
			text = "",
			label = not v8 and "" or v12.passwordLabelText,
			placeholder = 0,
			size = 0,
			textInputType = 0,
			width = 0,
			onChanged = 0,
			onFocusGained = 0,
			iconTrailing = 0,
			onReturnPressed = 0,
			isDisabled = 0,
			textBoxRef = 0,
			inputRef = 0
		}
		local v21 = if v8 then v12.enterPasswordPlaceholderText else nil
		v20.placeholder = v21
		local v22 = if v8 then inputSize.Medium else nil
		v20.size = v22

		local v23 = if state2 then Enum.TextInputType.PasswordShown else Enum.TextInputType.Password
		v20.textInputType = v23

		v20.width = UDim.new(1, 0)
		function v20.onChanged(p2)
			if errorKey ~= "" and errorType == module8.Password then
				fn({ errorKey = "" })
			end

			fn({ password = p2 })
		end
		function v20.onFocusGained()
			local loginFormV2Auth = eventStreamConstants.Context.LoginFormV2Auth
			local password2 = eventStreamConstants.Field.Password
			local v24 = if module13 then eventStreamConstants.ActionType.Focus else nil
			authFormInteraction(loginFormV2Auth, password2, v24, v5.eventOrigin, nil)
		end

		local v25 = if state2 then uiConstants.SHOW_PASSWORD_ICON else uiConstants.HIDE_PASSWORD_ICON
		v20.iconTrailing = {
			name = v25,
			onActivated = function()
				if module13 then
					local loginFormV2Auth = eventStreamConstants.Context.LoginFormV2Auth

					local v27 = if state2 then eventStreamConstants.Button.HidePassword else eventStreamConstants.Button.ShowPassword
					authButtonClick(
						loginFormV2Auth,
						v27,
						state2 and "hide" or "show",
						nil,
						nil,
						v5.eventOrigin
					)
				end

				setState(not state2)
			end
		}

		if not fFlagLoginV2SubmitOnKeyboardReturn then
			v14 = if v8 then onActivated else nil
		end

		v20.onReturnPressed = v14

		v20.isDisabled = props.isLoginInProgress
		v20.textBoxRef = props.textBoxRef

		if not fFlagLoginV2SubmitOnKeyboardReturn then
			v13 = props.inputRef
		end

		v20.inputRef = v13
		children.PasswordField = createElement2(textInput, v20)

		children.ErrorTextSpacing = v12.passwordErrorText
			and module.createElement("Frame", {
				LayoutOrder = 3,
				Size = UDim2.new(1, 0, 0, v7.Size.Size_100),
				BackgroundTransparency = 1
			})

		local v26 = v12.passwordErrorText

		if v26 then
			if v8 then
				v26 = module.createElement(text, {
					LayoutOrder = 4,
					Text = v12.passwordErrorText,
					tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-alert"
				})
			else
				v26 = module.createElement(styledTextLabel, {
					layoutOrder = 4,
					text = v12.passwordErrorText,
					fontStyle = v6.Font.BodySmall,
					colorStyle = v6.Theme.Alert,
					automaticSize = Enum.AutomaticSize.XY,
					textWrapped = true
				})
			end
		end

		children.ErrorTextLabel = v26

		children.SubmitButtonSpacing = module.createElement("Frame", {
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, v7.Size.Size_400),
			BackgroundTransparency = 1
		})
		local v27

		if v8 then
			v27 = module.createElement(button2, {
				LayoutOrder = 6,
				text = v12.signInActionText,
				variant = buttonVariant.Emphasis,
				size = inputSize.Medium,
				width = UDim.new(1, 0),
				onActivated = onActivated,
				isLoading = props.isLoginInProgress,
				isDisabled = password == ""
			})
		else
			v27 = module.createElement(button, {
				layoutOrder = 6,
				text = v12.nextActionText,
				buttonTextOverride = module9.getButtonTextOverrideConfig(),
				onActivated = function()
					props.onSubmit(password)
				end,
				standardSize = standardButtonSize.Regular,
				buttonType = buttonType.PrimaryContextual,
				isLoading = props.isLoginInProgress,
				isDisabled = password == ""
			})
		end

		children.SubmitButton = v27
		return createElement("Frame", v17, children)
	elseif props.authMethod == module8.Passkey then
		local createElement = module.createElement
		local v17 = {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v18 = {
			UIPadding = module.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v15)
			}),
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v7.Size.Size_50)
			}),
			PasskeyButton = 0
		}
		local v19

		if v8 then
			local createElement2 = module.createElement
			local v21 = {
				LayoutOrder = 1,
				text = v12.usePasskeyActionText,
				variant = 0,
				size = 0,
				width = 0,
				onActivated = 0,
				isLoading = 0,
				icon = 0
			}
			local v22 = if props.isFirstItemInList then buttonVariant.Emphasis else buttonVariant.Standard
			v21.variant = v22
			v21.size = inputSize.Medium
			v21.width = UDim.new(1, 0)
			function v21.onActivated()
				props.onSubmit(nil)
			end
			v21.isLoading = props.isLoginInProgress
			v21.icon = iconName.Key
			v19 = createElement2(button2, v21)
		else
			local createElement2 = module.createElement
			local v21 = {
				layoutOrder = 1,
				text = v12.usePasskeyActionText,
				buttonTextOverride = module9.getButtonTextOverrideConfig(),
				onActivated = function()
					props.onSubmit(nil)
				end,
				standardSize = standardButtonSize.Regular,
				buttonType = 0,
				isLoading = 0,
				icon = 0
			}
			local v22 = if props.isFirstItemInList then buttonType.PrimaryContextual else buttonType.Secondary
			v21.buttonType = v22
			v21.isLoading = props.isLoginInProgress
			v21.icon = images["icons/menu/passkey"]
			v19 = createElement2(button, v21)
		end

		v18.PasskeyButton = v19
		return createElement("Frame", v17, v18)
	else
		if props.authMethod ~= module8.EmailOtp then
			error("Invalid auth method")

			return module.createElement("Frame", {
				LayoutOrder = props.layoutOrder,
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y
			})
		end

		local createElement = module.createElement
		local v17 = {
			LayoutOrder = props.layoutOrder,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v18 = {
			UIPadding = module.createElement("UIPadding", {
				PaddingBottom = UDim.new(0, v15)
			}),
			UIListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v7.Size.Size_50)
			}),
			EmailOtpButton = 0
		}
		local v19

		if v8 then
			local createElement2 = module.createElement
			local v21 = {
				LayoutOrder = 1,
				text = v12.emailOneTimeCodeActionText,
				variant = 0,
				size = 0,
				width = 0,
				onActivated = 0,
				isLoading = 0,
				icon = 0
			}
			local v22 = if props.isFirstItemInList then buttonVariant.Emphasis else buttonVariant.Standard
			v21.variant = v22
			v21.size = inputSize.Medium
			v21.width = UDim.new(1, 0)
			function v21.onActivated()
				props.onSubmit(nil)
			end
			v21.isLoading = props.isLoginInProgress
			v21.icon = iconName.Envelope
			v19 = createElement2(button2, v21)
		else
			local createElement2 = module.createElement
			local v21 = {
				layoutOrder = 1,
				text = v12.emailOneTimeCodeActionText,
				buttonTextOverride = module9.getButtonTextOverrideConfig(),
				onActivated = function()
					props.onSubmit(nil)
				end,
				standardSize = standardButtonSize.Regular,
				buttonType = 0,
				isLoading = 0,
				icon = 0
			}
			local v22 = if props.isFirstItemInList then buttonType.PrimaryContextual else buttonType.Secondary
			v21.buttonType = v22
			v21.isLoading = props.isLoginInProgress
			v21.icon = images["icons/menu/email"]
			v19 = createElement2(button, v21)
		end

		v18.EmailOtpButton = v19
		return createElement("Frame", v17, v18)
	end
end

return LUAUFORGE_MODULE_GLOBALS_gjE_AuthenticationMethod
