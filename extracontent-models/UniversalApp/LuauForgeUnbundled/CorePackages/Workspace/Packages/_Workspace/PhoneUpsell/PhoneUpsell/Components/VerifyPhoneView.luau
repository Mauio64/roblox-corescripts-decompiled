local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
local useStyle = UIBlox.Core.Style.useStyle
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").Hooks.useLocalization

local buttonType = UIBlox.App.Button.Enum.ButtonType
local textInputBoxWithBorder = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon").Components.TextInputBoxWithBorder
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local linkButton = UIBlox.App.Button.LinkButton

local GetFFlagDisableVerifyPhoneViewOnSuccess = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/GetFFlagDisableVerifyPhoneViewOnSuccess")

local function VerifyPhoneView(props)
	local v5 = useStyle()
	local v6 = {
		titleKey = "Feature.VerificationUpsell.Heading.VerifyYourPhone",
		verificationCodeKey = "Feature.VerificationUpsell.Heading.VerificationCode",
		placeholderKey = "Feature.VerificationUpsell.Label.SixDigitCode",
		descriptionKey = "Feature.VerificationUpsell.Label.EnterCode",
		buttonKey = "Feature.VerificationUpsell.Action.ResendCode",
		buttonDisabledKey = "Feature.VerificationUpsell.Action.CodeResent",
		changePhoneNumberKey = "Feature.VerificationUpsell.Action.ChangePhoneNumber"
	}

	if props.extraButtonKey and props.extraButtonKey ~= "" then
		v6.extraButtonKey = props.extraButtonKey
	end

	local v7 = useLocalization(v6)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(0)

	local function getButtonStackProps(buttonKey, buttonDisabledKey, p2, onResendPhoneCode, extraButtonKey, onActivated)
		local function handleButtonClick()
			onResendPhoneCode()
			setState(true)
			setState2(p2)
			local lastTime = tick()
			local function countDown()
				local v8 = p2 - (tick() - lastTime)

				if v8 > 0 then
					setState2((math.round(v8)))
					task.delay(1, countDown)
				else
					setState2(0)
					setState(false)
				end
			end
			countDown()
		end

		local function getButtonText()
			if state then
				return buttonDisabledKey .. " (" .. state2 .. ")"
			end

			return buttonKey
		end

		local v9 = { buttonType = buttonType.PrimarySystem, props = 0 }
		local v11 = if state then buttonDisabledKey .. " (" .. state2 .. ")" else buttonKey

		v9.props = {
			onActivated = handleButtonClick,
			text = v11,
			isDisabled = state or GetFFlagDisableVerifyPhoneViewOnSuccess() and props.isDisabled
		}
		local v8 = { v9 }

		if onActivated and extraButtonKey and extraButtonKey ~= "" then
			table.insert(v8, 1, {
				buttonType = buttonType.Secondary,
				props = {
					onActivated = onActivated,
					text = extraButtonKey,
					isDisabled = GetFFlagDisableVerifyPhoneViewOnSuccess() and props.isDisabled
				}
			})
		end

		return {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Vertical,
			buttons = v8
		}
	end

	local function getBodyText(value)
		return value:gsub("{phoneNumber}", "+" .. props.prefix .. props.phoneNumber)
	end

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	local createElement = React.createElement
	local v9 = {
		title = v7.titleKey,
		screenSize = props.screenSize,
		buttonStackProps = getButtonStackProps(
			v7.buttonKey,
			v7.buttonDisabledKey,
			10,
			props.onResendPhoneCode,
			v7.extraButtonKey,
			props.onExtraButtonClick
		),
		onCloseClicked = props.onClose,
		position = 0,
		anchorPoint = 0
	}
	local v10 = if props.isKeyboardShowing then UDim2.new(0.5, 0, 1, -props.keyboardHeight) or nil else nil
	v9.position = v10
	v9.anchorPoint = props.isKeyboardShowing and Vector2.new(0.5, 1) or nil

	local createElement2 = React.createElement
	local v13 = {
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0)
	}
	local children = {
		ContentPadding = React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 24),
			PaddingBottom = UDim.new(0, 24)
		}),
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			Padding = UDim.new(0, 12)
		}),
		BodyText = 0,
		TextBox = 0,
		ChangePhoneButton = 0
	}

	local createElement3 = React.createElement
	local v15 = {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Text = v7.descriptionKey:gsub("{phoneNumber}", "+" .. props.prefix .. props.phoneNumber),
		TextSize = v5.Font.BaseSize,
		TextColor3 = v5.Theme.TextDefault.Color,
		TextTransparency = v5.Theme.TextDefault.Transparency,
		Font = 0,
		FontFace = 0,
		TextXAlignment = 0,
		AutomaticSize = 0,
		TextWrapped = true,
		Size = 0
	}
	local v16 = if not foundationFontFaceMigration then v5.Font.Body.Font else nil
	v15.Font = v16

	local v17 = if foundationFontFaceMigration then normalizeFontFace(v5.Tokens.Typography.BodyLarge.Font) else nil
	v15.FontFace = v17

	v15.TextXAlignment = Enum.TextXAlignment.Left
	v15.AutomaticSize = Enum.AutomaticSize.Y

	v15.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
	children.BodyText = createElement3("TextLabel", v15)

	children.TextBox = React.createElement(textInputBoxWithBorder, {
		text = props.code,
		textInputType = props.useOTPInputType and Enum.TextInputType.OneTimePassword or Enum.TextInputType.Number,
		textInputHeight = 36,
		layoutOrder = 2,
		placeholderText = v7.placeholderKey,
		errorText = props.errorMessage,
		onChangeTextCallback = props.onCodeTextChange,
		Size = UDim2.new(1, 0, 0, 0),
		onFocused = props.onCodeInputFocus,
		maxLength = 6
	})

	children.ChangePhoneButton = React.createElement(linkButton, {
		text = v7.changePhoneNumberKey,
		onActivated = props.returnToAddPhone,
		layoutOrder = 3,
		fontStyle = "CaptionBody",
		minPaddingX = 0,
		minPaddingY = 0
	})
	return createElement(partialPageModal, v9, {
		Middle = createElement2("Frame", v13, children)
	})
end

return VerifyPhoneView
