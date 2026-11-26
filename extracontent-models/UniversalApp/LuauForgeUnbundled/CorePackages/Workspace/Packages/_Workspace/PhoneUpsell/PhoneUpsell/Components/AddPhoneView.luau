local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local checkbox = Foundation.Checkbox

local text = Foundation.Text
local normalizeFontFace = Foundation.Utility.normalizeFontFace

local withStyle = UIBlox.Style.withStyle
local withLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Localization").withLocalization
local buttonType = UIBlox.App.Button.Enum.ButtonType
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth

local AuthCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/AuthCommon")
local textBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local phoneNumberTextBox = AuthCommon.Components.PhoneNumberTextBox
local linkButton = UIBlox.App.Button.LinkButton
local mergeProps = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Utils/mergeProps")

local fFlagHomePhoneVerificationUpsellNewCopy = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/SharedFlags").FFlagHomePhoneVerificationUpsellNewCopy
local FFlagPhoneUpsellFocusNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/PhoneUpsell/Flags/FFlagPhoneUpsellFocusNavigation")

local v5 = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	buttonKey = "Feature.VerificationUpsell.Action.Continue",
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	shouldShowVerificationText = if fFlagHomePhoneVerificationUpsellNewCopy then false else nil
}

local function getButtonStackProps(buttonKey, onActivated, isDisabled, extraButtonKey, onActivated2, p2)
	local v7 = {
		{
			buttonType = buttonType.PrimarySystem,
			props = {
				onActivated = onActivated,
				text = buttonKey,
				isDisabled = isDisabled
			}
		}
	}

	if extraButtonKey and extraButtonKey ~= "" then
		table.insert(v7, 1, {
			buttonType = buttonType.Secondary,
			props = {
				onActivated = onActivated2,
				text = extraButtonKey,
				isDisabled = false
			}
		})
	end

	local buttonStackProps = {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = v7
	}

	if p2 then
		buttonStackProps.disableRoactGamepadButtonSelection = true
		v7[#v7].props.NextSelectionUp = p2.NextSelectionUp
	end

	return buttonStackProps
end

local function AddPhoneView(p2)
	local v7 = mergeProps(v5, p2)

	local function noOp() end

	local state, setState = React.useState(false)

	local ref = React.useRef(nil)

	local partialPageModalMiddleContentWidth = getPartialPageModalMiddleContentWidth(v7.screenSize.X)

	local v8 = {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.VerificationUpsell.Description.PhoneNumberNeverPublic",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v7.titleKey,
		descriptionKey = v7.descriptionKey,
		buttonKey = v7.buttonKey,
		legalTextKey = v7.legalTextKey,
		verificationKey = fFlagHomePhoneVerificationUpsellNewCopy and "Feature.VerificationUpsell.Description.AddPhoneBody" or nil
	}

	if v7.extraButtonKey and v7.extraButtonKey ~= "" then
		v8.extraButtonKey = v7.extraButtonKey
	end

	return withStyle(function(data)
		return withLocalization(v8)(function(props)
			local baseSize = data.Font.BaseSize
			local relativeSize = data.Font.Body.RelativeSize
			local relativeSize2 = data.Font.CaptionHeader.RelativeSize
			local isDisabled = v7.isDisabled or v7.requireLegalTextCheckbox and not state
			local v9 = v7.countryCode.prefix == "1" and not v7.disableLegalText

			local createElement = React.createElement
			local v11 = {
				title = props.titleKey,
				screenSize = v7.screenSize,
				buttonStackProps = getButtonStackProps(
					props.buttonKey,
					v7.onSetPhoneNumber,
					isDisabled,
					props.extraButtonKey,
					v7.onExtraButtonClick,
					FFlagPhoneUpsellFocusNavigation and v9 and { NextSelectionUp = ref } or nil
				),
				onCloseClicked = v7.onClose,
				position = v7.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v7.keyboardHeight) or nil,
				anchorPoint = v7.isKeyboardShowing and Vector2.new(0.5, 1) or nil
			}

			local createElement2 = React.createElement
			local v14 = {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.new(1, 0, 0, 0)
			}
			local v15 = {
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
				PhoneInput = React.createElement(textBoxStateWrapper, {
					ChildClass = phoneNumberTextBox,
					ErrorState = v7.errorMessage ~= "",
					ErrorText = v7.errorMessage,
					Size = UDim2.new(1, 0, 0, 36),
					LayoutOrder = 1,
					ChildProps = {
						CountryCode = v7.countryCode,
						SetCountryCode = v7.setCountryCode,
						Text = v7.phoneNumber,
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
						TextInputTypeOverride = v7.usePhoneNumberTextType and Enum.TextInputType.Phone or Enum.TextInputType.Number,
						onChangeText = v7.onPhoneNumberTextChange,
						onFocused = v7.onPhoneInputFocus,
						onFocusLost = noOp,
						phoneCountryCodeSelectorCallback = v7.onCountryCodeSelectorClick
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

			local v16 = if fFlagHomePhoneVerificationUpsellNewCopy and v7.shouldShowVerificationText then React.createElement(text, {
				tag = "auto-y size-full-0 text-wrap text-body-small text-align-x-left",
				Text = props.verificationKey,
				LayoutOrder = 2
			}) else nil
			v15.VerificationText = v16

			local v17 = not v7.disableLegalText

			if v17 then
				if v7.requireLegalTextCheckbox then
					v17 = React.createElement(
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
							LegalCheckbox = React.createElement(checkbox, {
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
				elseif v7.alwaysShowLegalText or v7.countryCode.prefix == "1" then
					v17 = React.createElement("TextLabel", {
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
					v17 = nil
				end
			end

			v15.LegalTextContainer = v17
			local v18

			if v7.countryCode.prefix == "1" then
				v18 = not v7.disableLegalText

				if v18 then
					v18 = React.createElement(
						"Frame",
						{
							LayoutOrder = 4,
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						},
						{
							UIListLayout = React.createElement("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								SortOrder = Enum.SortOrder.LayoutOrder,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								VerticalAlignment = Enum.VerticalAlignment.Center,
								Padding = UDim.new(0, 5)
							}),
							TermsOfUseButton = React.createElement(linkButton, {
								text = props.termsOfUseKey,
								onActivated = v7.onTermsOfUseClick,
								layoutOrder = 5,
								fontStyle = "CaptionBody",
								size = UDim2.fromScale(0.2, 0.2),
								buttonRef = if FFlagPhoneUpsellFocusNavigation then ref else nil
							}),
							TextButtonDivider = React.createElement("TextLabel", {
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
							}),
							PrivacyPolicyButton = React.createElement(linkButton, {
								text = props.privacyPolicyKey,
								onActivated = v7.onPrivacyPolicyClick,
								layoutOrder = 7,
								fontStyle = "CaptionBody"
							})
						}
					)
				end
			else
				v18 = false
			end

			v15.LegalButtonsContainer = v18
			return createElement(partialPageModal, v11, {
				Middle = createElement2("Frame", v14, v15)
			})
		end)
	end)
end

return AddPhoneView
