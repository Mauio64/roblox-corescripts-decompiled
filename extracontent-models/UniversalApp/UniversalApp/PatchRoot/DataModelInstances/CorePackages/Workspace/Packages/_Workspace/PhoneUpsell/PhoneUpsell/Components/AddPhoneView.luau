local PhoneUpsell = script:FindFirstAncestor("PhoneUpsell")
local PhoneUpsellParent = PhoneUpsell.Parent
local React = require(PhoneUpsellParent.React)
local UIBlox = require(PhoneUpsellParent.UIBlox)
local Foundation = require(PhoneUpsellParent.Foundation)
local Checkbox = Foundation.Checkbox
local FoundationText = Foundation.Text
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(PhoneUpsellParent.Localization).withLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local getPartialPageModalMiddleContentWidth = UIBlox.App.Dialog.Modal.getPartialPageModalMiddleContentWidth
local AuthCommon = require(PhoneUpsellParent.AuthCommon)
local TextBoxStateWrapper = AuthCommon.Components.TextBoxStateWrapper
local PhoneNumberTextBox = AuthCommon.Components.PhoneNumberTextBox
local LinkButton = UIBlox.App.Button.LinkButton
local mergeProps = require(PhoneUpsell.Utils.mergeProps)
local FFlagHomePhoneVerificationUpsellNewCopy = require(PhoneUpsellParent.SharedFlags).FFlagHomePhoneVerificationUpsellNewCopy
local t1 = {
	alwaysShowLegalText = false,
	requireLegalTextCheckbox = false,
	buttonKey = "Feature.VerificationUpsell.Action.Continue",
	legalTextKey = "Feature.VerificationUpsell.Description.ShortCodeLegalDisclaimerUA",
	shouldShowVerificationText = not FFlagHomePhoneVerificationUpsellNewCopy and nil
}

local function getButtonStackProps(s1: string, p1: ((...any) -> ...any), b1: boolean, s2: string, p2: ((...any) -> ...any)) -- line: 82
	-- upvalues: ButtonType (copy)
	local t2 = {{
		buttonType = ButtonType.PrimarySystem,
		props = {
			onActivated = p1,
			text = s1,
			isDisabled = b1
		}
	}}

	if s2 and s2 ~= "" then
		table.insert(t2, 1, {
			buttonType = ButtonType.Secondary,
			props = {
				isDisabled = false,
				onActivated = p2,
				text = s2
			}
		})
	end

	return {
		buttonHeight = 48,
		forcedFillDirection = Enum.FillDirection.Vertical,
		buttons = t2
	}
end
local function AddPhoneView(t3: {[any]: any}) -- line: 118
	-- upvalues: mergeProps (copy), t1 (copy), React (copy), getPartialPageModalMiddleContentWidth (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), withStyle (copy), withLocalization (copy), PartialPageModal (copy), getButtonStackProps (copy), TextBoxStateWrapper (copy), PhoneNumberTextBox (copy), FoundationText (copy), Checkbox (copy), LinkButton (copy)
	local v29 = mergeProps(t1, t3)

	local function noOp() -- line: 121
	end

	local v31, v32 = React.useState(false)
	local v33 = getPartialPageModalMiddleContentWidth(v29.screenSize.X)
	local t4 = {
		phoneNumberKey = "Feature.VerificationUpsell.Label.PhoneNumber",
		phonePrivacyDisclaimerKey = "Feature.VerificationUpsell.Description.PhoneNumberNeverPublic",
		termsOfUseKey = "Feature.VerificationUpsell.Action.TermsOfUse",
		privacyPolicyKey = "Feature.VerificationUpsell.Action.PrivacyPolicy",
		titleKey = v29.titleKey,
		descriptionKey = v29.descriptionKey,
		buttonKey = v29.buttonKey,
		legalTextKey = v29.legalTextKey,
		verificationKey = if not FFlagHomePhoneVerificationUpsellNewCopy then nil else "Feature.VerificationUpsell.Description.AddPhoneBody"
	}

	if v29.extraButtonKey and v29.extraButtonKey ~= "" then
		t4.extraButtonKey = v29.extraButtonKey
	end

	return withStyle(function(p3) -- line: 145
		-- upvalues: withLocalization (copy), t4 (copy), v29 (copy), v31 (copy), React (copy), PartialPageModal (copy), getButtonStackProps (copy), v33 (copy), TextBoxStateWrapper (copy), PhoneNumberTextBox (copy), noOp (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), FoundationText (copy), Checkbox (copy), v32 (copy), LinkButton (copy)
		return withLocalization(t4)(function(p4) -- line: 146
			-- upvalues: p3 (copy), v29 (copy), v31 (copy), React (copy), PartialPageModal (copy), getButtonStackProps (copy), v33 (copy), TextBoxStateWrapper (copy), PhoneNumberTextBox (copy), noOp (copy), FFlagHomePhoneVerificationUpsellNewCopy (copy), FoundationText (copy), Checkbox (copy), v32 (copy), LinkButton (copy)
			local BaseSize = p3.Font.BaseSize
			local RelativeSize = p3.Font.Body.RelativeSize
			local RelativeSize2 = p3.Font.CaptionHeader.RelativeSize
			local v40 = v29.isDisabled or v29.requireLegalTextCheckbox and not v31

			return React.createElement(PartialPageModal, {
				title = p4.titleKey,
				screenSize = v29.screenSize,
				buttonStackProps = getButtonStackProps(p4.buttonKey, v29.onSetPhoneNumber, v40, p4.extraButtonKey, v29.onExtraButtonClick),
				onCloseClicked = v29.onClose,
				position = v29.isKeyboardShowing and UDim2.new(0.5, 0, 1, -v29.keyboardHeight) or nil,
				anchorPoint = v29.isKeyboardShowing and Vector2.new(0.5, 1) or nil
			}, {
				Middle = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.new(1, 0, 0, 0)
				}, {
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
						TextWrapped = true,
						Text = p4.descriptionKey,
						TextSize = BaseSize,
						TextColor3 = p3.Theme.TextDefault.Color,
						TextTransparency = p3.Theme.TextDefault.Transparency,
						Font = p3.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(0, v33, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}),
					PhoneInput = React.createElement(TextBoxStateWrapper, {
						LayoutOrder = 1,
						ChildClass = PhoneNumberTextBox,
						ErrorState = v29.errorMessage ~= "",
						ErrorText = v29.errorMessage,
						Size = UDim2.new(1, 0, 0, 36),
						ChildProps = {
							ClearTextOnFocus = false,
							PaddingX = 12,
							CountryCode = v29.countryCode,
							SetCountryCode = v29.setCountryCode,
							Text = v29.phoneNumber,
							PlaceholderText = p4.phoneNumberKey,
							Font = p3.Font.Body.Font,
							TextSize = BaseSize * RelativeSize,
							TextXAlignment = Enum.TextXAlignment.Left,
							Color = p3.Theme.BackgroundUIContrast.Color,
							Transparency = p3.Theme.BackgroundUIContrast.Transparency,
							TextColor = p3.Theme.TextDefault.Color,
							PlaceholderColor = p3.Theme.UIDefault.Color,
							TextTransparency = p3.Theme.TextDefault.Transparency,
							TextInputTypeOverride = v29.usePhoneNumberTextType and Enum.TextInputType.Phone or Enum.TextInputType.Number,
							onChangeText = v29.onPhoneNumberTextChange,
							onFocused = v29.onPhoneInputFocus,
							onFocusLost = noOp,
							phoneCountryCodeSelectorCallback = v29.onCountryCodeSelectorClick
						}
					}),
					PrivacyText = React.createElement("TextLabel", {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = p4.phonePrivacyDisclaimerKey,
						TextSize = BaseSize * RelativeSize2,
						TextColor3 = p3.Theme.TextEmphasis.Color,
						TextTransparency = p3.Theme.TextEmphasis.Transparency,
						Font = p3.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(0, v33, 0, 24)
					}),
					VerificationText = if not FFlagHomePhoneVerificationUpsellNewCopy or not v29.shouldShowVerificationText then nil else React.createElement(FoundationText, {
						tag = "auto-y size-full-0 text-wrap text-body-small text-align-x-left",
						LayoutOrder = 2,
						Text = p4.verificationKey
					}),
					LegalTextContainer = not v29.disableLegalText and if not v29.requireLegalTextCheckbox then if not v29.alwaysShowLegalText and v29.countryCode.prefix ~= "1" then nil else React.createElement("TextLabel", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						TextWrapped = true,
						Text = p4.legalTextKey,
						TextSize = BaseSize * RelativeSize2,
						TextColor3 = p3.Theme.TextDefault.Color,
						TextTransparency = p3.Theme.TextDefault.Transparency,
						Font = p3.Font.Body.Font,
						TextXAlignment = Enum.TextXAlignment.Left,
						Size = UDim2.new(0, v33, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}) else React.createElement("Frame", {
						LayoutOrder = 3,
						BackgroundTransparency = 1,
						Size = UDim2.new(0, v33, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 6)
						}),
						LegalCheckbox = React.createElement(Checkbox, {
							label = "",
							onActivated = v32,
							isChecked = v31
						}),
						LegalText = React.createElement("TextLabel", {
							BackgroundTransparency = 1,
							TextWrapped = true,
							Text = p4.legalTextKey,
							TextSize = BaseSize * RelativeSize2,
							TextColor3 = p3.Theme.TextDefault.Color,
							TextTransparency = p3.Theme.TextDefault.Transparency,
							Font = p3.Font.Body.Font,
							TextXAlignment = Enum.TextXAlignment.Left,
							Size = UDim2.new(1, -32, 0, 0),
							AutomaticSize = Enum.AutomaticSize.Y
						})
					}),
					LegalButtonsContainer = v29.countryCode.prefix == "1" and (not v29.disableLegalText and React.createElement("Frame", {
						LayoutOrder = 4,
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						UIListLayout = React.createElement("UIListLayout", {
							FillDirection = Enum.FillDirection.Horizontal,
							SortOrder = Enum.SortOrder.LayoutOrder,
							HorizontalAlignment = Enum.HorizontalAlignment.Center,
							VerticalAlignment = Enum.VerticalAlignment.Center,
							Padding = UDim.new(0, 5)
						}),
						TermsOfUseButton = React.createElement(LinkButton, {
							layoutOrder = 5,
							fontStyle = "CaptionBody",
							text = p4.termsOfUseKey,
							onActivated = v29.onTermsOfUseClick,
							size = UDim2.fromScale(0.2, 0.2)
						}),
						TextButtonDivider = React.createElement("TextLabel", {
							LayoutOrder = 6,
							BackgroundTransparency = 1,
							Text = "-",
							TextWrapped = true,
							TextSize = BaseSize * RelativeSize2,
							TextColor3 = p3.Theme.TextDefault.Color,
							TextTransparency = p3.Theme.TextDefault.Transparency,
							Font = p3.Font.Body.Font,
							TextXAlignment = Enum.TextXAlignment.Center,
							AutomaticSize = Enum.AutomaticSize.XY
						}),
						PrivacyPolicyButton = React.createElement(LinkButton, {
							layoutOrder = 7,
							fontStyle = "CaptionBody",
							text = p4.privacyPolicyKey,
							onActivated = v29.onPrivacyPolicyClick
						})
					}))
				})
			})
		end)
	end)
end

return AddPhoneView
