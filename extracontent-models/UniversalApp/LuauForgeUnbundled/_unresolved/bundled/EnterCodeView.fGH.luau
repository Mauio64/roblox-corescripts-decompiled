local module = require("@luauforge/bundled/fGi")
local react = module.React
local uiBlox = module.UIBlox
local foundation = module.Foundation

local checkbox = foundation.Checkbox
local normalizeFontFace = foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = foundation.Utility.Flags.FoundationFontFaceMigration

local useStyle = uiBlox.Core.Style.useStyle
local buttonType = uiBlox.App.Button.Enum.ButtonType
local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = uiBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local linkButton = uiBlox.App.Button.LinkButton

local module2 = require("@luauforge/bundled/fGC")

local useLocalization = module.Localization.Hooks.useLocalization
local useDesignTokens = module.Style.useDesignTokens
local useState = react.useState

local module3 = require("@luauforge/bundled/fGF")
local module4 = require("@luauforge/bundled/fGG")

local module5 = require("@luauforge/bundled/fGA")

local TextField = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Input/TextField")

local defineFastFlag = game:DefineFastFlag("EnableKoreaKISAComplianceModularized", false)

local function EnterCodeView(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)
	local state, setState = react.useState(true)
	local state2, setState2 = react.useState(module5.DEFAULT_TIMER_COOLDOWN)
	local v7 = useLocalization({
		placeholderKey = "Authentication.OneTimePasscode.Label.SixDigitCode",
		buttonKey = "Authentication.OneTimePasscode.Action.Resend",
		buttonDisabledKey = "Authentication.OneTimePasscode.Label.CodeSent",
		footerDescriptionKey = "Authentication.OneTimePasscode.Description.DidntReceiveCode",
		changeEmailKey = "Authentication.OneTimePasscode.Action.ChangeEmailV2",
		helpButtonKey = "Authentication.OneTimePasscode.Action.GetHelp",
		complianceCheckboxMessageKey = props.complianceCheckboxMessageKey
	})

	local state3, setState3 = useState("")
	local state4, setState4 = useState(false)

	local function handleComplianceBoxClick(p2)
		setState4(p2)
	end

	local function countDown(now, p2)
		local v8 = p2 - (tick() - now)

		if v8 > 0 then
			setState2((math.round(v8)))
			task.delay(1, function()
				countDown(now, p2)
			end)
		else
			setState2(0)
			setState(false)
		end
	end

	local function getButtonStackProps(buttonKey, buttonDisabledKey, DEFAULT_TIMER_COOLDOWN, onResendCode)
		local function handleButtonClick()
			onResendCode()
			setState(true)
			setState2(DEFAULT_TIMER_COOLDOWN)
			countDown(tick(), DEFAULT_TIMER_COOLDOWN)
		end

		local function getButtonText()
			if state then
				return buttonDisabledKey .. " (" .. state2 .. ")"
			end

			return buttonKey
		end

		local v9 = { buttonType = buttonType.Secondary, props = 0 }
		local v11 = if state then buttonDisabledKey .. " (" .. state2 .. ")" else buttonKey

		v9.props = {
			onActivated = handleButtonClick,
			text = v11,
			isDisabled = state or props.isDisabled
		}
		return {
			buttonHeight = v6.Size.Size_1200,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = { v9 }
		}
	end

	local v8 = react.useCallback(function(value)
		return value:gsub("{email}", props.email)
	end, { props.email })

	local v9 = react.useCallback(module2(function(p2)
		module3.sendFormInteractionEvent(module4.ctx.enterOtp, props.origin, module4.field.code)

		if p2.Text then
			p2.Text = string.sub(p2.Text:gsub("%D", ""), 1, module5.DEFAULT_CODE_LENGTH)
			setState3(p2.Text)
			props.clearErrorMessage()
		end
	end, 0.5), { setState3 })

	local function footer()
		local createElement = react.createElement
		local v11 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local children = {
			Padding = react.createElement("UIPadding", {
				PaddingTop = UDim.new(0, v6.Size.Size_400)
			}),
			ListLayout = react.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, v6.Size.Size_200)
			}),
			FooterText = 0,
			LinkFrame = 0
		}

		local createElement2 = react.createElement
		local v13 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = v7.footerDescriptionKey,
			TextSize = v6.FontSize.FontSize_400,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			LayoutOrder = 4
		}
		local v14 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
		v13.Font = v14

		local v15 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else nil
		v13.FontFace = v15
		children.FooterText = createElement2("TextLabel", v13)

		local createElement3 = react.createElement
		local v17 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 5
		}

		local children2 = {
			LinkListLayout = react.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal
			}),
			ChangeEmailButton = react.createElement(linkButton, {
				text = v7.changeEmailKey,
				onActivated = props.returnToEnterEmail,
				layoutOrder = 6,
				position = UDim2.fromScale(0.25, 0)
			}),
			Hyphen = 0,
			HelpButton = 0
		}

		local createElement4 = react.createElement
		local v19 = {
			BackgroundTransparency = 1,
			Text = "-",
			TextSize = v6.FontSize.FontSize_400,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			Font = 0,
			FontFace = 0,
			LayoutOrder = 7
		}
		local v20 = if not foundationFontFaceMigration then v5.Font.Footer.Font else nil
		v19.Font = v20

		local v21 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.CaptionSmall.Font) else nil
		v19.FontFace = v21
		children2.Hyphen = createElement4("TextLabel", v19)

		children2.HelpButton = react.createElement(linkButton, {
			text = v7.helpButtonKey,
			onActivated = props.navigateToHelp,
			layoutOrder = 8,
			position = UDim2.fromScale(0.75, 0)
		})
		children.LinkFrame = createElement3("Frame", v17, children2)
		return createElement("Frame", v11, children)
	end

	local function shouldShowComplianceCheckbox()
		return defineFastFlag
			and props.complianceCheckboxMessageKey
			and props.complianceCheckboxMessageKey ~= ""
	end

	react.useEffect(function()
		countDown(tick(), module5.DEFAULT_TIMER_COOLDOWN)
		module3.sendPageLoadEvent(module4.ctx.enterOtp, props.origin)
	end, {})

	react.useEffect(function()
		if string.len(state3) == module5.DEFAULT_CODE_LENGTH then
			if props.complianceCheckboxMessageKey then
				if state4 then
					props.onSubmitCode(state3)
				end
			else
				props.onSubmitCode(state3)
			end
		end
	end, { state3, (tostring(state4)) })

	local createElement = react.createElement
	local v11 = {
		title = props.enterCodeTitle,
		screenSize = props.screenSize,
		buttonStackProps = getButtonStackProps(
			v7.buttonKey,
			v7.buttonDisabledKey,
			module5.DEFAULT_TIMER_COOLDOWN,
			props.onResendCode
		),
		footerContent = footer,
		onCloseClicked = props.onClose,
		position = 0,
		anchorPoint = 0
	}
	local v12 = if props.isKeyboardShowing then UDim2.new(0.5, 0, 1, -props.keyboardHeight) or nil else nil
	v11.position = v12
	v11.anchorPoint = props.isKeyboardShowing and Vector2.new(0.5, 1) or nil

	local createElement2 = react.createElement
	local v15 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children = {
		ContentPadding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v6.Size.Size_600),
			PaddingBottom = UDim.new(0, v6.Size.Size_600)
		}),
		ListLayout = react.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v6.Size.Size_300)
		}),
		BodyText = 0,
		ComplianceCheckboxContainer = 0,
		CodeInput = 0
	}

	local createElement3 = react.createElement
	local v17 = {
		BackgroundTransparency = 1,
		Text = v8(props.enterCodeDescription),
		TextSize = v5.Font.BaseSize,
		TextColor3 = v5.Theme.TextDefault.Color,
		TextTransparency = v5.Theme.TextDefault.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		Size = 0,
		LayoutOrder = 1
	}
	local v18 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
	v17.Font = v18

	local v19 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else nil
	v17.FontFace = v19

	v17.TextXAlignment = Enum.TextXAlignment.Left
	v17.AutomaticSize = Enum.AutomaticSize.Y

	v17.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
	children.BodyText = createElement3("TextLabel", v17)
	local v20 = defineFastFlag
		and props.complianceCheckboxMessageKey
		and props.complianceCheckboxMessageKey ~= ""

	if v20 then
		local createElement4 = react.createElement
		local v22 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
			LayoutOrder = 4
		}

		local v23 = {
			Layout = react.createElement("UIListLayout", {
				Padding = UDim.new(0, 8),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Checkbox = react.createElement(checkbox, {
				label = "",
				isChecked = state4,
				onActivated = function()
					setState4(not state4)
				end,
				LayoutOrder = 2
			}),
			CheckboxBodyText = 0
		}

		local createElement5 = react.createElement
		local v25 = {}
		v25.BackgroundTransparency = 1
		v25.Text = v7.complianceCheckboxMessageKey
		v25.TextSize = v5.Font.BaseSize
		v25.TextColor3 = v5.Theme.TextDefault.Color
		v25.TextTransparency = v5.Theme.TextDefault.Transparency
		local v26 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
		v25.Font = v26

		local v27 = if foundationFontFaceMigration then normalizeFontFace(v6.Typography.BodyLarge.Font) else nil
		v25.FontFace = v27

		v25.TextXAlignment = Enum.TextXAlignment.Left
		v25.AutomaticSize = Enum.AutomaticSize.Y
		v25.TextWrapped = true
		v25.Size = UDim2.new(0, partialPageModalMiddleContentWidth * 0.9, 0, 0)
		v25.LayoutOrder = 3
		v25[react.Event.Activated] = function()
			setState4(not state4)
		end

		v23.CheckboxBodyText = createElement5("TextButton", v25)
		v20 = createElement4("Frame", v22, v23)
	end

	children.ComplianceCheckboxContainer = v20

	children.CodeInput = react.createElement(TextField, {
		text = state3,
		textInputType = Enum.TextInputType.Number,
		disabled = props.isDisabled,
		onChange = v9,
		errorMessage = props.errorMessage,
		placeholder = v7.placeholderKey,
		LayoutOrder = 3
	})
	return createElement(partialPageModal, v11, {
		Middle = createElement2("Frame", v15, children)
	})
end

return EnterCodeView
