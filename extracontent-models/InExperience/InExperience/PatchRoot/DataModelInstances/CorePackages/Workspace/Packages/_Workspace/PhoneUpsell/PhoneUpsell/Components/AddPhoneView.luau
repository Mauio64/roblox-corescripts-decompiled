local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local parent = PhoneUpsell.Parent

local React = require(parent.React)

local UIBlox = require(parent.UIBlox)

local Foundation = require(parent.Foundation)
local Checkbox = Foundation.Checkbox

local Text = Foundation.Text
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Style.withStyle
local Localization = require(parent.Localization)
local withLocalization = Localization.withLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth

local AuthCommon = require(parent.AuthCommon)
local TextBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local PhoneNumberTextBox = AuthCommon.Components.PhoneNumberTextBox
local LinkButton = UIBlox.App.Button.LinkButton
local mergeProps = require(PhoneUpsell.Utils.mergeProps)

local SharedFlags = require(parent.SharedFlags)
local FFlagHomePhoneVerificationUpsellNewCopy = SharedFlags.FFlagHomePhoneVerificationUpsellNewCopy
local FFlagPhoneUpsellFocusNavigation = require(PhoneUpsell.Flags.FFlagPhoneUpsellFocusNavigation)

local v = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	buttonKey = "Feature.VerificationUpsell.Action.Continue",
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	shouldShowVerificationText = not FFlagHomePhoneVerificationUpsellNewCopy and nil
}

local function getButtonStackProps(buttonKey: string, onActivated, isDisabled: boolean, extraButtonKey: string, onActivated2, p)
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

	local buttonStackProps = {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = buttons
	}

	if p then
		buttonStackProps.disableRoactGamepadButtonSelection = true
		buttons[#buttons].props.NextSelectionUp = p.NextSelectionUp
	end

	return buttonStackProps
end

local function AddPhoneView(p)
	local v2 = mergeProps(v, p)

	local function noOp() end

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(v2.screenSize.X)

	local v3 = {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.VerificationUpsell.Description.PhoneNumberNeverPublic",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v2.titleKey,
		descriptionKey = v2.descriptionKey,
		buttonKey = v2.buttonKey,
		legalTextKey = v2.legalTextKey,
		verificationKey = FFlagHomePhoneVerificationUpsellNewCopy and "Feature.VerificationUpsell.Description.AddPhoneBody" or nil
	}

	if v2.extraButtonKey and v2.extraButtonKey ~= "" then
		v3.extraButtonKey = v2.extraButtonKey
	end

	return withStyle(function(data)
		return withLocalization(v3)(function(props)
			local baseSize = data.Font.BaseSize
			local relativeSize = data.Font.Body.RelativeSize
			local relativeSize2 = data.Font.CaptionHeader.RelativeSize
			local isDisabled = v2.isDisabled or v2.requireLegalTextCheckbox and not state
			local v4

			if v2.countryCode.prefix == "1" then
				v4 = not v2.disableLegalText
			else
				v4 = false
			end

			local createElement = React.createElement
			local v5 = {
				title = props.titleKey,
				screenSize = v2.screenSize,
				buttonStackProps = getButtonStackProps(
					props.buttonKey,
					v2.onSetPhoneNumber,
					isDisabled,
					props.extraButtonKey,
					v2.onExtraButtonClick,
					FFlagPhoneUpsellFocusNavigation and v4 and { NextSelectionUp = ref } or nil
				),
				onCloseClicked = v2.onClose,
				position = v2.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v2.keyboardHeight) or nil,
				anchorPoint = v2.isKeyboardShowing and Vector2.new(0.5, 1) or nil
			}

			local createElement2 = React.createElement
			local v6 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v7 = {
				ContentPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 24)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 6)
				}),
				BodyText = React.createElement("TextLabel", {
					LayoutOrder = 0,
					BackgroundTransparency = 1,
					Text = props.descriptionKey,
					TextSize = baseSize,
					TextColor3 = data.Theme.TextDefault.Color,
					TextTransparency = data.Theme.TextDefault.Transparency,
					FontFace = normalizeFontFace(data.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y
				}),
				PhoneInput = React.createElement(TextBoxStateWrapper, {
					ChildClass = PhoneNumberTextBox,
					ErrorState = v2.errorMessage ~= "",
					ErrorText = v2.errorMessage,
					Size = UDim2.new(1, 0, 0, 36),
					LayoutOrder = 1,
					ChildProps = {
						CountryCode = v2.countryCode,
						SetCountryCode = v2.setCountryCode,
						Text = v2.phoneNumber,
						PlaceholderText = props.phoneNumberKey,
						Font = data.Font.Body.Font,
						TextSize = baseSize * relativeSize,
						TextXAlignment = Enum.TextXAlignment.Left,
						Color = data.Theme.BackgroundUIContrast.Color,
						Transparency = data.Theme.BackgroundUIContrast.Transparency,
						TextColor = data.Theme.TextDefault.Color,
						PlaceholderColor = data.Theme.UIDefault.Color,
						TextTransparency = data.Theme.TextDefault.Transparency,
						ClearTextOnFocus = false,
						PaddingX = 12,
						TextInputTypeOverride = v2.usePhoneNumberTextType and Enum.TextInputType.Phone or Enum.TextInputType.Number,
						onChangeText = v2.onPhoneNumberTextChange,
						onFocused = v2.onPhoneInputFocus,
						onFocusLost = noOp,
						phoneCountryCodeSelectorCallback = v2.onCountryCodeSelectorClick
					}
				}),
				PrivacyText = React.createElement("TextLabel", {
					LayoutOrder = 2,
					BackgroundTransparency = 1,
					Text = props.phonePrivacyDisclaimerKey,
					TextSize = baseSize * relativeSize2,
					TextColor3 = data.Theme.TextEmphasis.Color,
					TextTransparency = data.Theme.TextEmphasis.Transparency,
					FontFace = normalizeFontFace(data.Tokens.Typography.BodyLarge.Font),
					TextXAlignment = Enum.TextXAlignment.Left,
					TextWrapped = true,
					Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 24)
				}),
				VerificationText = 0,
				LegalTextContainer = 0,
				LegalButtonsContainer = 0
			}
			local verificationText

			if FFlagHomePhoneVerificationUpsellNewCopy and v2.shouldShowVerificationText then
				verificationText = React.createElement(Text, {
					tag = "auto-y size-full-0 text-wrap text-body-small text-align-x-left",
					Text = props.verificationKey,
					LayoutOrder = 2
				})
			end

			v7.VerificationText = verificationText

			local legalTextContainer = not v2.disableLegalText

			if legalTextContainer then
				if v2.requireLegalTextCheckbox then
					legalTextContainer = React.createElement(
						"Frame",
						{
							LayoutOrder = 3,
							BackgroundTransparency = 1,
							Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						},
						{
							UIListLayout = React.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 6)
							}),
							LegalCheckbox = React.createElement(Checkbox, {
								onActivated = setState,
								isChecked = state,
								label = ""
							}),
							LegalText = React.createElement("TextLabel", {
								BackgroundTransparency = 1,
								Text = props.legalTextKey,
								TextSize = baseSize * relativeSize2,
								TextColor3 = data.Theme.TextDefault.Color,
								TextTransparency = data.Theme.TextDefault.Transparency,
								FontFace = normalizeFontFace(data.Tokens.Typography.BodyLarge.Font),
								TextXAlignment = Enum.TextXAlignment.Left,
								TextWrapped = true,
								Size = UDim2.new(1, -32, 0, 0),
								AutomaticSize = Enum.AutomaticSize.Y
							})
						}
					)
				elseif v2.alwaysShowLegalText or v2.countryCode.prefix == "1" then
					legalTextContainer = React.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Text = props.legalTextKey,
						TextSize = baseSize * relativeSize2,
						TextColor3 = data.Theme.TextDefault.Color,
						TextTransparency = data.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(data.Tokens.Typography.BodyLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Left,
						TextWrapped = true,
						Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					})
				else
					legalTextContainer = nil
				end
			end

			v7.LegalTextContainer = legalTextContainer
			local legalButtonsContainer

			if v2.countryCode.prefix == "1" then
				legalButtonsContainer = not v2.disableLegalText

				if legalButtonsContainer then
					local createElement3 = React.createElement
					local v8 = {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}
					local children = {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 5)
						}),
						TermsOfUseButton = 0,
						TextButtonDivider = 0,
						PrivacyPolicyButton = 0
					}

					local createElement4 = React.createElement
					local v9 = {
						text = props.termsOfUseKey,
						onActivated = v2.onTermsOfUseClick,
						layoutOrder = 5,
						fontStyle = "CaptionBody",
						size = UDim2.fromScale(0.2, 0.2),
						buttonRef = 0
					}
					local buttonRef

					if FFlagPhoneUpsellFocusNavigation then
						buttonRef = ref
					end

					v9.buttonRef = buttonRef
					children.TermsOfUseButton = createElement4(LinkButton, v9)

					children.TextButtonDivider = React.createElement("TextLabel", {
						LayoutOrder = 6,
						BackgroundTransparency = 1,
						Text = "-",
						TextSize = baseSize * relativeSize2,
						TextColor3 = data.Theme.TextDefault.Color,
						TextTransparency = data.Theme.TextDefault.Transparency,
						FontFace = normalizeFontFace(data.Tokens.Typography.BodyLarge.Font),
						TextXAlignment = Enum.TextXAlignment.Center,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.XY
					})

					children.PrivacyPolicyButton = React.createElement(LinkButton, {
						text = props.privacyPolicyKey,
						onActivated = v2.onPrivacyPolicyClick,
						layoutOrder = 7,
						fontStyle = "CaptionBody"
					})
					legalButtonsContainer = createElement3("Frame", v8, children)
				end
			else
				legalButtonsContainer = false
			end

			v7.LegalButtonsContainer = legalButtonsContainer
			return createElement(PartialPageModal, v5, {
				Middle = createElement2("Frame", v6, v7)
			})
		end)
	end)
end

return AddPhoneView
