local parent = script:FindFirstAncestor("PhoneUpsell").Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local TextField = UIBlox.App.Input.TextField
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local SharedFlags = require(parent.SharedFlags)
local GetFFlagAddMorePhoneUpsellEvents = SharedFlags.GetFFlagAddMorePhoneUpsellEvents

local function getButtonStackProps(text: string, onActivated, isDisabled: boolean, editPhoneDescriptionKey: string?, onActivated2)
	local buttons = {
		{
			buttonType = ButtonType.Secondary,
			props = { onActivated = onActivated, text = text, isDisabled = isDisabled }
		}
	}

	if onActivated2 and editPhoneDescriptionKey and editPhoneDescriptionKey ~= "" then
		table.insert(buttons, 1, {
			buttonType = ButtonType.Secondary,
			props = {
				onActivated = onActivated2,
				text = editPhoneDescriptionKey,
				isDisabled = false
			}
		})
	end

	return {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Horizontal,
		buttons = buttons
	}
end

local function InGameVerifyPhoneView(props)
	local v = useStyle()
	local tokens = v.Tokens
	local v2 = {
		titleKey = "Feature.VerificationUpsell.Heading.VerifyYourPhone",
		verificationCodeKey = "Feature.VerificationUpsell.Heading.VerificationCode",
		placeholderKey = "Feature.VerificationUpsell.Label.SixDigitCode",
		descriptionKey = "Feature.VerificationUpsell.Label.EnterCode",
		buttonKey = "Feature.VerificationUpsell.Action.ResendCode",
		buttonDisabledKey = "Feature.VerificationUpsell.Action.CodeResent",
		changePhoneNumberKey = "Feature.VerificationUpsell.Action.ChangePhoneNumber",
		editPhoneDescriptionKey = "Feature.VerificationUpsell.Action.EditPhoneNumber"
	}

	if props.extraButtonKey and props.extraButtonKey ~= "" then
		v2.extraButtonKey = props.extraButtonKey
	end

	local v3 = useLocalization(v2)
	local state, setState = React.useState(0)
	local isDisabled = state ~= 0

	local function getBodyText(descriptionKey: string) -- 1 equivalent call inferred from this helper
		return descriptionKey:gsub("{phoneNumber}", "+" .. props.prefix .. props.phoneNumber)
	end

	local function handleResendButtonClick()
		props.onResendPhoneCode()
		setState(10)
		local lastTime = tick()
		local function countDown()
			local v4 = 10 - (tick() - lastTime)

			if v4 > 0 then
				setState((math.ceil(v4)))
				task.delay(1, countDown)
			else
				setState(0)
			end
		end

		local v4 = 10 - (tick() - lastTime)

		if v4 > 0 then
			setState((math.ceil(v4)))
			task.delay(1, countDown)
		else
			setState(0)
		end
	end

	local v4

	if isDisabled then
		v4 = v3.buttonDisabledKey .. " (" .. state .. ")"
	else
		v4 = v3.buttonKey
	end

	local err = props.errorMessage and props.errorMessage ~= ""

	local createElement = React.createElement
	local v5 = {
		title = v3.titleKey,
		screenSize = props.screenSize,
		buttonStackInfo = getButtonStackProps(
			v4,
			handleResendButtonClick,
			isDisabled,
			v3.editPhoneDescriptionKey,
			props.onExtraButtonClick
		),
		onCloseClicked = props.onClose,
		position = 0,
		anchorPoint = 0,
		middleContent = 0
	}
	local position

	if props.isKeyboardShowing then
		position = UDim2.new(0.5, 0, 1, -props.keyboardHeight) or nil
	end

	v5.position = position
	v5.anchorPoint = props.isKeyboardShowing and Vector2.new(0.5, 1) or nil
	function v5.middleContent()
		local createElement2 = React.createElement
		local v6 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v7 = {
			[1] = nil,
			nil,
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, tokens.Size.Size_200)
			})
		}

		local createElement3 = React.createElement
		local v8 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 0
		}

		local v9 = {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, tokens.Size.Size_200)
			}),
			TextBox = 0,
			ErrorText = 0
		}

		local createElement4 = React.createElement
		local v10 = {
			text = props.code,
			placeholder = "",
			required = true,
			onChange = function(text)
				props.onCodeTextChange({ Text = text })
			end,
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			error = err,
			textInputType = 0,
			onFocusGained = 0
		}
		local textInputType

		if props.useOTPInputType then
			textInputType = Enum.TextInputType.OneTimePassword
		else
			textInputType = Enum.TextInputType.Number
		end

		v10.textInputType = textInputType
		local onFocusGained

		if GetFFlagAddMorePhoneUpsellEvents() then
			onFocusGained = props.onCodeInputFocus
		end

		v10.onFocusGained = onFocusGained
		v9.TextBox = createElement4(TextField, v10)

		v9.ErrorText = err and React.createElement("TextLabel", {
			Text = props.errorMessage,
			TextTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = tokens.Color.System.Alert.Color3,
			FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
			TextSize = v.Font.BaseSize * v.Font.CaptionSmall.RelativeSize,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2
		})
		v7[1] = (createElement3("Frame", v8, v9))
		v7.BodyText = React.createElement("TextLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Text = getBodyText(v3.descriptionKey), -- inferred equivalent call
			TextSize = v.Font.BaseSize * v.Font.CaptionHeader.RelativeSize,
			TextColor3 = v.Theme.TextDefault.Color,
			TextTransparency = v.Theme.TextDefault.Transparency,
			FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0)
		})
		return createElement2("Frame", v6, v7)
	end

	return createElement(InteractiveAlert, v5)
end

return InGameVerifyPhoneView
