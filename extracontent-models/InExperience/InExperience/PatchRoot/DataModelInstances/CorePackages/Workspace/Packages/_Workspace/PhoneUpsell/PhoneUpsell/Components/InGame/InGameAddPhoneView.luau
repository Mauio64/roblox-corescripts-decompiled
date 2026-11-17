local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local UserInputService = game:GetService("UserInputService")
local parent = PhoneUpsell.Parent

local React = require(parent.React)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local AuthCommon = require(parent.AuthCommon)
local Style = require(parent.Style)
local Foundation = require(parent.Foundation)

local normalizeFontFace = Foundation.Utility.normalizeFontFace
local useStyle = UIBlox.Core.Style.useStyle
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local TextField = UIBlox.App.Input.TextField
local CountryCodeButton = require(PhoneUpsell.Components.InGame.CountryCodeButton)
local CountryCodeDropdownContainer = AuthCommon.Components.InGame.CountryCodeDropdownContainer
local RoactUtils = require(parent.RoactUtils)
local useExternalEvent = RoactUtils.Hooks.useExternalEvent

local SharedFlags = require(parent.SharedFlags)
local GetFFlagAddMorePhoneUpsellEvents = SharedFlags.GetFFlagAddMorePhoneUpsellEvents
local SharedFlags2 = require(parent.SharedFlags)
local FFlagInExperienceAddPhoneViewNewCopy = SharedFlags2.FFlagInExperienceAddPhoneViewNewCopy

local vector2 = Vector2.new(10000, 10000)

local v = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	buttonKey = FFlagInExperienceAddPhoneViewNewCopy and "Feature.AccountSettings.Action.Verify" or "Feature.VerificationUpsell.Action.Next",
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	prefix = "1"
}

local function getButtonStackProps(buttonKey: string, onActivated, isDisabled: boolean, extraButtonKey: string, onActivated2)
	local buttons = {
		{
			buttonType = ButtonType.PrimarySystem,
			props = { onActivated = onActivated, text = buttonKey, isDisabled = isDisabled }
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(buttons, 1, {
			buttonType = ButtonType.Secondary,
			props = { onActivated = onActivated2, text = extraButtonKey, isDisabled = false }
		})
	end

	return { buttonHeight = 48, buttons = buttons }
end

local function InGameAddPhoneView(p)
	local v2 = mergeProps(v, p)
	local v3

	if FFlagInExperienceAddPhoneViewNewCopy then
		v3 = {
			phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
			disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
			termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
			privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
			subtitleKey = "Feature.AccountSettings.Description.AddPhoneNumber",
			phonePrivacyDisclaimerKey = "Feature.AccountSettings.Description.NotShownPublicly",
			titleKey = v2.titleKey,
			descriptionKey = v2.descriptionKey,
			buttonKey = v2.buttonKey,
			legalTextKey = v2.legalTextKey
		}
	else
		v3 = {
			phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
			disclaimerKey = "Feature.VerificationUpsell.Description.VerificationCodeSmsFeesMayApply",
			termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
			privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
			titleKey = v2.titleKey,
			descriptionKey = v2.descriptionKey,
			buttonKey = v2.buttonKey,
			legalTextKey = v2.legalTextKey
		}
	end

	if v2.extraButtonKey and v2.extraButtonKey ~= "" then
		v3.extraButtonKey = v2.extraButtonKey
	end

	local v4 = useStyle()
	local tokens = v4.Tokens
	local bodyLarge = tokens.Typography.BodyLarge
	local font = bodyLarge.Font
	local fontSize = bodyLarge.FontSize

	local v5 = useLocalization(v3)

	local baseSize = v4.Font.BaseSize
	local relativeSize = v4.Font.CaptionHeader.RelativeSize
	local isDisabled = v2.isDisabled

	local small = tokens.Gap.Small
	local size_1200 = tokens.Size.Size_1200

	local prefix = v2.countryCode.prefix
	local state, setState = React.useState(false)
	local v6 = math.max(Style.GetTextSize(prefix, fontSize, font, vector2).X + 24, size_1200)
	local state2, setState2 = React.useState(300)

	local function onAbsoluteSizeChanged(p2)
		setState2(p2.AbsoluteSize.X)
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v7 = Vector2.new(0, 0)
	local v8 = Vector2.new(0, 0)
	local v9 = Vector2.new(0, 0)

	if ref.current then
		v7 = ref.current.AbsolutePosition
	end

	if ref2.current then
		v8 = ref2.current.AbsolutePosition
	end

	if ref3.current then
		v9 = ref3.current.AbsolutePosition
	end

	local maxHeight = math.min(v2.screenSize.Y - (v7.Y + size_1200 + small - v8.Y) - small, 400)

	local v10 = React.useCallback(function(p2)
		local v10 = size_1200 + small
		local v11

		if p2.Position.X > v9.X and p2.Position.X < v9.X + state2 and p2.Position.Y > v9.Y + v10 then
			v11 = p2.Position.Y < v9.Y + v10 + maxHeight
		else
			v11 = false
		end

		local v12

		if p2.Position.X > v9.X and p2.Position.X < v9.X + v6 and p2.Position.Y > v9.Y then
			v12 = p2.Position.Y < v9.Y + size_1200
		else
			v12 = false
		end

		if state and not (v11 or v12) then
			setState(false)
		end
	end, { state, v9, state2, v6, size_1200 })

	useExternalEvent(UserInputService.InputBegan, v10)

	local err = v2.errorMessage and v2.errorMessage ~= ""

	local createElement = React.createElement
	local refsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = ref
	}
	local v11 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Left,
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, tokens.Size.Size_200)
		}),
		PhoneInputContainer = 0,
		ErrorText = 0
	}

	local createElement2 = React.createElement
	local v12 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 0
	}

	local v13 = {
		ListLayout = React.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, small)
		}),
		CountryCodeButton = React.createElement(CountryCodeButton, {
			countryPrefix = "+" .. prefix,
			onButtonClick = function()
				setState(not state)

				if GetFFlagAddMorePhoneUpsellEvents then
					v2.onCountryCodeSelectorClick()
				end
			end,
			size = UDim2.new(0, v6, 0, tokens.Size.Size_1200),
			layoutOrder = 1,
			font = font,
			textSize = fontSize,
			forwardRef = ref3,
			error = err
		}),
		PhoneInputBox = 0
	}

	local createElement3 = React.createElement
	local v14 = {
		text = v2.phoneNumber,
		placeholder = "",
		required = true,
		onChange = function(text: string)
			v2.onPhoneNumberTextChange({ Text = text })
		end,
		LayoutOrder = 2,
		width = UDim.new(1, -(v6 + small)),
		error = err,
		textInputType = 0,
		onFocusGained = 0
	}
	local textInputType

	if v2.usePhoneNumberTextType then
		textInputType = Enum.TextInputType.Phone
	else
		textInputType = Enum.TextInputType.Number
	end

	v14.textInputType = textInputType
	local onFocusGained

	if GetFFlagAddMorePhoneUpsellEvents() then
		onFocusGained = v2.onPhoneInputFocus
	end

	v14.onFocusGained = onFocusGained
	v13.PhoneInputBox = createElement3(TextField, v14)
	v11.PhoneInputContainer = createElement2("Frame", v12, v13)

	v11.ErrorText = err and React.createElement("TextLabel", {
		Text = v2.errorMessage,
		TextTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextWrapped = true,
		BackgroundTransparency = 1,
		TextColor3 = tokens.Color.System.Alert.Color3,
		FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
		TextSize = baseSize * v4.Font.CaptionSmall.RelativeSize,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 1
	})
	local element = createElement("Frame", refsByRef, v11)

	local createElement4 = React.createElement
	local v15 = {
		screenSize = v2.screenSize,
		buttonStackInfo = getButtonStackProps(
			v5.buttonKey,
			v2.onSetPhoneNumber,
			isDisabled,
			v5.extraButtonKey,
			v2.onExtraButtonClick
		),
		position = v2.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v2.keyboardHeight) or UDim2.fromScale(0.5, 0.5),
		anchorPoint = v2.isKeyboardShowing and Vector2.new(0.5, 1) or nil,
		title = v5.titleKey,
		onAbsoluteSizeChanged = onAbsoluteSizeChanged,
		onCloseClicked = v2.onClose,
		middleContent = 0
	}
	local middleContent

	if FFlagInExperienceAddPhoneViewNewCopy then
		middleContent = function()
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					AddPhoneViewFrame = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						},
						{
							ListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, tokens.Size.Size_200)
							}),
							SubtitleText = React.createElement("TextLabel", {
								LayoutOrder = -1,
								BackgroundTransparency = 1,
								Text = v5.subtitleKey,
								TextSize = baseSize,
								TextColor3 = v4.Theme.TextEmphasis.Color,
								TextTransparency = v4.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							}),
							PhoneInput = element,
							PhonePrivacyText = React.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								Text = v5.phonePrivacyDisclaimerKey,
								TextSize = baseSize * relativeSize,
								TextColor3 = v4.Theme.TextEmphasis.Color,
								TextTransparency = v4.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							}),
							PrivacyText = React.createElement("TextLabel", {
								LayoutOrder = 3,
								BackgroundTransparency = 1,
								Text = v5.disclaimerKey,
								TextSize = baseSize * relativeSize,
								TextColor3 = v4.Theme.TextEmphasis.Color,
								TextTransparency = v4.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							})
						}
					)
				}
			)
		end
	else
		middleContent = function()
			return React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				},
				{
					AddPhoneViewFrame = React.createElement(
						"Frame",
						{
							BackgroundTransparency = 1,
							AutomaticSize = Enum.AutomaticSize.Y,
							Size = UDim2.new(1, 0, 0, 0)
						},
						{
							ListLayout = React.createElement("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								Padding = UDim.new(0, tokens.Size.Size_200)
							}),
							PhoneInput = element,
							PrivacyText = React.createElement("TextLabel", {
								LayoutOrder = 2,
								BackgroundTransparency = 1,
								Text = v5.disclaimerKey,
								TextSize = baseSize * relativeSize,
								TextColor3 = v4.Theme.TextEmphasis.Color,
								TextTransparency = v4.Theme.TextEmphasis.Transparency,
								FontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, 0, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							})
						}
					)
				}
			)
		end
	end

	v15.middleContent = middleContent
	local element2 = createElement4(InteractiveAlert, v15)

	return React.createElement(
		"Frame",
		{
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			BorderSizePixel = 0,
			[Roact.Ref] = ref2
		},
		{
			AddPhoneView = element2,
			CountryCodeSelectorFrame = React.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(0, state2 - 24, 0, 0),
				ZIndex = 2,
				BorderSizePixel = 0,
				Position = UDim2.new(0, v7.X - v8.X, 0, v7.Y + size_1200 + small - v8.Y)
			}, {
				CountryCodeDropdown = React.createElement(CountryCodeDropdownContainer, {
					dropdownVisible = state,
					position = UDim2.new(0, 0, 0, 0),
					maxHeight = maxHeight,
					onCountryCodeSelected = function(p2)
						v2.setCountryCode(p2)
						setState(false)
					end
				})
			})
		}
	)
end

return InGameAddPhoneView
