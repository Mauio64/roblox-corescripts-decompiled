local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local AuthCommon = require(parent.AuthCommon)
local TextInputBoxWithBorder = AuthCommon.Components.TextInputBoxWithBorder
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local LinkButton = UIBlox.App.Button.LinkButton

local GetFFlagDisableVerifyPhoneViewOnSuccess = require(PhoneUpsell.Flags.GetFFlagDisableVerifyPhoneViewOnSuccess)

local function VerifyPhoneView(props)
	local v = useStyle()
	local v2 = {
		titleKey = "Feature.VerificationUpsell.Heading.VerifyYourPhone",
		verificationCodeKey = "Feature.VerificationUpsell.Heading.VerificationCode",
		placeholderKey = "Feature.VerificationUpsell.Label.SixDigitCode",
		descriptionKey = "Feature.VerificationUpsell.Label.EnterCode",
		buttonKey = "Feature.VerificationUpsell.Action.ResendCode",
		buttonDisabledKey = "Feature.VerificationUpsell.Action.CodeResent",
		changePhoneNumberKey = "Feature.VerificationUpsell.Action.ChangePhoneNumber"
	}

	if props.extraButtonKey and props.extraButtonKey ~= "" then
		v2.extraButtonKey = props.extraButtonKey
	end

	local v3 = useLocalization(v2)
	local state, setState = React.useState(false)
	local state2, setState2 = React.useState(0)

	local function getButtonStackProps(buttonKey: string, buttonDisabledKey: string, p: number, onResendPhoneCode, extraButtonKey: string?, onActivated)
		local function handleButtonClick()
			onResendPhoneCode()
			setState(true)
			setState2(p)
			local lastTime = tick()
			local function countDown()
				local v4 = p - (tick() - lastTime)

				if v4 > 0 then
					setState2((math.round(v4)))
					task.delay(1, countDown)
				else
					setState2(0)
					setState(false)
				end
			end
			countDown()
		end

		local function getButtonText() -- 1 equivalent call inferred from this helper
			if state then
				return buttonDisabledKey .. " (" .. state2 .. ")"
			end

			return buttonKey
		end

		local buttons = {
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = handleButtonClick,
					text = getButtonText(), -- inferred equivalent call
					isDisabled = state or GetFFlagDisableVerifyPhoneViewOnSuccess() and props.isDisabled
				}
			}
		}

		if onActivated and extraButtonKey and extraButtonKey ~= "" then
			table.insert(buttons, 1, {
				buttonType = ButtonType.Secondary,
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
			buttons = buttons
		}
	end

	local function getBodyText(descriptionKey: string) -- 1 equivalent call inferred from this helper
		return descriptionKey:gsub("{phoneNumber}", "+" .. props.prefix .. props.phoneNumber)
	end

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(props.screenSize.X)

	local createElement = React.createElement
	local v4 = {
		title = v3.titleKey,
		screenSize = props.screenSize,
		buttonStackProps = getButtonStackProps(
			v3.buttonKey,
			v3.buttonDisabledKey,
			10,
			props.onResendPhoneCode,
			v3.extraButtonKey,
			props.onExtraButtonClick
		),
		onCloseClicked = props.onClose,
		position = 0,
		anchorPoint = 0
	}
	local position

	if props.isKeyboardShowing then
		position = UDim2.new(0.5, 0, 1, -props.keyboardHeight) or nil
	end

	v4.position = position
	v4.anchorPoint = props.isKeyboardShowing and Vector2.new(0.5, 1) or nil
	return createElement(PartialPageModal, v4, {
		Middle = React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			},
			{
				ContentPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 24)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					Padding = UDim.new(0, 12)
				}),
				BodyText = React.createElement("TextLabel", {
					LayoutOrder = 1,
					BackgroundTransparency = 1,
					Text = getBodyText(v3.descriptionKey), -- inferred equivalent call
					TextSize = v.Font.BaseSize,
					TextColor3 = v.Theme.TextDefault.Color,
					TextTransparency = v.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(v.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextWrapped = true,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
				}),
				TextBox = React.createElement(TextInputBoxWithBorder, {
					text = props.code,
					textInputType = props.useOTPInputType and Enum.TextInputType.OneTimePassword or Enum.TextInputType.Number,
					textInputHeight = 36,
					layoutOrder = 2,
					placeholderText = v3.placeholderKey,
					errorText = props.errorMessage,
					onChangeTextCallback = props.onCodeTextChange,
					Size = UDim2.new(1, 0, 0, 0),
					onFocused = props.onCodeInputFocus,
					maxLength = 6
				}),
				ChangePhoneButton = React.createElement(LinkButton, {
					text = v3.changePhoneNumberKey,
					onActivated = props.returnToAddPhone,
					layoutOrder = 3,
					fontStyle = "CaptionBody",
					minPaddingX = 0,
					minPaddingY = 0
				})
			}
		)
	})
end

return VerifyPhoneView
