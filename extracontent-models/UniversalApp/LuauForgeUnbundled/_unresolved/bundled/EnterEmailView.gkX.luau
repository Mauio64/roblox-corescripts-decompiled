local module = require("@luauforge/bundled/gkC")
local react = module.React
local uiBlox = module.UIBlox

local useStyle = uiBlox.Core.Style.useStyle
local useDesignTokens = module.Style.useDesignTokens
local partialPageModal = uiBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = uiBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local buttonType = uiBlox.App.Button.Enum.ButtonType
local useLocalization = module.Localization.Hooks.useLocalization
local TextField = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Input/TextField")

local module3 = require("@luauforge/bundled/gkZ")
local module4 = require("@luauforge/bundled/gla")

local function getButtonStackProps(continueButton, onActivated, p2, size_1200)
	local v5 = {
		buttonType = buttonType.PrimarySystem,
		props = { onActivated = onActivated, text = continueButton, isDisabled = p2 }
	}
	return {
		buttonHeight = size_1200,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = { v5 }
	}
end

local function EnterEmailView(props)
	local v5 = useStyle()
	local v6 = useDesignTokens()
	local v7 = useLocalization({
		emailPlaceholder = "Authentication.Login.Label.Email",
		continueButton = "Authentication.OneTimePasscode.Action.Continue"
	})

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	local v8 = react.useCallback(function()
		return props.isDisabled or string.len(props.errorMessage) > 0 or string.len(props.email) == 0
	end, { props.isDisabled, props.errorMessage, props.email })

	react.useEffect(function()
		module3.sendPageLoadEvent(module4.ctx.sendOtp, props.origin)
	end, {})

	local createElement = react.createElement
	local v10 = {
		title = props.enterEmailTitle,
		screenSize = props.screenSize,
		buttonStackProps = getButtonStackProps(
			v7.continueButton,
			props.handleContinue,
			v8(),
			v6.Size.Size_1200
		),
		onCloseClicked = props.onClose,
		position = 0,
		anchorPoint = 0
	}
	local v11 = if props.isKeyboardShowing then UDim2.new(0.5, 0, 1, -props.keyboardHeight) or nil else nil
	v10.position = v11
	v10.anchorPoint = props.isKeyboardShowing and Vector2.new(0.5, 1) or nil
	return createElement(partialPageModal, v10, {
		Middle = react.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
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
					Text = props.enterEmailDescription,
					TextSize = v5.Font.BaseSize,
					TextColor3 = v5.Theme.TextDefault.Color,
					TextTransparency = v5.Theme.TextDefault.Transparency,
					Font = v5.Font.Body.Font,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
					LayoutOrder = 1
				}),
				EmailInput = react.createElement(TextField, {
					text = props.email,
					disabled = props.isDisabled,
					onChange = props.onEmailTextChange,
					errorMessage = props.errorMessage,
					placeholder = v7.emailPlaceholder,
					LayoutOrder = 2
				})
			}
		)
	})
end

return EnterEmailView
