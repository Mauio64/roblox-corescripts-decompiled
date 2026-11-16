local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/React")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/UIBlox")

local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/PhoneUpsell/Foundation")
local checkbox = Foundation.Checkbox

local text = Foundation.Text
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration

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
			local children = {
				ContentPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 12),
					PaddingBottom = UDim.new(0, 24)
				}),
				ListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = UDim.new(0, 6)
				}),
				BodyText = 0,
				PhoneInput = 0,
				PrivacyText = 0,
				VerificationText = 0,
				LegalTextContainer = 0,
				LegalButtonsContainer = 0
			}

			local createElement3 = React.createElement
			local v16 = {
				LayoutOrder = 0,
				BackgroundTransparency = 1,
				Text = props.descriptionKey,
				TextSize = baseSize,
				TextColor3 = data.Theme.TextDefault.Color,
				TextTransparency = data.Theme.TextDefault.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0,
				AutomaticSize = 0
			}
			local v17 = if not foundationFontFaceMigration then data.Font.Body.Font else nil
			v16.Font = v17

			local v18 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.BodyLarge.Font) else nil
			v16.FontFace = v18

			v16.TextXAlignment = Enum.TextXAlignment.Left

			v16.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
			v16.AutomaticSize = Enum.AutomaticSize.Y
			children.BodyText = createElement3("TextLabel", v16)

			children.PhoneInput = React.createElement(textBoxStateWrapper, {
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
			})

			local createElement4 = React.createElement
			local v20 = {
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				Text = props.phonePrivacyDisclaimerKey,
				TextSize = baseSize * relativeSize2,
				TextColor3 = data.Theme.TextEmphasis.Color,
				TextTransparency = data.Theme.TextEmphasis.Transparency,
				Font = 0,
				FontFace = 0,
				TextXAlignment = 0,
				TextWrapped = true,
				Size = 0
			}
			local v21 = if not foundationFontFaceMigration then data.Font.Body.Font else nil
			v20.Font = v21

			local v22 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.BodyLarge.Font) else nil
			v20.FontFace = v22

			v20.TextXAlignment = Enum.TextXAlignment.Left

			v20.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 24)
			children.PrivacyText = createElement4("TextLabel", v20)

			local v23 = if fFlagHomePhoneVerificationUpsellNewCopy and v7.shouldShowVerificationText then React.createElement(text, {
				tag = "auto-y size-full-0 text-wrap text-body-small text-align-x-left",
				Text = props.verificationKey,
				LayoutOrder = 2
			}) else nil
			children.VerificationText = v23

			local v24 = not v7.disableLegalText

			if v24 then
				if v7.requireLegalTextCheckbox then
					local createElement5 = React.createElement
					local v26 = {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}
					local v27 = {
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
						LegalText = 0
					}

					local createElement6 = React.createElement
					local v29 = {
						BackgroundTransparency = 1,
						Text = props.legalTextKey,
						TextSize = baseSize * relativeSize2,
						TextColor3 = data.Theme.TextDefault.Color,
						TextTransparency = data.Theme.TextDefault.Transparency,
						Font = 0,
						FontFace = 0,
						TextXAlignment = 0,
						TextWrapped = true,
						Size = 0,
						AutomaticSize = 0
					}
					local v30 = if not foundationFontFaceMigration then data.Font.Body.Font else nil
					v29.Font = v30

					local v31 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.BodyLarge.Font) else nil
					v29.FontFace = v31

					v29.TextXAlignment = Enum.TextXAlignment.Left

					v29.Size = UDim2.new(1, -32, 0, 0)
					v29.AutomaticSize = Enum.AutomaticSize.Y
					v27.LegalText = createElement6("TextLabel", v29)
					v24 = createElement5("Frame", v26, v27)
				elseif v7.alwaysShowLegalText or v7.countryCode.prefix == "1" then
					local createElement5 = React.createElement
					local v26 = {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Text = props.legalTextKey,
						TextSize = baseSize * relativeSize2,
						TextColor3 = data.Theme.TextDefault.Color,
						TextTransparency = data.Theme.TextDefault.Transparency,
						Font = 0,
						FontFace = 0,
						TextXAlignment = 0,
						TextWrapped = true,
						Size = 0,
						AutomaticSize = 0
					}
					local v27 = if not foundationFontFaceMigration then data.Font.Body.Font else nil
					v26.Font = v27

					local v28 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.BodyLarge.Font) else nil
					v26.FontFace = v28

					v26.TextXAlignment = Enum.TextXAlignment.Left

					v26.Size = UDim2.new(0, partialPageModalMiddleContentWidth, 0, 0)
					v26.AutomaticSize = Enum.AutomaticSize.Y
					v24 = createElement5("TextLabel", v26)
				else
					v24 = nil
				end
			end

			children.LegalTextContainer = v24
			local v25

			if v7.countryCode.prefix == "1" then
				v25 = not v7.disableLegalText

				if v25 then
					local createElement5 = React.createElement
					local v27 = {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}
					local children2 = {
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
						TextButtonDivider = 0,
						PrivacyPolicyButton = 0
					}

					local createElement7 = React.createElement
					local v32 = {
						LayoutOrder = 6,
						BackgroundTransparency = 1,
						Text = "-",
						TextSize = baseSize * relativeSize2,
						TextColor3 = data.Theme.TextDefault.Color,
						TextTransparency = data.Theme.TextDefault.Transparency,
						Font = 0,
						FontFace = 0,
						TextXAlignment = 0,
						TextWrapped = true,
						AutomaticSize = 0
					}
					local v33 = if not foundationFontFaceMigration then data.Font.Body.Font else nil
					v32.Font = v33

					local v34 = if foundationFontFaceMigration then normalizeFontFace(data.Tokens.Typography.BodyLarge.Font) else nil
					v32.FontFace = v34

					v32.TextXAlignment = Enum.TextXAlignment.Center

					v32.AutomaticSize = Enum.AutomaticSize.XY
					children2.TextButtonDivider = createElement7("TextLabel", v32)

					children2.PrivacyPolicyButton = React.createElement(linkButton, {
						text = props.privacyPolicyKey,
						onActivated = v7.onPrivacyPolicyClick,
						layoutOrder = 7,
						fontStyle = "CaptionBody"
					})
					v25 = createElement5("Frame", v27, children2)
				end
			else
				v25 = false
			end

			children.LegalButtonsContainer = v25
			return createElement(partialPageModal, v11, {
				Middle = createElement2("Frame", v14, children)
			})
		end)
	end)
end

return AddPhoneView
