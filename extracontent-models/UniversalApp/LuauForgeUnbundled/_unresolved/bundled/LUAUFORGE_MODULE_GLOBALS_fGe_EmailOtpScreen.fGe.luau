local UserInputService = game:GetService("UserInputService")

local module = require("@luauforge/bundled/fCE")
local module2 = require("@luauforge/bundled/fFx")
local module3 = require("@luauforge/bundled/fFm")
local module4 = require("@luauforge/bundled/fGf")
local useLocalization = require("@luauforge/bundled/fFn").Hooks.useLocalization

local authPageload = module3.Events.authPageload
local authButtonClick = module3.Events.authButtonClick
local authFormInteraction = module3.Events.authFormInteraction
local eventStreamConstants = module3.EventStreamConstants

local fullscreenPageWithSafeArea = module2.FullscreenPageWithSafeArea
local module5 = require("@luauforge/bundled/fFF")
local module6 = require("@luauforge/bundled/fFs")
local module7 = require("@luauforge/bundled/fFL")
local module8 = require("@luauforge/bundled/fFM")
local module9 = require("@luauforge/bundled/fFO")
local module10 = require("@luauforge/bundled/fFl")
local useDesignTokens = require("@luauforge/bundled/fFo").useDesignTokens
local useStyle = module10.Core.Style.useStyle
local iconButton = module10.App.Button.IconButton
local images = module10.App.ImageSet.Images
local styledTextLabel = module10.App.Text.StyledTextLabel

local module11 = require("@luauforge/bundled/fFp")
local textInput = module11.TextInput
local text = module11.Text
local iconName = module11.Enums.IconName
local inputSize = module11.Enums.InputSize

local module12 = require("@luauforge/bundled/fCx")
local module13 = require("@luauforge/bundled/fFq")
local module14 = require("@luauforge/bundled/fCy")
local module15 = require("@luauforge/bundled/fCm")
local module16 = require("@luauforge/bundled/fFS")
local module17 = require("@luauforge/bundled/fGR")
local module18 = require("@luauforge/bundled/fFQ")
local module19 = require("@luauforge/bundled/fCC")
local module20 = require("@luauforge/bundled/fFU")
local module21 = require("@luauforge/bundled/fFW")
local module22 = require("@luauforge/bundled/fFK")
local module23 = require("@luauforge/bundled/fFv")

local fFlagEnableLoginV2Modalization = require("@luauforge/bundled/fFu").FFlagEnableLoginV2Modalization

local constants = module4.Constants

local function resolveCodeDestinationEmail(p2, p3, p4, p5)
	if p2 ~= "" then
		return p2
	end

	if p3 and p4 and p4.userIdentifierType == module15.Email then
		return p5
	end

	return ""
end

function LUAUFORGE_MODULE_GLOBALS_fGe_EmailOtpScreen(p2)
	local v5 = module.useContext(module13)
	local v6 = useDesignTokens()
	local v7 = if v5.isDialogLayoutForced then module7(v6) else nil
	local v8 = useStyle()

	local v9 = nil

	local function reportAuthPageload(p3, p4, p5, p6)
		authPageload(p3, p4 or v9, p5, p6 or v5.eventOrigin)
	end

	local function reportAuthButtonClick(p3, p4, p5, p6, p7, p8, p9)
		authButtonClick(p3, p4, p5 or v9, p6, p7, p8 or v5.eventOrigin, p9)
	end

	local v10 = if fFlagEnableLoginV2Modalization then module6() else false
	v9 = if module23 then (if v10 then "dialog" else "fullscreen") else nil
	local state = v5.state
	local utils = v5.utils

	local state2, setState = module.useState(false)
	local userIdentifier = state and state.userIdentifier or ""

	local function fn(p3)
		v5.dispatch({
			type = module14.SetComponentState,
			data = { component = module12.EmailOtpScreen, payload = p3 }
		})
	end

	local sessionToken = state and state.componentState[module12.EmailOtpScreen].sessionToken or ""

	local emailOtp = state and state.componentState[module12.EmailOtpScreen].emailOtp or ""

	local state3, setState2 = module.useState(emailOtp)
	local v11, v12 = module8(module.useRef(nil), v10)

	local errorKey = state and state.componentState[module12.EmailOtpScreen].errorKey or ""
	local v13

	if module21 and state then
		v13 = state.componentState[module12.EmailOtpScreen].sentToEnteredEmail or false
	else
		v13 = false
	end

	local v14 = v13 and state and state.componentState[module12.EmailOtpScreen].enteredEmail or ""

	if v14 == "" then
		v14 = (not v10 or not state or state.userIdentifierType ~= module15.Email) and "" or userIdentifier
	end

	local v15 = {
		setInProgress = setState,
		setErrorKey = function(p3)
			fn({ errorKey = p3 })
		end,
		navigation = p2.navigation,
		isLoginByOtp = true,
		eventContext = eventStreamConstants.Context.LoginFormV2EmailOtp,
		eventOrigin = v5.eventOrigin
	}

	local v17 = {
		emailOtpLabelText = "Authentication.Login.Label.EnterOneTimeCodeLoginHelp",
		signInHeadingText = "Authentication.Login.Heading.SignIn",
		enterYourCodeHeadingText = "Authentication.Login.Heading.EnterYourCode",
		verificationCodeSentToText = v14 ~= "" and {
			"Authentication.Login.Description.VerificationCodeSentTo",
			email = "<b>" .. module20(v14) .. "</b>"
		} or nil,
		verificationCodeLabelText = "Authentication.Login.Label.VerificationCode",
		enterCodePlaceholderText = "Authentication.Login.Label.EnterCode",
		errorText = 0
	}

	if errorKey == "" then
		errorKey = nil
	end

	v17.errorText = errorKey
	local v18 = useLocalization(v17)

	local verificationCodeSentToText = v18.verificationCodeSentToText or v18.emailOtpLabelText

	local function onPress()
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2EmailOtp,
			eventStreamConstants.Button.ResendCode,
			v9,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)

		utils.handleResendEmailOtp(sessionToken, function(p3)
			fn({ sessionToken = p3 })
		end, v15)
	end

	module.useEffect(function()
		authPageload(eventStreamConstants.Context.LoginFormV2EmailOtp, v9, nil, v5.eventOrigin)
	end, {})

	module.useEffect(function()
		if #state3 == constants.DEFAULT_CODE_LENGTH then
			setState(true)
			local focusedTextBox = UserInputService:GetFocusedTextBox()

			if focusedTextBox then
				focusedTextBox:ReleaseFocus()
			end

			authButtonClick(
				eventStreamConstants.Context.LoginFormV2EmailOtp,
				eventStreamConstants.Button.OtpSubmit,
				v9,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)
			fn({ emailOtp = state3 })

			utils.handleLoginWithOtp(sessionToken, state3, nil, nil, v15):finally(function()
				fn({ emailOtp = "" })
			end)
		end
	end, { state3 })

	local function onHeaderBack()
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2EmailOtp,
			eventStreamConstants.Button.Back,
			v9,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)
		fn({ errorKey = "" })
		fn({ emailOtp = "" })
		fn({ sessionToken = "" })

		p2.navigation.navigate(module12.AuthenticationScreen)
	end

	local function onHeaderClose()
		authButtonClick(
			eventStreamConstants.Context.LoginFormV2EmailOtp,
			eventStreamConstants.Button.DismissCornerX,
			v9,
			nil,
			nil,
			v5.eventOrigin,
			nil
		)

		v5.parentNavigation.goBack()
	end

	local function onSheetDismiss()
		if module22() then
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2EmailOtp,
				eventStreamConstants.Button.DismissSheet,
				v9,
				nil,
				nil,
				v5.eventOrigin,
				nil
			)

			v5.parentNavigation.goBack()
		else
			authButtonClick(
				eventStreamConstants.Context.LoginFormV2EmailOtp,
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

	local element = module.createElement(iconButton, {
		layoutOrder = 1,
		icon = images["icons/actions/cycleLeft"],
		onActivated = onHeaderBack,
		size = UDim2.new(0, 36, 0, 36),
		isDisabled = state2
	})
	local v19

	if v10 then
		local createElement = module.createElement
		local v21 = {
			layoutOrder = 1,
			titleText = v18.enterYourCodeHeadingText,
			titleTopOffset = 0,
			icon = 0,
			onActivated = 0,
			onBack = 0,
			isDisabled = 0
		}
		local v22 = if v7 then v7.titleTopOffset else nil
		v21.titleTopOffset = v22
		v21.icon = iconName.X
		v21.onActivated = onHeaderClose
		v21.onBack = onHeaderBack
		v21.isDisabled = state2
		v19 = createElement(module9, v21)
	else
		v19 = module.createElement(
			"Frame",
			{
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				BackButton = element,
				SignInHeadingFrame = module.createElement("Frame", {
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundTransparency = 1,
					Position = UDim2.new(0.5, 0, 0.5, 0),
					AutomaticSize = Enum.AutomaticSize.X
				}, {
					SignInHeadingText = module.createElement(styledTextLabel, {
						text = v18.signInHeadingText,
						fontStyle = v8.Font.Header1,
						colorStyle = v8.Theme.TextEmphasis,
						textXAlignment = Enum.TextXAlignment.Center
					})
				})
			}
		)
	end

	local v20 = not v10

	local v22 = if not v10 then module.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v6.Size.Size_200),
		PaddingLeft = UDim.new(0, v6.Size.Size_200),
		PaddingRight = UDim.new(0, v6.Size.Size_200),
		PaddingBottom = UDim.new(0, v6.Size.Size_200)
	}) else nil

	local createElement = module.createElement
	local v24

	if v20 then
		v24 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.XY,
			ScrollBarThickness = 0,
			ScrollingDirection = Enum.ScrollingDirection.Y,
			BorderSizePixel = 0
		}
	else
		v24 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
	end

	local createElement2 = module.createElement
	local v26 = {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = 0,
		HorizontalAlignment = 0
	}
	local v27 = if v10 then UDim.new(0, v6.Size.Size_600) else nil
	v26.Padding = v27
	local v28 = if not v10 then Enum.HorizontalAlignment.Center else nil
	v26.HorizontalAlignment = v28
	local children = {
		UIListLayout = createElement2("UIListLayout", v26),
		Header = if not v10 then v19 else nil,
		ButtonSpacing = 0,
		Content = 0
	}

	local v30 = if not v10 then module.createElement("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, v6.Size.Size_200),
		BackgroundTransparency = 1
	}) else nil
	children.ButtonSpacing = v30

	local createElement3 = module.createElement
	local v32 = {
		LayoutOrder = 3,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children2 = {
		UISizeConstraint = not v10 and module.createElement("UISizeConstraint", {
			MaxSize = Vector2.new(module19.CONTENT_MAX_WIDTH, 1e999)
		}),
		UIPadding = 0,
		UIListLayout = 0,
		Heading = 0,
		OneTimeCodeLabel = 0,
		OneTimeCodeLabelSpacing = 0,
		EmailOtpTextField = 0,
		ErrorTextSpacing = 0,
		ErrorTextLabel = 0,
		ButtonSpacing = 0,
		ResendOtpButton = 0,
		HelpButtonFrame = 0
	}

	local createElement4 = module.createElement
	local v35 = if not v10 then UDim.new(0, v6.Size.Size_200) else nil
	local v36 = if not v10 then UDim.new(0, v6.Size.Size_200) else nil
	local v37

	if v10 then
		if v7 then
			v37 = v7.formTopPadding
		end
	else
		v37 = UDim.new(0, v6.Size.Size_400)
	end

	local v38 = if not v10 then UDim.new(0, v6.Size.Size_800) else nil
	children2.UIPadding = createElement4("UIPadding", {
		PaddingLeft = v35,
		PaddingRight = v36,
		PaddingTop = v37,
		PaddingBottom = v38
	})

	children2.UIListLayout = module.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical,
		Padding = UDim.new(0, v6.Size.Size_50)
	})

	local v39 = if not (v13 or v10) then module.createElement(module16, {
		layoutOrder = 1,
		userIdentifier = userIdentifier
	}) else nil
	children2.Heading = v39

	local v40 = if v10 then module.createElement(text, {
		LayoutOrder = 2,
		Text = verificationCodeSentToText,
		RichText = true,
		tag = "size-full-0 auto-y text-body-large text-wrap text-align-x-left content-default"
	}) else module.createElement(styledTextLabel, {
		layoutOrder = 2,
		text = v18.emailOtpLabelText,
		fontStyle = v8.Font.Body,
		colorStyle = v8.Theme.TextEmphasis
	})
	children2.OneTimeCodeLabel = v40

	local v41 = if v10 then module.createElement("Frame", {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, v6.Size.Size_400),
		BackgroundTransparency = 1
	}) else nil
	children2.OneTimeCodeLabelSpacing = v41

	local createElement5 = module.createElement
	local v43 = {
		LayoutOrder = 4,
		text = emailOtp,
		label = not v10 and "" or v18.verificationCodeLabelText,
		placeholder = 0,
		size = 0,
		width = 0,
		onChanged = 0,
		onFocusGained = 0,
		textBoxRef = 0,
		inputRef = 0,
		isDisabled = 0,
		textInputType = 0
	}
	local v44 = if v10 then v18.enterCodePlaceholderText else nil
	v43.placeholder = v44
	local v45 = if v10 then inputSize.Medium else nil
	v43.size = v45
	v43.width = UDim.new(1, 0)
	function v43.onChanged(p3)
		setState2(p3)
	end
	v43.onFocusGained = module23 and function()
		authFormInteraction(
			eventStreamConstants.Context.LoginFormV2EmailOtp,
			eventStreamConstants.Field.VerificationCode,
			eventStreamConstants.ActionType.Focus,
			v5.eventOrigin
		)
	end or nil

	v43.textBoxRef = v11
	v43.inputRef = v12
	v43.isDisabled = state2
	v43.textInputType = Enum.TextInputType.OneTimePassword
	children2.EmailOtpTextField = createElement5(textInput, v43)

	children2.ErrorTextSpacing = v18.errorText
		and module.createElement("Frame", {
			LayoutOrder = 5,
			Size = UDim2.new(1, 0, 0, v6.Size.Size_100),
			BackgroundTransparency = 1
		})

	local v46 = v18.errorText

	if v46 then
		if v10 then
			v46 = module.createElement(text, {
				LayoutOrder = 6,
				Text = v18.errorText,
				tag = "size-full-0 auto-y text-body-small text-wrap text-align-x-left content-alert"
			})
		else
			v46 = module.createElement(styledTextLabel, {
				layoutOrder = 6,
				text = v18.errorText,
				fontStyle = v8.Font.BodySmall,
				colorStyle = v8.Theme.Alert,
				automaticSize = Enum.AutomaticSize.XY,
				textWrapped = true
			})
		end
	end

	children2.ErrorTextLabel = v46

	local createElement6 = module.createElement

	local newUDim2 = UDim2.new

	local v52 = if v10 then v6.Size.Size_300 else v6.Size.Size_400
	children2.ButtonSpacing = createElement6("Frame", {
		LayoutOrder = 7,
		Size = newUDim2(1, 0, 0, v52),
		BackgroundTransparency = 1
	})

	children2.ResendOtpButton = module.createElement(module17, {
		layoutOrder = 8,
		onPress = onPress,
		isLoading = state2
	})

	children2.HelpButtonFrame = module.createElement(
		"Frame",
		{
			LayoutOrder = 9,
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		},
		{
			ListLayout = module.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center
			}),
			HelpButton = module.createElement(module18, {
				layoutOrder = 1,
				isDisabled = state2,
				originPage = eventStreamConstants.Context.LoginFormV2Auth,
				textKey = v10 and "Authentication.Login.Label.TroubleSigningIn" or "Authentication.Login.Action.NeedHelp",
				identifierAutofill = userIdentifier
			})
		}
	)
	children.Content = createElement3("Frame", v32, children2)
	local v21 = {
		UIPadding = v22,
		Wrapper = createElement(v20 and "ScrollingFrame" or "Frame", v24, children)
	}

	if not fFlagEnableLoginV2Modalization then
		return module.createElement(
			fullscreenPageWithSafeArea,
			{
				includeStatusBar = true,
				BackgroundColor3 = v8.Theme.BackgroundDefault.Color
			},
			v21
		)
	end

	local createElement7 = module.createElement

	if not v10 then
		v19 = nil
	end

	return createElement7(
		module5,
		{
			header = v19,
			onClose = onSheetDismiss,
			eventContext = eventStreamConstants.Context.LoginFormV2EmailOtp
		},
		v21
	)
end

return LUAUFORGE_MODULE_GLOBALS_fGe_EmailOtpScreen
