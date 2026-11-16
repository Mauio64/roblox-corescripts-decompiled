local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFm")
local module3 = require("@luauforge/bundled/fCs")
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization

local authPageload = module2.Events.authPageload
local authButtonClick = module2.Events.authButtonClick
local authFormInteraction = module2.Events.authFormInteraction
local eventStreamConstants = module2.EventStreamConstants

local module4 = require("@luauforge/bundled/fFF")
local module5 = require("@luauforge/bundled/fFO")
local module6 = require("@luauforge/bundled/fFM")
local module7 = require("@luauforge/bundled/fFt")
local useDesignTokens = require("@luauforge/bundled/fFo").useDesignTokens

local module8 = require("@luauforge/bundled/fFp")
local textInput = module8.TextInput
local text = module8.Text
local button = module8.Button
local buttonVariant = module8.Enums.ButtonVariant
local inputSize = module8.Enums.InputSize
local iconName = module8.Enums.IconName

local module9 = require("@luauforge/bundled/fCx")
local module10 = require("@luauforge/bundled/fFq")
local module11 = require("@luauforge/bundled/fFL")
local module12 = require("@luauforge/bundled/fCy")
local module13 = require("@luauforge/bundled/fFK")
local fFlagLoginV2SubmitOnKeyboardReturn = require("@luauforge/bundled/fFu").FFlagLoginV2SubmitOnKeyboardReturn
local module14 = require("@luauforge/bundled/fFv")

local isStringEmail = module3.Utils.isStringEmail

function LUAUFORGE_MODULE_GLOBALS_fIL_EnterEmailScreen(p2)
	local v5 = module.useContext(module10)
	local v6 = useDesignTokens()
	local v7 = if v5.isDialogLayoutForced then module11(v6) else nil
	local v8

	if module13() then
		v8 = eventStreamConstants.Context.LoginFormV2EnterEmail
	else
		v8 = eventStreamConstants.Context.LoginFormV2EmailOtp
	end

	local v9 = module14 and "dialog" or nil

	local function reportAuthPageload(p3, p4, p5, p6)
		authPageload(p3, p4 or v9, p5, p6 or v5.eventOrigin)
	end

	local function reportAuthButtonClick(p3, p4, p5, p6, p7, p8, p9)
		authButtonClick(p3, p4, p5 or v9, p6, p7, p8 or v5.eventOrigin, p9)
	end

	local utils = v5.utils

	local state, setState = module.useState("")
	local v10, v11 = module6(module.useRef(nil), true)
	local onActivated
	local v12, v13 = module7(function()
		onActivated()
	end, fFlagLoginV2SubmitOnKeyboardReturn, v11)
	local state2, setState2 = module.useState(false)
	local state3, setState3 = module.useState("")
	local v16 = if state3 ~= "" then state3 else nil
	local v17 = useLocalization({
		enterEmailTitleText = "Authentication.SignUp.Label.EnterYourEmail",
		enterEmailDescriptionText = "Authentication.Login.Description.GetOneTimeCodeHelp",
		emailLabelText = "Authentication.Login.Label.EmailAddress",
		emailPlaceholderText = "Authentication.Login.Label.EnterEmail",
		sendCodeActionText = "Authentication.Login.Action.SendCodeSentenceCase",
		errorText = v16
	})

	local v18 = {
		setInProgress = setState2,
		setErrorKey = setState3,
		navigation = p2.navigation,
		isLoginByOtp = true,
		eventContext = v8,
		eventOrigin = v5.eventOrigin
	}

	local function fn(p3)
		v5.dispatch({
			type = module12.SetComponentState,
			data = {
				component = module9.EmailOtpScreen,
				payload = {
					sessionToken = p3,
					sentToEnteredEmail = true,
					enteredEmail = state
				}
			}
		})
	end

	local function onChanged(p3)
		if state3 ~= "" then
			setState3("")
		end

		setState(p3)
	end

	local stringEmail = isStringEmail(state)

	onActivated = function()
		if not stringEmail or state2 then
			return
		end

		setState2(true)
		setState3("")
		authButtonClick(v8, eventStreamConstants.Button.EmailOtp, v9, nil, nil, v5.eventOrigin, nil)
		local function fn2(p3)
			setState2(false)
			fn(p3)
			p2.navigation.navigate(module9.EmailOtpScreen)
		end
		utils.handleSendEmailOtp(fn2, v18, state)
	end

	local function onHeaderBack()
		authButtonClick(v8, eventStreamConstants.Button.Back, v9, nil, nil, v5.eventOrigin, nil)
		setState3("")
		p2.navigation.navigate(module9.AuthenticationScreen)
	end

	local function onHeaderClose()
		authButtonClick(v8, eventStreamConstants.Button.DismissCornerX, v9, nil, nil, v5.eventOrigin, nil)
		v5.parentNavigation.goBack()
	end

	local function onSheetDismiss()
		if module13() then
			authButtonClick(v8, eventStreamConstants.Button.DismissSheet, v9, nil, nil, v5.eventOrigin, nil)
			v5.parentNavigation.goBack()
		else
			authButtonClick(
				v8,
				eventStreamConstants.Button.DismissCornerX,
				v9,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)
			v5.parentNavigation.goBack()
		end
	end

	module.useEffect(function()
		authPageload(v8, v9, nil, v5.eventOrigin)
	end, { v8 })

	local createElement = module.createElement
	local v20 = {
		layoutOrder = 1,
		titleText = v17.enterEmailTitleText,
		titleTopOffset = 0,
		icon = 0,
		onActivated = 0,
		onBack = 0,
		isDisabled = 0
	}
	local v21 = if v7 then v7.titleTopOffset else nil
	v20.titleTopOffset = v21
	v20.icon = iconName.X
	v20.onActivated = onHeaderClose
	v20.onBack = onHeaderBack
	v20.isDisabled = state2
	local element = createElement(module5, v20)

	local createElement2 = module.createElement

	local createElement3 = module.createElement
	local v26 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}

	local v27 = if v7 then module.createElement("UIPadding", {
		PaddingTop = v7.formTopPadding
	}) else nil
	local children = {
		UIPadding = v27,
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v6.Size.Size_600)
		}),
		Content = 0
	}

	local createElement4 = module.createElement
	local v29 = {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		UIListLayout = module.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, v6.Size.Size_50)
		}),
		DescriptionLabel = module.createElement(text, {
			LayoutOrder = 1,
			Text = v17.enterEmailDescriptionText,
			tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
		}),
		InputSpacing = module.createElement("Frame", {
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, v6.Size.Size_400),
			BackgroundTransparency = 1
		}),
		EmailTextField = 0,
		ErrorTextSpacing = 0,
		ErrorTextLabel = 0,
		SubmitButtonSpacing = 0,
		SendCodeButton = 0,
		BottomSpacing = 0
	}

	local createElement5 = module.createElement
	local v31 = {
		LayoutOrder = 3,
		text = state,
		label = v17.emailLabelText,
		placeholder = v17.emailPlaceholderText,
		size = inputSize.Medium,
		width = UDim.new(1, 0),
		onChanged = onChanged,
		onFocusGained = module14 and function()
			authFormInteraction(
				v8,
				eventStreamConstants.Field.Email,
				eventStreamConstants.ActionType.Focus,
				v5.eventOrigin
			)
		end or nil,
		onReturnPressed = 0,
		textBoxRef = 0,
		inputRef = 0,
		isDisabled = 0
	}

	if not fFlagLoginV2SubmitOnKeyboardReturn then
		v13 = onActivated
	end

	v31.onReturnPressed = v13
	v31.textBoxRef = v10

	if fFlagLoginV2SubmitOnKeyboardReturn then
		v11 = v12
	end

	v31.inputRef = v11
	v31.isDisabled = state2
	children2.EmailTextField = createElement5(textInput, v31)

	children2.ErrorTextSpacing = v17.errorText
		and module.createElement("Frame", {
			LayoutOrder = 4,
			Size = UDim2.new(1, 0, 0, v6.Size.Size_100),
			BackgroundTransparency = 1
		})

	children2.ErrorTextLabel = v17.errorText
		and module.createElement(text, {
			LayoutOrder = 5,
			Text = v17.errorText,
			tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-alert"
		})

	children2.SubmitButtonSpacing = module.createElement("Frame", {
		LayoutOrder = 6,
		Size = UDim2.new(1, 0, 0, v6.Size.Size_300),
		BackgroundTransparency = 1
	})

	children2.SendCodeButton = module.createElement(button, {
		LayoutOrder = 7,
		text = v17.sendCodeActionText,
		variant = buttonVariant.Standard,
		size = inputSize.Medium,
		width = UDim.new(1, 0),
		onActivated = onActivated,
		isLoading = state2,
		isDisabled = not stringEmail
	})

	children2.BottomSpacing = module.createElement("Frame", {
		LayoutOrder = 8,
		Size = UDim2.new(1, 0, 0, v6.Size.Size_200),
		BackgroundTransparency = 1
	})
	children.Content = createElement4("Frame", v29, children2)
	return createElement2(module4, {
		header = element,
		onClose = onSheetDismiss,
		eventContext = v8
	}, {
		Wrapper = createElement3("Frame", v26, children)
	})
end

return LUAUFORGE_MODULE_GLOBALS_fIL_EnterEmailScreen
