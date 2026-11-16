local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local UserInputService = game:GetService("UserInputService")
local parent = PhoneUpsell.Parent

local React = require(parent.React)
local Roact = require(parent.Roact)
local UIBlox = require(parent.UIBlox)
local AuthCommon = require(parent.AuthCommon)
local Style = require(parent.Style)
local Foundation = require(parent.Foundation)
local AppCommonLib = require(parent.AppCommonLib)
local Text = AppCommonLib.Text

local normalizeFontFace = Foundation.Utility.normalizeFontFace
local FoundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local v6

	if FoundationFontFaceMigration then
		v6 = Style.GetTextSize(prefix, fontSize, font, vector2).X
	else
		v6 = Text.GetTextWidth(prefix, font, fontSize)
	end

	local v7 = math.max(v6 + 24, size_1200)
	local state2, setState2 = React.useState(300)

	local function onAbsoluteSizeChanged(p2)
		setState2(p2.AbsoluteSize.X)
	end

	local ref = React.useRef(nil)
	local ref2 = React.useRef(nil)
	local ref3 = React.useRef(nil)

	local v8 = Vector2.new(0, 0)
	local v9 = Vector2.new(0, 0)
	local v10 = Vector2.new(0, 0)

	if ref.current then
		v8 = ref.current.AbsolutePosition
	end

	if ref2.current then
		v9 = ref2.current.AbsolutePosition
	end

	if ref3.current then
		v10 = ref3.current.AbsolutePosition
	end

	local maxHeight = math.min(v2.screenSize.Y - (v8.Y + size_1200 + small - v9.Y) - small, 400)

	local v11 = React.useCallback(function(p2)
		local v11 = size_1200 + small
		local v12

		if p2.Position.X > v10.X and p2.Position.X < v10.X + state2 and p2.Position.Y > v10.Y + v11 then
			v12 = p2.Position.Y < v10.Y + v11 + maxHeight
		else
			v12 = false
		end

		local v13

		if p2.Position.X > v10.X and p2.Position.X < v10.X + v7 and p2.Position.Y > v10.Y then
			v13 = p2.Position.Y < v10.Y + size_1200
		else
			v13 = false
		end

		if state and not (v12 or v13) then
			setState(false)
		end
	end, { state, v10, state2, v7, size_1200 })

	useExternalEvent(UserInputService.InputBegan, v11)

	local v12 = v2.errorMessage and v2.errorMessage ~= ""

	local createElement = React.createElement
	local refsByRef = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		[Roact.Ref] = ref
	}
	local v13 = {
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
	local v14 = {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = 0
	}

	local v15 = {
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
			size = UDim2.new(0, v7, 0, tokens.Size.Size_1200),
			layoutOrder = 1,
			font = font,
			textSize = fontSize,
			forwardRef = ref3,
			error = v12
		}),
		PhoneInputBox = 0
	}

	local createElement3 = React.createElement
	local v16 = {
		text = v2.phoneNumber,
		placeholder = "",
		required = true,
		onChange = function(text: string)
			v2.onPhoneNumberTextChange({ Text = text })
		end,
		LayoutOrder = 2,
		width = UDim.new(1, -(v7 + small)),
		error = v12,
		textInputType = 0,
		onFocusGained = 0
	}
	local textInputType

	if v2.usePhoneNumberTextType then
		textInputType = Enum.TextInputType.Phone
	else
		textInputType = Enum.TextInputType.Number
	end

	v16.textInputType = textInputType
	local onFocusGained

	if GetFFlagAddMorePhoneUpsellEvents() then
		onFocusGained = v2.onPhoneInputFocus
	end

	v16.onFocusGained = onFocusGained
	v15.PhoneInputBox = createElement3(TextField, v16)
	v13.PhoneInputContainer = createElement2("Frame", v14, v15)

	if v12 then
		local createElement4 = React.createElement
		local v17 = {
			Text = v2.errorMessage,
			TextTransparency = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			BackgroundTransparency = 1,
			TextColor3 = tokens.Color.System.Alert.Color3,
			Font = 0,
			FontFace = 0,
			TextSize = 0,
			Size = 0,
			AutomaticSize = 0,
			LayoutOrder = 1
		}
		local font2

		if not FoundationFontFaceMigration then
			font2 = v4.Font.Body.Font
		end

		v17.Font = font2
		local fontFace

		if FoundationFontFaceMigration then
			fontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font)
		end

		v17.FontFace = fontFace

		v17.TextSize = baseSize * v4.Font.CaptionSmall.RelativeSize
		v17.Size = UDim2.new(1, 0, 0, 0)
		v17.AutomaticSize = Enum.AutomaticSize.Y
		v12 = createElement4("TextLabel", v17)
	end

	v13.ErrorText = v12
	local element = createElement("Frame", refsByRef, v13)

	local createElement4 = React.createElement
	local v17 = {
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
			local createElement5 = React.createElement
			local v18 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}

			local createElement6 = React.createElement
			local v19 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local children = {
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, tokens.Size.Size_200)
				}),
				SubtitleText = 0,
				PhoneInput = 0,
				PhonePrivacyText = 0,
				PrivacyText = 0
			}

			local createElement7 = React.createElement
			local v20 = {
				LayoutOrder = -1,
				BackgroundTransparency = 1,
				Text = v5.subtitleKey,
				TextSize = baseSize,
				TextColor3 = v4.Theme.TextEmphasis.Color,
				TextTransparency = v4.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = v4.Font.Body.Font
			end

			v20.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font)
			end

			v20.FontFace = fontFace

			v20.TextXAlignment = Enum.TextXAlignment.Left

			v20.Size = UDim2.new(1, 0, 0, 0)
			v20.AutomaticSize = Enum.AutomaticSize.Y
			children.SubtitleText = createElement7("TextLabel", v20)

			children.PhoneInput = element
			local createElement8 = React.createElement
			local v21 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = v5.phonePrivacyDisclaimerKey,
				TextSize = baseSize * relativeSize,
				TextColor3 = v4.Theme.TextEmphasis.Color,
				TextTransparency = v4.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local font3

			if not FoundationFontFaceMigration then
				font3 = v4.Font.Body.Font
			end

			v21.Font = font3
			local fontFace2

			if FoundationFontFaceMigration then
				fontFace2 = normalizeFontFace(tokens.Typography.BodyLarge.Font)
			end

			v21.FontFace = fontFace2

			v21.TextXAlignment = Enum.TextXAlignment.Left

			v21.Size = UDim2.new(1, 0, 0, 0)
			v21.AutomaticSize = Enum.AutomaticSize.Y
			children.PhonePrivacyText = createElement8("TextLabel", v21)

			local createElement9 = React.createElement
			local v22 = {
				LayoutOrder = 3,
				BackgroundTransparency = 1,
				Text = v5.disclaimerKey,
				TextSize = baseSize * relativeSize,
				TextColor3 = v4.Theme.TextEmphasis.Color,
				TextTransparency = v4.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local font4

			if not FoundationFontFaceMigration then
				font4 = v4.Font.Body.Font
			end

			v22.Font = font4
			local fontFace3

			if FoundationFontFaceMigration then
				fontFace3 = normalizeFontFace(tokens.Typography.BodyLarge.Font)
			end

			v22.FontFace = fontFace3

			v22.TextXAlignment = Enum.TextXAlignment.Left

			v22.Size = UDim2.new(1, 0, 0, 0)
			v22.AutomaticSize = Enum.AutomaticSize.Y
			children.PrivacyText = createElement9("TextLabel", v22)
			return createElement5("Frame", v18, {
				AddPhoneViewFrame = createElement6("Frame", v19, children)
			})
		end
	else
		middleContent = function()
			local createElement5 = React.createElement
			local v18 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}

			local createElement6 = React.createElement
			local v19 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v20 = {
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, tokens.Size.Size_200)
				}),
				PhoneInput = element,
				PrivacyText = 0
			}

			local createElement7 = React.createElement
			local v21 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = v5.disclaimerKey,
				TextSize = baseSize * relativeSize,
				TextColor3 = v4.Theme.TextEmphasis.Color,
				TextTransparency = v4.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local font2

			if not FoundationFontFaceMigration then
				font2 = v4.Font.Body.Font
			end

			v21.Font = font2
			local fontFace

			if FoundationFontFaceMigration then
				fontFace = normalizeFontFace(tokens.Typography.BodyLarge.Font)
			end

			v21.FontFace = fontFace

			v21.TextXAlignment = Enum.TextXAlignment.Left

			v21.Size = UDim2.new(1, 0, 0, 0)
			v21.AutomaticSize = Enum.AutomaticSize.Y
			v20.PrivacyText = createElement7("TextLabel", v21)
			return createElement5("Frame", v18, {
				AddPhoneViewFrame = createElement6("Frame", v19, v20)
			})
		end
	end

	v17.middleContent = middleContent
	local element2 = createElement4(InteractiveAlert, v17)

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
				Position = UDim2.new(0, v8.X - v9.X, 0, v8.Y + size_1200 + small - v9.Y)
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
