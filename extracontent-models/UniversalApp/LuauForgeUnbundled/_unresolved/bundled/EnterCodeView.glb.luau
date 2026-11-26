local module = require("@luauforge/bundled/gkC")
local react = module.React
local uiBlox = module.UIBlox
local foundation = module.Foundation

local checkbox = foundation.Checkbox
local normalizeFontFace = foundation.Utility.normalizeFontFace

local useStyle = uiBlox.Core.Style.useStyle
local buttonType = uiBlox.App.Button.Enum.ButtonType
local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = uiBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local linkButton = uiBlox.App.Button.LinkButton

local module2 = require("@luauforge/bundled/gkW")

local useLocalization = module.Localization.Hooks.useLocalization
local useDesignTokens = module.Style.useDesignTokens
local useState = react.useState

local module3 = require("@luauforge/bundled/gkZ")
local module4 = require("@luauforge/bundled/gla")

local module5 = require("@luauforge/bundled/gkU")

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
		return react.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
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
				FooterText = react.createElement("TextLabel", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Text = v7.footerDescriptionKey,
					TextSize = v6.FontSize.FontSize_400,
					TextColor3 = v5.Theme.TextDefault.Color,
					TextTransparency = v5.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v6.Typography.BodyLarge.Font),
					LayoutOrder = 4
				}),
				LinkFrame = react.createElement(
					"Frame",
					{
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.Y,
						LayoutOrder = 5
					},
					{
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
						Hyphen = react.createElement("TextLabel", {
							BackgroundTransparency = 1,
							Text = "-",
							TextSize = v6.FontSize.FontSize_400,
							TextColor3 = v5.Theme.TextDefault.Color,
							TextTransparency = v5.Theme.TextDefault.Transparency,
							FontFace = normalizeFontFace(v6.Typography.CaptionSmall.Font),
							LayoutOrder = 7
						}),
						HelpButton = react.createElement(linkButton, {
							text = v7.helpButtonKey,
							onActivated = props.navigateToHelp,
							layoutOrder = 8,
							position = UDim2.fromScale(0.75, 0)
						})
					}
				)
			}
		)
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
	local v16 = {
		ContentPadding = react.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v6.Size.Size_600),
			PaddingBottom = UDim.new(0, v6.Size.Size_600)
		}),
		ListLayout = react.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, v6.Size.Size_300)
		}),
		BodyText = react.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = v8(props.enterCodeDescription),
			TextSize = v5.Font.BaseSize,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			FontFace = normalizeFontFace(v6.Typography.BodyLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
			LayoutOrder = 1
		}),
		ComplianceCheckboxContainer = 0,
		CodeInput = 0
	}
	local v17 = defineFastFlag
		and props.complianceCheckboxMessageKey
		and props.complianceCheckboxMessageKey ~= ""

	if v17 then
		v17 = react.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
				LayoutOrder = 4
			},
			{
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
				CheckboxBodyText = react.createElement("TextButton", {
					BackgroundTransparency = 1,
					Text = v7.complianceCheckboxMessageKey,
					TextSize = v5.Font.BaseSize,
					TextColor3 = v5.Theme.TextDefault.Color,
					TextTransparency = v5.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v6.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth * 0.9, 0, 0),
					LayoutOrder = 3,
					[react.Event.Activated] = function()
						setState4(not state4)
					end
				})
			}
		)
	end

	v16.ComplianceCheckboxContainer = v17

	v16.CodeInput = react.createElement(TextField, {
		text = state3,
		textInputType = Enum.TextInputType.Number,
		disabled = props.isDisabled,
		onChange = v9,
		errorMessage = props.errorMessage,
		placeholder = v7.placeholderKey,
		LayoutOrder = 3
	})
	return createElement(partialPageModal, v11, {
		Middle = createElement2("Frame", v15, v16)
	})
end

return EnterCodeView
