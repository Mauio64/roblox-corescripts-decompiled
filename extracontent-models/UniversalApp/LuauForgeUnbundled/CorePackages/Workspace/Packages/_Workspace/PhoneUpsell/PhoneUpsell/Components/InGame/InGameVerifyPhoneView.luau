local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local normalizeFontFace = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation").Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization
local textField = UIBlox.App.Input.TextField
local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local getFFlagAddMorePhoneUpsellEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").GetFFlagAddMorePhoneUpsellEvents

local function getButtonStackProps(p2, onActivated, p3, editPhoneDescriptionKey, onActivated2)
	local v5 = {
		{
			buttonType = buttonType.Secondary,
			props = { onActivated = onActivated, text = p2, isDisabled = p3 }
		}
	}

	if onActivated2 and editPhoneDescriptionKey and editPhoneDescriptionKey ~= "" then
		table.insert(v5, 1, {
			buttonType = buttonType.Secondary,
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
		buttons = v5
	}
end

local function InGameVerifyPhoneView(props)
	local v5 = useStyle()
	local tokens = v5.Tokens
	local v6 = {
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
		v6.extraButtonKey = props.extraButtonKey
	end

	local v7 = useLocalization(v6)
	local state, setState = React.useState(0)
	local v8 = state ~= 0

	local function getBodyText(value)
		return value:gsub("{phoneNumber}", "+" .. props.prefix .. props.phoneNumber)
	end

	local function handleResendButtonClick()
		props.onResendPhoneCode()
		setState(10)
		local lastTime = tick()
		local function countDown()
			local v9 = 10 - (tick() - lastTime)

			if v9 > 0 then
				setState((math.ceil(v9)))
				task.delay(1, countDown)
			else
				setState(0)
			end
		end

		local v9 = 10 - (tick() - lastTime)

		if v9 > 0 then
			setState((math.ceil(v9)))
			task.delay(1, countDown)
		else
			setState(0)
		end
	end

	local v9 = if v8 then v7.buttonDisabledKey .. " (" .. state .. ")" else v7.buttonKey

	local v10 = props.errorMessage and props.errorMessage ~= ""

	local createElement = React.createElement
	local v12 = {
		title = v7.titleKey,
		screenSize = props.screenSize,
		buttonStackInfo = getButtonStackProps(
			v9,
			handleResendButtonClick,
			v8,
			v7.editPhoneDescriptionKey,
			props.onExtraButtonClick
		),
		onCloseClicked = props.onClose,
		position = 0,
		anchorPoint = 0,
		middleContent = 0
	}
	local v13 = if props.isKeyboardShowing then UDim2.new(0.5, 0, 1, -props.keyboardHeight) or nil else nil
	v12.position = v13
	v12.anchorPoint = props.isKeyboardShowing and Vector2.new(0.5, 1) or nil
	function v12.middleContent()
		local createElement2 = React.createElement
		local v15 = {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.new(1, 0, 0, 0)
		}
		local v16 = {
			[1] = nil,
			nil,
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, tokens.Size.Size_200)
			})
		}

		local createElement3 = React.createElement
		local v18 = {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 0
		}

		local v19 = {
			ListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				Padding = UDim.new(0, tokens.Size.Size_200)
			}),
			TextBox = 0,
			ErrorText = 0
		}

		local createElement4 = React.createElement
		local v21 = {
			text = props.code,
			placeholder = "",
			required = true,
			onChange = function(p2)
				props.onCodeTextChange({ Text = p2 })
			end,
			LayoutOrder = 1,
			width = UDim.new(1, 0),
			error = v10,
			textInputType = 0,
			onFocusGained = 0
		}

		local v22 = if props.useOTPInputType then Enum.TextInputType.OneTimePassword else Enum.TextInputType.Number
		v21.textInputType = v22

		local v23 = if getFFlagAddMorePhoneUpsellEvents() then props.onCodeInputFocus else nil
		v21.onFocusGained = v23
		v19.TextBox = createElement4(textField, v21)

		v19.ErrorText = v10 and React.createElement("TextLabel", {
			Text = props.errorMessage,
			TextTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = tokens.Color.System.Alert.Color3,
			FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
			TextSize = v5.Font.BaseSize * v5.Font.CaptionSmall.RelativeSize,
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2
		})
		v16[1] = (createElement3("Frame", v18, v19))
		v16.BodyText = React.createElement("TextLabel", {
			LayoutOrder = 3,
			BackgroundTransparency = 1,
			Text = v7.descriptionKey:gsub("{phoneNumber}", "+" .. props.prefix .. props.phoneNumber),
			TextSize = v5.Font.BaseSize * v5.Font.CaptionHeader.RelativeSize,
			TextColor3 = v5.Theme.TextDefault.Color,
			TextTransparency = v5.Theme.TextDefault.Transparency,
			FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
			TextXAlignment = Enum.TextXAlignment.Left,
			AutomaticSize = Enum.AutomaticSize.Y,
			TextWrapped = true,
			Size = UDim2.new(1, 0, 0, 0)
		})
		return createElement2("Frame", v15, v16)
	end

	return createElement(interactiveAlert, v12)
end

return InGameVerifyPhoneView
